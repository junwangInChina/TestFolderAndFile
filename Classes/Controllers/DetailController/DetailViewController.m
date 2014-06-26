//
//  DetailViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-7-28.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailView.h"

@interface DetailViewController ()<DetailViewDelegate>
{
    DetailView *m_detailView;
    
    // 文件内容
    NSString *m_fileInfoString;
}

@property (nonatomic, strong) NSString *m_fileInfoString;

@end

@implementation DetailViewController
@synthesize m_currentPath;
@synthesize m_showDetail;
@synthesize m_fileNameString;
@synthesize m_fileInfoString;

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
    
    NSString *fileInfo = nil;
    
    if (!self.m_showDetail)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePress)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(updatePress)];
        fileInfo = [[NSString alloc] initWithData:[CommonDeal getfileInfo:self.m_currentPath andFileName:self.title] encoding:NSUTF8StringEncoding];
    }
    
    m_detailView = [[DetailView alloc] initWithFrame:self.view.bounds];
    m_detailView.detail_delegate = self;
    [m_detailView sentPageIsShowDetail:self.m_showDetail];
    if (self.m_showDetail)
    {
        [m_detailView sentFileInfo:fileInfo];
    }
    
    [self.view addSubview:m_detailView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// 保存
- (void)savePress
{
    [m_detailView endEditing:YES];
    
    if (self.m_fileNameString == nil || [self.m_fileNameString isEqualToString:@""])
    {
        [CommonDeal showAlertWithTitle:@"Information" andMsgBody:@"Please input file name"];
        return;
    }
    
    NSData *infoData = [self.m_fileInfoString dataUsingEncoding:NSUTF8StringEncoding];
    
    [CommonDeal createNewFile:self.m_currentPath
                  andFileName:self.m_fileNameString
                      andData:infoData];
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 修改
- (void)updatePress
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(savePress)];
    [m_detailView starUpdate];
}

// 创建新文件
- (void)createFile:(NSString *)fileName andFileInfo:(NSString *)fileInfo
{
    if (!m_showDetail)
    {
        self.m_fileNameString = fileName;
    }
   
    self.m_fileInfoString = fileInfo;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
