//
//  ShowViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowViewController.h"
#import "ShowImageView.h"
#import "ShowVideoView.h"
#import "ShowAudioView.h"
#import "ShowHtmlView.h"
#import "ShowUnkonwnView.h"

@interface ShowViewController ()

@end

@implementation ShowViewController
@synthesize m_showFileCurrentDirPath;
@synthesize m_showFileName;

- (void)dealloc
{
    self.m_showFileCurrentDirPath = nil;
    self.m_showFileName = nil;
    
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
    
    self.title = [NSString stringWithFormat:@"%@",self.m_showFileName];
    
    NSString *fileType = [CommonDeal getFileType:self.m_showFileName];
    
    // 根据不通的Type，展示不同的View
    [self addSwitchViewWithFileType:fileType];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)addSwitchViewWithFileType:(NSString *)fileType_
{
    switch ([fileType_ intValue])
    {
        case 1:
            // 加载图片
            [self addShowImageView];
            break;
        case 2:
            // 加载视频
            [self addShowVideoView];
            break;
        case 3:
            // 加载音频
            [self addShowAudioView];
            break;
        case 5:
            // 加载Html页面
            [self addShowHtmlView];
            break;
        case 6:
            // 加载PDF PDF文件可以使用UIWebView加载
            [self addShowHtmlView];
            break;
        default:
            // 其他未知类型，加载提示页面
            [self addShowUnknownView];
            break;
    }
}

- (void)addShowImageView
{
    ShowImageView *showImageView = [[ShowImageView alloc] initWithFrame:self.view.bounds];
    [showImageView sentImagePath:[self.m_showFileCurrentDirPath stringByAppendingPathComponent:self.m_showFileName]];
    [self.view addSubview:showImageView];
    [showImageView release];
}

- (void)addShowVideoView
{
    ShowVideoView *showVideoView = [[ShowVideoView alloc] initWithFrame:self.view.bounds];
    [showVideoView sentVideoPath:[self.m_showFileCurrentDirPath stringByAppendingPathComponent:self.m_showFileName]];
    [self.view addSubview:showVideoView];
    [showVideoView release];
}

- (void)addShowAudioView
{
    ShowAudioView *showAudioView = [[ShowAudioView alloc] initWithFrame:self.view.bounds];
    [showAudioView sentAudioPath:[self.m_showFileCurrentDirPath stringByAppendingPathComponent:self.m_showFileName]];
    [self.view addSubview:showAudioView];
    [showAudioView release];
}

// HTML、PDF都可以使用WebView加载的
- (void)addShowHtmlView
{
    ShowHtmlView *showHtmlView = [[ShowHtmlView alloc] initWithFrame:self.view.bounds];
    [showHtmlView sentHtmlPath:[self.m_showFileCurrentDirPath stringByAppendingPathComponent:self.m_showFileName]];
    [self.view addSubview:showHtmlView];
    [showHtmlView release];
}

- (void)addShowPDFView
{
    
}

- (void)addShowUnknownView
{
    ShowUnkonwnView *showUnknownView = [[ShowUnkonwnView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:showUnknownView];
    [showUnknownView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
