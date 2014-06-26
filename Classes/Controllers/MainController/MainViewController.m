//
//  MainViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "ShowGidView.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"
#import "CreateFileViewController.h"
#import "ShowViewController.h"
#import "AppContextManagement.h"
#import "DownLoadViewController.h"

@interface MainViewController ()<MainViewDelegate,ShowGidViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    MainView *m_mainView;
    
    ShowGidView *m_showGidView;
    
    UITextField *m_folderTextField;
    
    // 表示多选删除时，选中的行数集合
    NSMutableArray *m_chooseDeleteArray;
    
    NSMutableArray *m_allFileArray;
    
    NSString *m_updateOldFolderNameString;
}

@property (nonatomic, strong) NSMutableArray *m_chooseDeleteArray;
@property (nonatomic, strong) NSMutableArray *m_allFileArray;
@property (nonatomic, strong) NSString *m_updateOldFolderNameString;

@end

@implementation MainViewController
@synthesize m_currentDirectoryPath;
@synthesize m_chooseDeleteArray;
@synthesize m_updateOldFolderNameString;
@synthesize m_allFileArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        m_mainView.hidden = NO;
        m_showGidView.hidden = YES;
    }
    else
    {
        m_mainView.hidden = YES;
        m_showGidView.hidden = NO;
    }
    
    [self.m_allFileArray removeAllObjects];
    [self searchDirectoryAndShow];
}

// 查询展示
- (void)searchDirectoryAndShow
{
    dispatch_queue_t dispatchQueue = dispatch_queue_create("com.epro.Dispatch", NULL);
    dispatch_async(dispatchQueue, ^{
        
        self.m_allFileArray = (NSMutableArray *)[CommonDeal getAllFileWithPath:self.m_currentDirectoryPath];
        
        if (self.m_allFileArray && self.m_allFileArray != (NSMutableArray *)[NSNull null])
        {
            // 数据读取完成，通过调用主队列，将刷新页面的操作放入主线程中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (m_mainView.hidden)
                {
                    [m_showGidView sentUserToShowArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
                }
                else
                {
                    [m_mainView sentFileArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
                }
                
                if (self.m_allFileArray == nil || [self.m_allFileArray count] == 0)
                {
                    [self tableViewCanceledit];
                }
                
            });
        }
        
    });
     
    /*
    [self.m_allFileArray removeAllObjects];
    self.m_allFileArray = (NSMutableArray *)[CommonDeal getAllFileWithPath:self.m_currentDirectoryPath];
    if (m_mainView.hidden)
    {
        [m_showGidView sentUserToShowArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
    else
    {
        [m_mainView sentFileArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
    
    if (self.m_allFileArray == nil || [self.m_allFileArray count] == 0)
    {
        [self tableViewCanceledit];
    }
     */
}

- (void)loadView
{
    [super loadView];
    
    /*
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(createNew)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Edit"
                                             style:UIBarButtonItemStyleBordered
                                             target:self
                                             action:@selector(editPress)];
     */
    UIBarButtonItem *createItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(createNew)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editPress)];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deletePress)];
    deleteItem.enabled = NO;
    
    NSArray *iTemArray = [[NSArray alloc] initWithObjects:createItem,editItem,deleteItem, nil];
    self.navigationItem.rightBarButtonItems = iTemArray;
    
    m_mainView = [[MainView alloc] initWithFrame:self.view.bounds];
    m_mainView.main_delegate = self;
    [self.view addSubview:m_mainView];
    
    m_showGidView = [[ShowGidView alloc] initWithFrame:self.view.bounds];
    m_showGidView.showGid_delegate = self;
    [self.view addSubview:m_showGidView];
    
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        m_mainView.hidden = NO;
        m_showGidView.hidden = YES;
    }
    else
    {
        m_mainView.hidden = YES;
        m_showGidView.hidden = NO;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.m_chooseDeleteArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.m_allFileArray = [[NSMutableArray alloc] initWithCapacity:0];
}

// 点击开始编辑
- (void)editPress
{
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        [m_mainView sentUserEditTableView:^(BOOL isEditing){
            
            [self changeBarButtonType:isEditing];
        }];
    }
    else
    {
        __block MainViewController *blockSelf = self;
        
        [m_showGidView setGidViewBeEdit:^(BOOL isEdit){
            
            [blockSelf changeBarButtonType:isEdit];
        }];
    }
}

// 表格编辑，修改导航按钮状态
- (void)changeBarButtonType:(BOOL)edit
{
    if (edit)
    {
        [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setTitle:@"Down"];
        
    }
    else
    {
        [[self.navigationItem.rightBarButtonItems objectAtIndex:1] setTitle:@"Edit"];
        
        // 取消编辑
        [self cancelEdit];
    }
    
    [self changeDeleteBtnType];
}

- (void)cancelEdit
{
    // 移除数组里的所有保存File
    [self.m_chooseDeleteArray removeAllObjects];
    
    // 将所有的File修改为未选中，并发送到视图展示
    for (int i = 0; i<[self.m_allFileArray count]; i++)
    {
        [[self.m_allFileArray objectAtIndex:i] setM_fileIsChoose:@"0"];
    }
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        [m_mainView sentFileArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
    else
    {
        [m_showGidView sentUserToShowArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
}

// 设置表格不再编辑，用于处于编辑状态时进入下级目录，可还原编辑状态
- (void)tableViewCanceledit
{
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        // 设置表格编辑状态还原
        [m_mainView sentTableCancelEdit];
    }
    else
    {
        // 九宫格取消编辑
        [m_showGidView cancelEditTypeGid];
    }
    
    [self changeBarButtonType:NO];
}

// 设置删除按钮状态
- (void)changeDeleteBtnType
{
    UIBarButtonItem *barItem = [self.navigationItem.rightBarButtonItems objectAtIndex:2];
    if ([[[self.navigationItem.rightBarButtonItems objectAtIndex:1] title] isEqualToString:@"Edit"])
    {
        barItem.enabled = NO;
    }
    else
    {
        if ([self.m_chooseDeleteArray count] == 0)
        {
            barItem.enabled = NO;
        }
        else
        {
            barItem.enabled = YES;
        }
    }
}

#pragma mark - Create ActionSheet
// 点击添加按钮
- (void)createNew
{
    [self tableViewCanceledit];
    
    UIActionSheet *actionSheet = [self createActionWithTitles:@"Create Folder"
                                               andSecondTitle:@"Create File"
                                                andThirdTitle:@"Sort By Name"
                                                 andFourTitle:@"Sort By Date"
                                                 andFiveTitle:@"Show TableView"
                                                  andSixTitle:@"Show GidView"
                                                andSevenTitle:@"DownLoad"];
    
    actionSheet.tag = 1001;
    [actionSheet showInView:self.view];
}

// 创建ActionSheet
- (UIActionSheet *)createActionWithTitles:(NSString *)firtitle
                           andSecondTitle:(NSString *)secTitle
                            andThirdTitle:(NSString *)thiTitle
                             andFourTitle:(NSString *)fourTitle
                             andFiveTitle:(NSString *)fiveTitle
                              andSixTitle:(NSString *)sixTitle
                            andSevenTitle:(NSString *)sevenTitle

{
    UIActionSheet *actionSheet;
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"请选择"
                       delegate:self
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:firtitle,secTitle,thiTitle,fourTitle,sixTitle,sevenTitle,nil];
    }
    else
    {
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"请选择"
                       delegate:self
                       cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                       otherButtonTitles:firtitle,secTitle,thiTitle,fourTitle,fiveTitle,sevenTitle,nil];
    }

    return actionSheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 创建
    if (actionSheet.tag == 1001)
    {
        [self addActionSheetClickMethod:buttonIndex];
    }
    // 文件夹 copy
    if (actionSheet.tag == 1002)
    {
        [self folderActionSheetClickMethod:buttonIndex];
    }
    // 文件夹 pase
    if (actionSheet.tag == 1003)
    {
        [self folderPaseActionSheetClickMethod:buttonIndex];
    }
    // 文件Copy
    if (actionSheet.tag == 1004)
    {
        [self fileCopyActionSheetClickMethod:buttonIndex];
    }
}

// 点击＋按钮的ActionSheet，触发的事件
- (void)addActionSheetClickMethod:(NSInteger)clickIndex
{
    switch (clickIndex)
    {
        case 0:
            // 创建文件夹
            [self createNewFolder];
            break;
        case 1:
            // 创建文件
            [self createNewFile];
            break;
        case 2:
            // 按名称排序
            [self sortByName];
            break;
        case 3:
            // 按日期排序
            [self sortByDate];
            break;
        case 4:
            // 切换视图
            [self switchView];
            break;
        case 5:
            // 进入下载页面
            [self goToDownLoadPage];
            break;
        default:
            break;
    }
}

// 文件夹Copy的ActionSheet的点击事件
- (void)folderActionSheetClickMethod:(NSInteger)clickIndex
{
    switch (clickIndex)
    {
        case 0:
            // 修改文件名称
            [self updateFolderName];
            break;
        case 1:
            // 复制文件夹
            [self copyFolderOrFile];
            break;
        case 2:
            // 剪切文件夹
            [self cutFolderOrFile];
            break;
        default:
            break;
    }
}

// 文件夹的粘贴的ActionSheet的点击事件
- (void)folderPaseActionSheetClickMethod:(NSInteger)clickIndex
{
    switch (clickIndex)
    {
        case 0:
            // 修改文件名称
            [self updateFolderName];
            break;
        case 1:
            // 粘贴文件夹
            [self paseFolder];
            break;
        default:
            break;
    }
}

// 文件的Copy
- (void)fileCopyActionSheetClickMethod:(NSInteger)clickIndex
{
    switch (clickIndex)
    {
        case 0:
            // 复制文件
            [self copyFolderOrFile];
            break;
        case 1:
            // 剪切文件
            [self cutFolderOrFile];
            break;
        default:
            break;
    }
}

#pragma mark - Sort Method
// 按照名称排序
- (void)sortByName
{
    NSArray *allArray = [CommonDeal sortByName:[CommonDeal getAllFileWithPath:self.m_currentDirectoryPath]];
    
    [m_mainView sentFileArray:(NSMutableArray *)allArray andCurrentPath:self.m_currentDirectoryPath];
}

// 按照创建时间排序
- (void)sortByDate
{
    NSArray *allArray = [CommonDeal sortByCreateDate:[CommonDeal getAllFileWithPath:self.m_currentDirectoryPath]];
    
    [m_mainView sentFileArray:(NSMutableArray *)allArray andCurrentPath:self.m_currentDirectoryPath];
}

- (void)switchView
{
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        [self switchToGidView];
    }
    else
    {
        [self switchToTableView];
    }
}

// 切换到表格视图
- (void)switchToTableView
{
    // 如果当前不是表格是图，则切换
    if (![[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        m_mainView.hidden = NO;
        m_showGidView.hidden = YES;
        
        [[AppContextManagement shareInstance] setGlobal_showView:@"0"];
        
        [m_mainView sentFileArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
}

// 切换到九宫格视图
- (void)switchToGidView
{
    // 如果当前不是九宫格是图，则切换
    if (![[[AppContextManagement shareInstance] global_showView] intValue] == 1)
    {
        m_mainView.hidden = YES;
        m_showGidView.hidden = NO;
        
        [[AppContextManagement shareInstance] setGlobal_showView:@"1"];
        
        [m_showGidView sentUserToShowArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
}

// 进入下载页面
- (void)goToDownLoadPage
{
    DownLoadViewController *downLoadControl = [[DownLoadViewController alloc] init];
    [downLoadControl setM_currentDirPath:self.m_currentDirectoryPath];
    UINavigationController *downNav = [[UINavigationController alloc] initWithRootViewController:downLoadControl];
    [self.navigationController presentViewController:downNav animated:YES completion:nil];
}

#pragma mark - Create New Folder
// 创建文件夹
- (void)createNewFolder
{
    // 创建新文件或文件夹时，先判断当前目录是否可写
    if (![CommonDeal chectIsCanBeWriter:self.m_currentDirectoryPath])
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"当前目录不可写"];
        
        return;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Folder"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    
    m_folderTextField = [[UITextField alloc]initWithFrame:CGRectMake(22, 50, 240, 37)] ;
    m_folderTextField.backgroundColor = [UIColor whiteColor];
    m_folderTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_folderTextField.borderStyle = UITextBorderStyleNone;
    m_folderTextField.layer.cornerRadius = 6;
    m_folderTextField.layer.masksToBounds = YES;
    m_folderTextField.returnKeyType = UIReturnKeyDone;
    m_folderTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
    m_folderTextField.secureTextEntry = NO;
    m_folderTextField.placeholder = @"Please input folder name";
    [alert addSubview:m_folderTextField];
    [m_folderTextField  resignFirstResponder];
    alert.tag = 101;
    [alert show];
}

// 编辑AlertView
- (void)willPresentAlertView:(UIAlertView *)alertView
{
    for( UIView * view in alertView.subviews )
    {
        if (alertView.tag == 101 || alertView.tag == 103)
        {
            alertView.frame = CGRectMake(20, 60, 283, 160);
            if ( [view isKindOfClass:[UIButton class]] )
            {
                UIButton *btn0=(UIButton *)[alertView viewWithTag:1];
                btn0.frame = CGRectMake(20, 102, 118, 37);
            
                UIButton *btn1=(UIButton *)[alertView viewWithTag:2];
                btn1.frame = CGRectMake(145, 102, 118, 37);
            }
        }
        [m_folderTextField becomeFirstResponder];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        if (buttonIndex == 1)
        {
            NSString *str = m_folderTextField.text;
            if (str && ![str isEqualToString:@""])
            {
                [CommonDeal createNewFolder:self.m_currentDirectoryPath andFolderName:str];
                
                [self.m_allFileArray removeAllObjects];
                [self searchDirectoryAndShow];
            }
            else
            {
                [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"Please input folder name"];
            }
        }
    }
    else if (alertView.tag == 102)
    {
        if (buttonIndex == 1)
        {
            [self deleteMoreWithUserChoose];
        }
    }
    else if (alertView.tag == 103)
    {
        if (buttonIndex == 1)
        {
            NSString *str = m_folderTextField.text;
            if (str && ![str isEqualToString:@""])
            {
                [CommonDeal updateFileNameWithOldName:self.m_updateOldFolderNameString
                                           andNewName:str
                                              andPath:self.m_currentDirectoryPath];
                
                [self.m_allFileArray removeAllObjects];
                [self searchDirectoryAndShow];

            }
            else
            {
                [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"Please input new name"];
            }
        }
    }
}

#pragma mark - Create New File
// 创建新文件
- (void)createNewFile
{
    // 创建新文件或文件夹时，先判断当前目录是否可写
    if (![CommonDeal chectIsCanBeWriter:self.m_currentDirectoryPath])
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"当前目录不可写"];
        
        return;
    }
    
    CreateFileViewController *createControl = [[CreateFileViewController alloc] init];
    [createControl setM_currentDicPath:self.m_currentDirectoryPath];
    [self.navigationController pushViewController:createControl animated:YES];
}

#pragma mark - ShowGidView Delegate Method Star
// 进入子目录
- (void)goToNextPageGid:(NSString *)currentPath andFolderName:(NSString *)folderName
{
    [self nextDirectory:currentPath andFolderName:folderName];
}

// 查看文件详情
- (void)goToDetailGid:(NSString *)currentPath andFileName:(NSString *)fileName
{
    [self showDetail:currentPath andFileName:fileName];
}

// 查看其他文件信息
- (void)goToShowViewGid:(NSString *)currentFilePath andImageName:(NSString *)fileName
{
    [self showOtherFileDetail:currentFilePath andFileName:fileName];
}

// 编辑文件/文件夹  文件的重命名、复制、剪切等操作
- (void)chooseEditFileOrFolderWithNameGid:(NSString *)fileName
{
    [self fileOrFolderBeginEditWithName:fileName];
}

// 多选删除多选时，选中/取消选中
- (void)moreDeleteWhileUserChooseOrFail:(BOOL)choosed andFileName:(NSString *)fileName
{
    [self moreDeleteChooseOrFaile:choosed andFileName:fileName];
}

#pragma mark ShowGidView Delegate Method End

#pragma mark - MainView Delegate Method Star
// 进入子目录
- (void)goToNextPage:(NSString *)currentPath andFolderName:(NSString *)folderName
{
    [self nextDirectory:currentPath andFolderName:folderName];
}

// 查看其他文件
- (void)goToShowView:(NSString *)currentFilePath andImageName:(NSString *)currentFileName
{
    [self showOtherFileDetail:currentFilePath andFileName:currentFileName];
}

// 查看文件详情
- (void)goToDetail:(NSString *)currentPath andFileName:(NSString *)fileName
{
    [self showDetail:currentPath andFileName:fileName];
}

// 编辑文件/文件夹  文件的重命名、复制、剪切等操作
- (void)chooseEditFileOrFolderWithName:(NSString *)fileName
{
    [self fileOrFolderBeginEditWithName:fileName];
}

// 滑动删除删除 删除的时候，传入的路径时当前目录路径＋选中的文件名
- (void)deleteFileWithPath:(NSString *)currentPath andFileName:(NSString *)fileName
{
    [self tableSlidingDeleteWithPath:currentPath andFileName:fileName];
    
    [self.m_allFileArray removeAllObjects];
    // 删除后，重新查询展示
    [self searchDirectoryAndShow];
}

// 多选删除多选时，选中/取消选中
- (void)userChooseFileDelete:(BOOL)choosed andFileName:(NSString *)fileName
{
    [self moreDeleteChooseOrFaile:choosed andFileName:fileName];
}

#pragma mark MainViewDelegate Method End

#pragma mark - Private Method Star
// 进入子目录
- (void)nextDirectory:(NSString *)currentPath andFolderName:(NSString *)folderName
{
    // 设置表格编辑状态还原
    [self tableViewCanceledit];
    
    MainViewController *mainControl = [[MainViewController alloc] init];
    [mainControl setM_currentDirectoryPath:currentPath];
    [mainControl setTitle:folderName];
    [self.navigationController pushViewController:mainControl animated:YES];
}

// 查看文本文件详情
- (void)showDetail:(NSString *)currentPath andFileName:(NSString *)fileName
{
    // 设置表格编辑状态还原
    [self tableViewCanceledit];
    
    DetailViewController *detailConteol = [[DetailViewController alloc] init];
    [detailConteol setM_currentPath:self.m_currentDirectoryPath];
    [detailConteol setTitle:fileName];
    [detailConteol setM_showDetail:YES];
    [detailConteol setM_fileNameString:fileName];
    [self.navigationController pushViewController:detailConteol animated:YES];
}

// 查看其他文件项 音频、视频、图片、Html等等
- (void)showOtherFileDetail:(NSString *)currentPath andFileName:(NSString *)fileName
{
    // 设置表格编辑状态还原
    [self tableViewCanceledit];
    
    ShowViewController *showControl = [[ShowViewController alloc] init];
    [showControl setM_showFileCurrentDirPath:self.m_currentDirectoryPath];
    [showControl setM_showFileName:fileName];
    [self.navigationController pushViewController:showControl animated:YES];
}

// 滑动删除删除 删除的时候，传入的路径时当前目录路径＋选中的文件名
- (void)tableSlidingDeleteWithPath:(NSString *)currentPath andFileName:(NSString *)fileName
{
    if ([CommonDeal chectIsCanBeWriter:currentPath])
    {
        [CommonDeal deleteFile:currentPath andFileName:fileName];
    }
    else
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"没有删除权限"];
    }
}

- (void)deletePress
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                    message:@"Are you sure"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Confirm", nil];
    alert.tag = 102;
    [alert show];
}

// 多行删除
- (void)deleteMoreWithUserChoose
{
    for (int i = 0; i<[self.m_chooseDeleteArray count]; i++)
    {
        NSString *fileName = [NSString stringWithFormat:@"%@",[self.m_chooseDeleteArray objectAtIndex:i]];
        NSString *filePath = [self.m_currentDirectoryPath stringByAppendingPathComponent:fileName];
        //[self deleteFileWithPath:filePath andFileName:fileName];
        [self tableSlidingDeleteWithPath:filePath andFileName:fileName];
    }
    
    // 删除完成，移除所有数组信息
    [self.m_chooseDeleteArray removeAllObjects];
    
    [self tableViewCanceledit];
    
    [self changeDeleteBtnType];
    
    [self.m_allFileArray removeAllObjects];
    // 删除后，重新查询展示
    [self searchDirectoryAndShow];
}

// 多选时，选中/取消选中
- (void)moreDeleteChooseOrFaile:(BOOL)choosed andFileName:(NSString *)fileName
{
    // 选中
    if (choosed)
    {
        [self insertChooseToArray:fileName];
    }
    // 取消选中
    else
    {
        [self removeChooseFromArray:fileName];
    }
    [self changeDeleteBtnType];
}

// 将选中的行添加到数组
- (void)insertChooseToArray:(NSString *)chooseFileName
{
    NSString *str = [NSString stringWithFormat:@"%@",chooseFileName];
    if (![self checkObjectIsInArray:str])
    {
        [self.m_chooseDeleteArray addObject:str];
        
        [self updateFileChooseType:@"1" andFileName:chooseFileName];
    }
}

// 将取消选中的行从数组中移除
- (void)removeChooseFromArray:(NSString *)chooseFileName
{
    NSString *str = [NSString stringWithFormat:@"%@",chooseFileName];
    if ([self checkObjectIsInArray:str])
    {
        [self.m_chooseDeleteArray removeObject:str];
        
        [self updateFileChooseType:@"0" andFileName:chooseFileName];
    }
}

- (void)updateFileChooseType:(NSString *)type andFileName:(NSString *)fileName
{
    for (int i = 0; i<[self.m_allFileArray count]; i++)
    {
        if ([[[self.m_allFileArray objectAtIndex:i] m_fileName] isEqualToString:fileName])
        {
            [[self.m_allFileArray objectAtIndex:i] setM_fileIsChoose:type];
            
            continue;
        }
    }
    if ([[[AppContextManagement shareInstance] global_showView] intValue] == 0)
    {
        [m_mainView sentFileArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
    else
    {
        [m_showGidView sentUserToShowArray:self.m_allFileArray andCurrentPath:self.m_currentDirectoryPath];
    }
}

// 判断某个元素是否已经存在于数组中
- (BOOL)checkObjectIsInArray:(NSString *)string
{
    int index_ = [self.m_chooseDeleteArray indexOfObject:string];
    if (index_ == NSNotFound)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark Private Method End

#pragma mark - File Or Folder Edit

- (void)fileOrFolderBeginEditWithName:(NSString *)fileName
{
    NSString *oldFilePath = [self.m_currentDirectoryPath stringByAppendingPathComponent:fileName];
    self.m_updateOldFolderNameString = [NSString stringWithFormat:@"%@",fileName];
    // 判断当前是文件夹还是文件
    if ([CommonDeal chectIsFolder:oldFilePath])
    {
        // 当前已经有文件夹被复制
        if ([[AppContextManagement shareInstance] global_isAlreadyCopy])
        {
            UIActionSheet *actionSheet = [self createActionWithTitles:@"Update Folder Name"
                                                       andSecondTitle:@"Pase"
                                                        andThirdTitle:nil
                                                         andFourTitle:nil
                                                         andFiveTitle:nil
                                                          andSixTitle:nil
                                                        andSevenTitle:nil];
            actionSheet.tag = 1003;
            [actionSheet showInView:self.view];
        }
        else
        {
            UIActionSheet *actionSheet = [self createActionWithTitles:@"Update Folder Name"
                                                       andSecondTitle:@"Copy"
                                                        andThirdTitle:@"Cut"
                                                         andFourTitle:nil
                                                         andFiveTitle:nil
                                                          andSixTitle:nil
                                                        andSevenTitle:nil];
            actionSheet.tag = 1002;
            [actionSheet showInView:self.view];
        }
        
    }
    else
    {
        // 当前还没有文件被复制
        if (![[AppContextManagement shareInstance] global_isAlreadyCopy])
        {
            UIActionSheet *actionSheet = [self createActionWithTitles:@"Copy"
                                                       andSecondTitle:@"Cut"
                                                        andThirdTitle:nil
                                                         andFourTitle:nil
                                                         andFiveTitle:nil
                                                          andSixTitle:nil
                                                        andSevenTitle:nil];
            actionSheet.tag = 1004;
            [actionSheet showInView:self.view];
        }
    }
}

- (void)updateFolderName
{
    NSString *oldFilePath = [self.m_currentDirectoryPath stringByAppendingPathComponent:self.m_updateOldFolderNameString];
    // 如果是文件夹，才让修改名称
    if ([CommonDeal chectIsFolder:oldFilePath])
    {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Update Folder Name"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        
        m_folderTextField = [[UITextField alloc]initWithFrame:CGRectMake(22, 50, 240, 37)] ;
        m_folderTextField.backgroundColor = [UIColor whiteColor];
        m_folderTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        m_folderTextField.borderStyle = UITextBorderStyleNone;
        m_folderTextField.layer.cornerRadius = 6;
        m_folderTextField.layer.masksToBounds = YES;
        m_folderTextField.returnKeyType = UIReturnKeyDone;
        m_folderTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        m_folderTextField.secureTextEntry = NO;
        m_folderTextField.placeholder = @"Please inpue new name";
        [alert addSubview:m_folderTextField];
        [m_folderTextField  resignFirstResponder];
        alert.tag = 103;
        [alert show];
    }
}

// 复制
- (void)copyFolderOrFile
{
    [[AppContextManagement shareInstance] setGlobal_isChooseCopy:YES];
    
    [self saveUserChooseStyle];
}

// 剪切
- (void)cutFolderOrFile
{
    [[AppContextManagement shareInstance] setGlobal_isChooseCopy:NO];
    
    [self saveUserChooseStyle];
}

- (void)saveUserChooseStyle
{
    [[AppContextManagement shareInstance] setGlobal_isAlreadyCopy:YES];
    
    [[AppContextManagement shareInstance] setGlobal_copyFileName:[NSString stringWithFormat:@"%@",self.m_updateOldFolderNameString]];
    [[AppContextManagement shareInstance] setGlobal_copyFileDirePath:[NSString stringWithFormat:@"%@",self.m_currentDirectoryPath]];
}

// 移动
- (void)paseFolder
{
    NSString *oldPath = [[AppContextManagement shareInstance] global_copyFileDirePath];
    NSString *newPath = [self.m_currentDirectoryPath stringByAppendingPathComponent:self.m_updateOldFolderNameString];

    [CommonDeal moveFolderWithOldPath:oldPath
                           andNewPath:newPath
                        andFolderName:[[AppContextManagement shareInstance] global_copyFileName]
                              andCopy:[[AppContextManagement shareInstance] global_isChooseCopy]];
    
    
    [[AppContextManagement shareInstance] setGlobal_isAlreadyCopy:NO];
    [[AppContextManagement shareInstance] setGlobal_copyFileName:[NSString stringWithFormat:@""]];
    [[AppContextManagement shareInstance] setGlobal_copyFileDirePath:[NSString stringWithFormat:@""]];
    
    [self.m_allFileArray removeAllObjects];
    [self searchDirectoryAndShow];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
