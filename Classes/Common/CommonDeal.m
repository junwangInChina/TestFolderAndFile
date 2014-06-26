//
//  CommonDeal.m
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "CommonDeal.h"
#import "FileModel.h"
#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>

@implementation CommonDeal

/*!
 @method
 @abstract     获取文件管理器
 @discussion
 @param
 @result       返回一个文件管理器
 */
+ (NSFileManager *)getFileManagement
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return fileManager;
}

/*!
 @method
 @abstract     获取根目录路径
 @discussion
 @param
 @result       返回根目录的路径
 */
+ (NSString *)getHomePath
{
    NSString *homeString = NSHomeDirectory();
    
    return homeString;
}

/*!
 @method
 @abstract     获取Document目录路径
 @discussion
 @param
 @result       返回Document目录的路径
 */
+ (NSString *)getDocumentPath
{
    NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [documentArray objectAtIndex:0];
    
    return documentPath;
}

/*!
 @method
 @abstract     获取Library目录路径
 @discussion
 @param
 @result       返回Library目录的路径
 */
+ (NSString *)getLibraryPath
{
    NSArray *libraryArray = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryPath = [libraryArray objectAtIndex:0];
    
    return libraryPath;
}

/*!
 @method
 @abstract     获取Tmp目录路径
 @discussion
 @param
 @result       返回Tmp目录的路径
 */
+ (NSString *)getTmpPath
{
    NSString *tempPath = NSTemporaryDirectory();
    
    return tempPath;
}

/*!
 @method
 @abstract     获取Cache目录路径
 @discussion
 @param
 @result       返回Cache目录的路径
 */
+ (NSString *)getCachePath
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return cachePath;
}

/*!
 @method
 @abstract     获取某个路径下的所有文件（包括文件夹与文件）
 @discussion
 @param        path_:需要获取哪个路径下的文件
 @result       返回传入路径下的所有文件
 */
+ (NSArray *)getAllFileWithPath:(NSString *)path_
{
    NSFileManager *fileManager_ = [self getFileManagement];
    NSError *error = nil;
    NSArray *allFileArray = [fileManager_ contentsOfDirectoryAtPath:path_ error:&error];
    
    NSMutableArray *fileModelArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSString *fileName in allFileArray)
    {
        NSString *filePath = [path_ stringByAppendingPathComponent:fileName];
        FileModel *fileModel = [[FileModel alloc] init];
        fileModel.m_fileName = fileName;
        fileModel.m_filePath = path_;
        fileModel.m_fileCreateDate = [self getFileCreateDate:filePath];
        fileModel.m_fileSizer = [self getFileSizer:filePath];
        fileModel.m_fileType = [self getFileType:fileName];
        fileModel.m_fileImageName = [self getFileIconImageName:[self getFileType:fileName]];
        fileModel.m_fileSortDate = [self getFileSortDate:filePath];
        [fileModelArray addObject:fileModel];
    }
    return fileModelArray;
}

/*!
 @method
 @abstract     获取某个文件的创建日期
 @discussion
 @param        filePath:文件路径
 @result       返回该文件的创建日期
 */
+ (NSString *)getFileCreateDate:(NSString *)filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    
    NSDate *createDate = [attributes objectForKey:NSFileCreationDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:createDate]];
    
    return dateString;
}

/*!
 @method
 @abstract     获取某个文件的创建日期,用于排序
 @discussion
 @param        filePath:文件路径
 @result       返回该文件的创建日期，包括时分秒
 */
+ (NSString *)getFileSortDate:(NSString *)filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    
    NSDate *createDate = [attributes objectForKey:NSFileCreationDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    NSString *dateString = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:createDate]];
    
    return dateString;
}

/*!
 @method
 @abstract     获取某个文件的大小
 @discussion
 @param        filePath:文件路径
 @result       返回该文件的大小
 */
+ (NSString *)getFileSizer:(NSString *)filePath
{
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    
    //大小
    NSNumber *fileSize = (NSNumber *)[attributes objectForKey:NSFileSize];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.## bytes"];
    
    NSString *sizerString = [NSString stringWithFormat:@"%@",[numberFormatter stringFromNumber:fileSize]];
    
    return sizerString;
}

/*!
 @method
 @abstract     获取某个文件的文件类型
 @discussion
 @param        fileName:文件名称
 @result       返回该文件的文件类型
 */
+ (NSString *)getFileType:(NSString *)fileName
{
    if ([self checkFileName:fileName andOther:@"."])
    {
        NSArray *array = [fileName componentsSeparatedByString:@"."];
        // 获取文件后缀
        NSString *typeStr = [NSString stringWithFormat:@"%@",[array objectAtIndex:[array count]-1]];
        // 全部转成小写，方便判断
        typeStr = [typeStr lowercaseString];
        if ([typeStr isEqualToString:@"png"] ||
            [typeStr isEqualToString:@"jpg"] ||
            [typeStr isEqualToString:@"bmp"])
        {
            return @"1"; // 表示图片类型
        }
        else if ([typeStr isEqualToString:@"mp4"] ||
                 [typeStr isEqualToString:@"mov"] ||
                 [typeStr isEqualToString:@"mv4"])
        {
            return @"2"; // 表示视频
        }
        else if ([typeStr isEqualToString:@"mp3"] ||
                 [typeStr isEqualToString:@"aac"])
        {
            return @"3"; // 表示音频
        }
        else if ([typeStr isEqualToString:@"txt"] ||
                 [typeStr isEqualToString:@"rtf"])
        {
            return @"4"; // 表示文档类型 txt.rtf
        }
        else if ([typeStr isEqualToString:@"html"] ||
                 [typeStr isEqualToString:@"htm"])
        {
            return @"5"; // 网页
        }
        else if ([typeStr isEqualToString:@"pdf"])
        {
            return @"6"; // PDF文档
        }
        else
        {
            return @"100"; // 未知类型
        }
    }
    else
    {
        return @"100"; // 未知类型
    }
}

/*!
 @method
 @abstract     获取某个文件文件图标名称
 @discussion
 @param        fileType:文件类型
 @result       返回该文件的图标名
 */
+ (NSString *)getFileIconImageName:(NSString *)fileType
{
    NSString *iconNameString = @"";
    
    switch ([fileType intValue])
    {
        case 1:
            iconNameString = @"image.png";
            break;
        case 2:
            iconNameString = @"video.png";
            break;
        case 3:
            iconNameString = @"music.png";
            break;
        case 4:
            iconNameString = @"file.png";
            break;
        case 5:
            iconNameString = @"html.png";
            break;
        case 6:
            iconNameString = @"pdf.png";
            break;
        default:
            iconNameString = @"unknown.png";
            break;
    }
    
    return iconNameString;
}

/*!
 @method
 @abstract     获取某个路径下的所有文件（不包括文件夹）
 @discussion
 @param        path_:需要获取哪个路径下的文件
 @result       返回传入路径下的所有文件
 */
+ (NSArray *)getOnlyFileWithPath:(NSString *)path_
{
    NSFileManager *fileManager = [self getFileManagement];
    NSArray *allArray = [self getAllFileWithPath:path_];
    NSMutableArray *folderArray = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL isDirectory = NO;
    for (NSString *file in allArray)
    {
        NSString *folderPath = [path_ stringByAppendingPathComponent:file];
        // 判断当前路径下的文件是否为文件夹
        [fileManager fileExistsAtPath:folderPath isDirectory:(&isDirectory)];
        if (!isDirectory)
        {
            [folderArray addObject:file];
        }
        isDirectory = NO;
    }
    
    return folderArray;
}

/*!
 @method
 @abstract     获取某个路径下的所有文件夹
 @discussion
 @param        path_:需要获取哪个路径下的文件夹
 @result       返回传入路径下的所有文件夹
 */
+ (NSArray *)getOnlyFolderWithPath:(NSString *)path_
{
    NSFileManager *fileManager = [self getFileManagement];
    NSArray *allArray = [self getAllFileWithPath:path_];
    NSMutableArray *folderArray = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL isDirectory = NO;
    for (NSString *file in allArray)
    {
        NSString *folderPath = [path_ stringByAppendingPathComponent:file];
        // 判断当前路径下的文件是否为文件夹
        [fileManager fileExistsAtPath:folderPath isDirectory:(&isDirectory)];
        if (isDirectory)
        {
            [folderArray addObject:file];
        }
        isDirectory = NO;
    }
    
    return folderArray;
}

/*!
 @method
 @abstract     根据传入的路径，判断当前文件是否是文件夹
 @discussion
 @param        path_:当前选择文件的路径
 @result       返回该文件是否为文件夹
 */
+ (BOOL)chectIsFolder:(NSString *)path_
{
    BOOL isDirectory;
    if ([[self getFileManagement] fileExistsAtPath:path_ isDirectory:&isDirectory] && isDirectory)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*!
 @method
 @abstract     根据传入的路径，判断当前目录是否可写
 @discussion
 @param        path_:当前目录的路径
 @result       返回该目录是否可写
 */
+ (BOOL)chectIsCanBeWriter:(NSString *)path_
{
    BOOL isCanBeWriter = [[self getFileManagement] isWritableFileAtPath:path_];
    
    return isCanBeWriter;
}

/*!
 @method
 @abstract     根据传入的路径与名称，创建新文件夹
 @discussion
 @param        directoryPath:当前选择的目录路径  folderName:需要创建的文件夹名称
 @result
 */
+ (void)createNewFolder:(NSString *)directoryPath andFolderName:(NSString *)folderName
{
    NSString *path = [directoryPath stringByAppendingPathComponent:folderName];
    
    // 先判断当前需要创建的文件夹是否已经存在
    if ([[self getFileManagement] fileExistsAtPath:path])
    {
        [self showAlertWithTitle:@"Information" andMsgBody:@"文件夹已存在"];
    }
    else
    {
        BOOL createSuccess = [[self getFileManagement] createDirectoryAtPath:path
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:nil];
        if (!createSuccess)
        {
            [self showAlertWithTitle:@"Error" andMsgBody:@"Create failed"];
        }
    }
}

/*!
 @method
 @abstract     根据传入的路径与名称，创建新文件
 @discussion
 @param        directoryPath:当前选择的目录路径  fileName:需要创建的文件名称
 @result
 */
+ (void)createNewFile:(NSString *)directoryPath andFileName:(NSString *)fileName andData:(NSData *)data
{
    NSFileManager *filemanager = [self getFileManagement];
    // 如果后缀没带.txt 或 .rtf，保存的时候会加上一个.txt
    if (![[self getFileType:fileName] isEqualToString:@"4"])
    {
        fileName = [NSString stringWithFormat:@"%@.txt",fileName];
    }
    NSString *path = [directoryPath stringByAppendingPathComponent:fileName];
    
    // 先判断文件是否存在，存在则直接写入，否则创建
    if (![[self getFileManagement] fileExistsAtPath:path])
    {
        //更改到待操作的目录下
        [filemanager changeCurrentDirectoryPath:[directoryPath stringByExpandingTildeInPath]];
        
        //创建文件fileName文件名称，初始化 contents文件的内容，attributes文件的属性，初始为nil
        [filemanager createFileAtPath:fileName contents:nil attributes:nil];
    }
    if (data)
    {
        // 将内容写入文件
        [data writeToFile:path atomically:YES];
    }
}

/*!
 @method
 @abstract     根据传入的路径与名称，读取文件内容
 @discussion
 @param        path_:当前文件所在路径  fileName:文件名
 @result       返回文件内容
 */
+ (NSData *)getfileInfo:(NSString *)path_ andFileName:(NSString *)fileName
{
    NSString *filePath = [path_ stringByAppendingPathComponent:fileName];
    NSData *infoData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    return infoData;
}

/*!
 @method
 @abstract     根据传入的路径删除文件
 @discussion
 @param        path_:需要删除的文件路径   目录路径＋文件名
 @result       返回删除成功标识
 */
+ (void)deleteFile:(NSString *)path_ andFileName:(NSString *)fileName
{
    NSError *error;
    // 这里的路径就是文件所在目录的路径＋文件本身名称
    BOOL deleteSuccess = [[self getFileManagement] removeItemAtPath:path_ error:&error];
    
    if (!deleteSuccess)
    {
        [self showAlertWithTitle:@"Error" andMsgBody:[error localizedDescription]];
    }
}

/*!
 @method
 @abstract     上传图片
 @discussion
 @param        path_:上传的目录路径  image_:上传的图片
 @result
 */
+ (void)upLoadImageWithPath:(NSString *)path_ andImage:(UIImage *)image_
{
    NSData *imageData ;
    NSString *imageName;
    if (UIImagePNGRepresentation(image_) == nil)
    {
        imageData = UIImageJPEGRepresentation(image_, 1);
        imageName = [NSString stringWithFormat:@"%@.jpg",[self getNowDateTime]];
    }
    else
    {
        imageData = UIImagePNGRepresentation(image_);
        imageName = [NSString stringWithFormat:@"%@.png",[self getNowDateTime]];
    }
    NSString *filePath_ = [path_ stringByAppendingPathComponent:imageName];
    [[self getFileManagement] createFileAtPath:filePath_ contents:imageData attributes:nil];
}

/*!
 @method
 @abstract     判断当前文件是否是个图片
 @discussion
 @param        fileName:需要判断的文件名
 @result
 */
+ (BOOL)checkIsImage:(NSString *)fileName
{
    if ([self checkFileName:fileName andOther:@"."])
    {
        NSArray *array = [fileName componentsSeparatedByString:@"."];
        if ([[array objectAtIndex:[array count] -1] isEqualToString:@"png"] ||
            [[array objectAtIndex:[array count] -1] isEqualToString:@"jpg"])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

/*!
 @method
 @abstract     判断一个字符串中是否含 另一个字符串
 @discussion
 @param        fileName:原字符串  otherStr:需要判断的字符串
 @result
 */
+ (BOOL)checkFileName:(NSString *)fileName andOther:(NSString *)otherStr
{
    NSRange range = [fileName rangeOfString:otherStr];
    /**
     range.location 表示起始位置，从0开始
     range.length   表示长度
     */
    if (range.length > 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*!
 @method
 @abstract     获取当前时间转换为字符串格式
 @discussion
 @param
 @result       返回当前时间字符串
 */
+ (NSString *)getNowDateTime
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MMddHHmmss"];
    NSString *str = [dateformat stringFromDate:nowDate];
    return str;
}

/*!
 @method
 @abstract     修改文件夹名称
 @discussion
 @param        oldName:需要修改的文件夹名称  newName:修改后的名称  path_:文件夹所在路径
 @result       返回当前时间字符串
 */
+ (void)updateFileNameWithOldName:(NSString *)oldName
                       andNewName:(NSString *)newName
                          andPath:(NSString *)path_
{
    NSError *error;
    NSString *oldPath = [path_ stringByAppendingPathComponent:oldName];
    NSString *newPath = [path_ stringByAppendingPathComponent:newName];
    BOOL updateSuccess = [[self getFileManagement] moveItemAtPath:oldPath toPath:newPath error:&error];
    
    if (!updateSuccess)
    {
        [self showAlertWithTitle:@"Error" andMsgBody:[error localizedDescription]];
    }
}

/*!
 @method
 @abstract     按照用户名排序
 @discussion
 @param        oldArray:老数组
 @result       返回排序后的数组
 */
+ (NSArray *)sortByName:(NSArray *)oldArray
{
    // 顺序排序 A-->B--C-->a-->b-->c
    NSSortDescriptor *m_sort = [[NSSortDescriptor alloc] initWithKey:@"m_fileName" ascending:YES];
    NSArray *sortArray = [NSArray arrayWithObjects:m_sort,nil];
    NSArray *tempArray = [oldArray sortedArrayUsingDescriptors:sortArray];
    
    return tempArray;
}

/*!
 @method
 @abstract     按照创建时间排序
 @discussion
 @param        oldArray:老数组
 @result       返回排序后的数组
 */
+ (NSArray *)sortByCreateDate:(NSArray *)oldArray
{
    NSSortDescriptor *m_sort = [[NSSortDescriptor alloc] initWithKey:@"m_fileSortDate" ascending:NO];
    NSArray *sortArray = [NSArray arrayWithObjects:m_sort,nil];
    NSArray *tempArray = [oldArray sortedArrayUsingDescriptors:sortArray];
    
    return tempArray;
}

/*!
 @method
 @abstract     将文件夹移动到另一个目录
 @discussion
 @param        oldPath:移动前的目录路径  newPath:需要移动到的路径  folderName:需要移动的文件夹名称  isCopy:表示复制
 @result       返回是否移动成功标志
 */
+ (void)moveFolderWithOldPath:(NSString *)oldPath
                   andNewPath:(NSString *)newPath
                andFolderName:(NSString *)folderName
                      andCopy:(BOOL)isCopy
{
    NSError *error;
    BOOL updateSuccess;
    NSString *oldFilePath_ = [oldPath stringByAppendingPathComponent:folderName];
    NSString *newFilePath_ = [newPath stringByAppendingPathComponent:folderName];
    
    if (isCopy)
    {
        // 复制移动
        updateSuccess = [[self getFileManagement] copyItemAtPath:oldFilePath_ toPath:newFilePath_ error:&error];
    }
    else
    {
        // 剪切移动
        updateSuccess = [[self getFileManagement] moveItemAtPath:oldFilePath_ toPath:newFilePath_ error:&error];
    }
    
    
    if (updateSuccess)
    {
        [self showAlertWithTitle:@"Success"
                      andMsgBody:@"Move Success"];
    }
    else
    {
        [self showAlertWithTitle:@"Error"
                      andMsgBody:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    }
}

/*!
 @method
 @abstract     弹出提示框
 @discussion
 @param        msgTitle:提示框标题  msgBody:提示框信息
 @result
 */
+ (void)showAlertWithTitle:(NSString *)msgTitle andMsgBody:(NSString *)msgBody
{
    UIAlertView *alert_ = [[UIAlertView alloc] initWithTitle:msgTitle
                                                     message:msgBody
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil, nil];
    [alert_ show];
}

/*!
 @method
 @abstract     判断某个文件是否已经存在
 @discussion
 @param        fileDirectoryPath:需要判断的文件所在目录  fileName:文件名称
 @result
 */
+ (BOOL)fileIsAleradyExists:(NSString *)fileDirectoryPath andFileName:(NSString *)fileName
{
    NSString *filePath = [fileDirectoryPath stringByAppendingPathComponent:fileName];
    if ([[self getFileManagement] fileExistsAtPath:filePath])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/*!
 @method
 @abstract      通过本地视频存储URL，获取该视频的缩略图
 @discussion
 @param         vedioPath:本地视频存储URL
 @result        返回该视频的缩略图
 */
+ (UIImage *)getVideoThumbnailImage:(NSString *)videoPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *image_ = [[UIImage alloc] initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image_;
}

/*!
 @method
 @abstract      通过本地视频存储URL，获取该视频的缩略图
 @discussion    使用MPMoviePlayerController视频播放类获取
 @param         vedioPath:本地视频存储URL
 @result        返回该视频的缩略图
 */
+ (UIImage *)getVideoImage:(NSString *)vedioPath
{
    NSURL *videoURL = [NSURL fileURLWithPath:vedioPath];
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
    UIImage *image_ = [moviePlayer thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    return image_;
}

@end
