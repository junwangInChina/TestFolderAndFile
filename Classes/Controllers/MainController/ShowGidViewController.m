//
//  ShowGidViewController.m
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowGidViewController.h"
#import "GidViewDataSource.h"

@interface ShowGidViewController ()
{
    GidViewDataSource *m_gidDataImage;
}

@property (nonatomic, retain) GidViewDataSource *m_gidDataImage;

@end

@implementation ShowGidViewController
@synthesize m_gidDataImage;

- (void)dealloc
{
    self.m_gidDataImage = nil;
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)sentGidControlEdit:(ShowGidControlBlock)block_
{
    showGidControl_block = Block_copy(block_);
    if ([self.m_fileModelArray count] == 0)
    {
        self.m_gidIsEditing = NO;
        showGidControl_block(NO);
    }
    else
    {
        self.m_gidIsEditing = !m_gidIsEditing;
    }
    
    if (m_gidIsEditing)
    {
        showGidControl_block(YES);
    }
    else
    {
        showGidControl_block(NO);
    }
    
    [self refreshViewWithMessage:self.m_fileModelArray];
}

- (void)cancelEditGidControl
{
    self.m_gidIsEditing = NO;
    [self refreshViewWithMessage:self.m_fileModelArray];
}

- (void)refreshViewWithMessage:(NSMutableArray *)messageArray
{
    // 将存储数据的数组传递到父类定义的数组中去（m_fileModelArray是父类的数组）
    self.m_fileModelArray = messageArray;
    // 获取图片数组
    self.m_gidDataImage = [[[GidViewDataSource alloc] initWithArr:messageArray] autorelease];
    // 将图片数据调用框架自己的刷新方法，传递到View层显示
    [self setDataSource:self.m_gidDataImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
