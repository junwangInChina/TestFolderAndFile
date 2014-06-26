//
//  CreateFileViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "CreateFileViewController.h"
#import "CreateFileView.h"
#import "DetailViewController.h"
#import "AudioViewController.h"

@interface CreateFileViewController ()<CreateFileViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,NSStreamDelegate>
{
    NSInputStream *m_inputStream;
    NSOutputStream *m_outputStream;
}

@property (nonatomic, retain) NSInputStream *m_inputStream;
@property (nonatomic, retain) NSOutputStream *m_outputStream;

@end

@implementation CreateFileViewController
@synthesize m_currentDicPath;
@synthesize m_inputStream;
@synthesize m_outputStream;

- (void)dealloc
{
    self.m_currentDicPath = nil;
    self.m_inputStream = nil;
    self.m_outputStream = nil;
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.title = @"Create File";
    
    CreateFileView *createView = [[CreateFileView alloc] initWithFrame:self.view.bounds];
    createView.createFile_delegate = self;
    [self.view addSubview:createView];
    [createView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - Create Method
// 用户选择何种方式创建文件
- (void)userChooseCreate:(int)index
{
    switch (index)
    {
        case 0:
            // 创建文件
            [self createFile];
            break;
        case 1:
            // 本地上传图片
            [self uploadLocalPicture];
            break;
        case 2:
            // 拍照上传图片
            [self uploadCameraPicture];
            break;
        case 3:
            // 本地视频上传
            [self uploadLocalVedio];
            break;
        case 4:
            // 视频录制上传
            [self uploadCameraVedio];
            break;
        case 5:
            // 音频文件上传
            [self uploadAudio];
            break;
        default:
            break;
    }
}

// 创建文件
- (void)createFile
{
    DetailViewController *detailConteol = [[DetailViewController alloc] init];
    [detailConteol setM_currentPath:self.m_currentDicPath];
    [detailConteol setTitle:@"Add New File"];
    [detailConteol setM_showDetail:NO];
    [self.navigationController pushViewController:detailConteol animated:YES];
    [detailConteol release];
}

// 本地相片上传
- (void)uploadLocalPicture
{
    UIImagePickerController *imagePickerCon = [[UIImagePickerController alloc] init];
    imagePickerCon.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerCon.delegate = self;
    // 要让用户可以随意移动以及缩放图像，可以将 allowsEditing 属性设置为 YES,打开图像编辑功能：
    imagePickerCon.allowsEditing = YES;
    [self presentViewController:imagePickerCon animated:YES completion:nil];
    
    [imagePickerCon release];
}

// 拍照相片上传
- (void)uploadCameraPicture
{
    // 先判断当前设备是否支持摄像头
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePic = [[UIImagePickerController alloc] init];
        imagePic.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePic.delegate = self;
        // 要让用户可以随意移动以及缩放图像，可以将 allowsEditing 属性设置为 YES,打开图像编辑功能：
        imagePic.allowsEditing = YES;
        [self presentViewController:imagePic animated:YES completion:nil];
        
        [imagePic release];
    }
    else
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"Sorry you can not user camera"];
    }
}

// 本地视频上传
- (void)uploadLocalVedio
{
    UIImagePickerController *imagePickerCon = [[UIImagePickerController alloc] init];
    imagePickerCon.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerCon.delegate = self;
    // 视频质量
    imagePickerCon.videoQuality = UIImagePickerControllerQualityTypeMedium;
    // 视频录制时间
    imagePickerCon.videoMaximumDuration = 30.f;
    // 多媒体类型（设置为视频）
    imagePickerCon.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    // 要让用户可以随意移动以及缩放视频，可以将 allowsEditing 属性设置为 YES,打开视频编辑功能：
    imagePickerCon.allowsEditing = YES;
    [self presentViewController:imagePickerCon animated:YES completion:nil];
    
    [imagePickerCon release];
}

// 视频录制上传
- (void)uploadCameraVedio
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerCon = [[UIImagePickerController alloc] init];
        imagePickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerCon.delegate = self;
        // 视频质量
        imagePickerCon.videoQuality = UIImagePickerControllerQualityTypeMedium;
        // 视频录制时间
        imagePickerCon.videoMaximumDuration = 30.f;
        // 多媒体类型（设置为视频）
        imagePickerCon.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
        // 要让用户可以随意移动以及缩放视频，可以将 allowsEditing 属性设置为 YES,打开视频编辑功能：
        imagePickerCon.allowsEditing = YES;
        [self presentViewController:imagePickerCon animated:YES completion:nil];
        
        [imagePickerCon release];
    }
    else
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"Sorry you can not user camera"];
    }
    
}

- (void)uploadAudio
{
    AudioViewController *audioControl = [[AudioViewController alloc] init];
    [audioControl setM_currentDirectorPath:self.m_currentDicPath];
    [self.navigationController pushViewController:audioControl animated:YES];
    [audioControl release];
    
}

#pragma mark - ImagePickerController Delegate Method
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 获取当前多媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 表示图片
    if ([mediaType isEqualToString:@"public.image"])
    {
        /**
         获取到选择的图片
         UIImagePickerControllerOriginalImage 获取原图片
         UIImagePickerControllerEditedImage   获取编辑后的图片，即当allowsEditing设置为YES时，编辑后的图片可通过这key获取。
         */
        UIImage *image_ = [info objectForKey:UIImagePickerControllerEditedImage];
        
        // 如果是拍照的相片则需要存进相册，
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            /**
             UIImageWriteToSavedPhotosAlbum 此方法将拍下来的相片存储到设备的相册中去
             */
            UIImageWriteToSavedPhotosAlbum(image_, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
        }
        
        /**
         将图片保存
         */
        [CommonDeal upLoadImageWithPath:self.m_currentDicPath andImage:image_];
    }
    // 表示视频
    else if ([mediaType isEqualToString:@"public.movie"])
    {
        // 当前视频在视频库中的地址（使用这个地址是无法播放的）
        NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
        
        // 如果当前是录像，则视频还需要存储到本地库中去
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
            
            if (compatible)
            {
                UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
            }
        }
        
        // 调用方法将视频存储到本地
        [self saveMovieToDocumentWithUrl:url];
        
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 存储图片到本地库的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //NSString *errorStr = [NSString stringWithFormat:@"Sorry Error writer to photo album :%@",[error localizedDescription]];
    
    if (error)
    {
        // 图片保存失败
        //[CommonDeal showAlertWithTitle:@"Error" andMsgBody:errorStr];
    }
    else
    {
        // 图片保存成功
        //[CommonDeal showAlertWithTitle:@"Success" andMsgBody:@"Image writer to photo album"];
    }
}

// 存储视频到本地库的方法
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    //NSString *errorStr = [NSString stringWithFormat:@"Sorry Error writer to photo album :%@",[error localizedDescription]];
    
    if (error)
    {
        // 视频保存失败
        //[CommonDeal showAlertWithTitle:@"Error" andMsgBody:errorStr];
    }
    else
    {
        // 视频保存成功
        //[CommonDeal showAlertWithTitle:@"Success" andMsgBody:@"video writer to photo album"];
    }
}

#pragma mark - NSStream Delegate

// 将视频存储到本地文件
- (void)saveMovieToDocumentWithUrl:(NSURL *)videoURL
{
    NSString *videoName = [NSString stringWithFormat:@"%@.mov",[CommonDeal getNowDateTime]];
    NSString *videoPath = [self.m_currentDicPath stringByAppendingPathComponent:videoName];
    
    self.m_inputStream = [[[NSInputStream alloc] initWithURL:videoURL] autorelease];
    m_inputStream.delegate = self;
    [m_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [m_inputStream open];
    
    self.m_outputStream = [[[NSOutputStream alloc] initToFileAtPath:videoPath append:YES] autorelease];
    [m_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [m_outputStream open];
}

// 输入流InputStream的委托方法，在这里面实现将视频写入到本地文件
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch (eventCode)
    {
        case NSStreamEventNone:
            break;
        case NSStreamEventHasSpaceAvailable:
            break;
        case NSStreamEventErrorOccurred:
            break;
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
        {
            const NSUInteger BufferSize = 1024*256;
            uint8_t	buffer[BufferSize];
            
            NSUInteger read = [self.m_inputStream read:buffer maxLength:BufferSize];
            
            if (read != 0)
            {
                [self.m_outputStream write:buffer maxLength:read];
            }
        }
            break;
        case NSStreamEventEndEncountered://连接断开或结束
        {
            [CommonDeal showAlertWithTitle:@"Success" andMsgBody:@"video writer to document success"];
        }
        break;
    }
}

- (void)backToPopPage
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
