//
//  DownLoadViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DownLoadViewController.h"
#import "DownLoadView.h"

@interface DownLoadViewController ()
{
    DownLoadView *m_downLoadView;
}

@property (nonatomic, retain) DownLoadView *m_downLoadView;

@end

@implementation DownLoadViewController
@synthesize m_currentDirPath;
@synthesize m_downLoadView;

- (void)dealloc
{
    self.m_currentDirPath = nil;
    self.m_downLoadView = nil;
    
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
    
    self.title = @"DownLoad";
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Down" style:UIBarButtonItemStyleDone target:self action:@selector(downPage)] autorelease];
    
    self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    
    self.m_downLoadView = [[[DownLoadView alloc] initWithFrame:self.view.bounds] autorelease];
    [m_downLoadView sentCurrentDirPath:self.m_currentDirPath];
    [self.view addSubview:m_downLoadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)downPage
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downLoadGiveUp" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
