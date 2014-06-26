//
//  ShowGidView.m
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "ShowGidView.h"
#import "ShowGidViewController.h"
#import "FileModel.h"

@interface ShowGidView()<KTThumbsViewControllerDelegate>
{
    NSString *m_currentDirPath;
    ShowGidViewController *m_showGidControl;
}

@property (nonatomic, retain) NSString *m_currentDirPath;
@property (nonatomic, retain) ShowGidViewController *m_showGidControl;

@end

@implementation ShowGidView
@synthesize m_showGidControl;
@synthesize m_currentDirPath;
@synthesize showGid_delegate;

- (void)dealloc
{
    self.m_showGidControl = nil;
    self.m_currentDirPath = nil;
    Block_release(showGid_block);
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect realFrame = frame;
        realFrame.size.height -= 44;
        
        self.m_showGidControl = [[[ShowGidViewController alloc] init] autorelease];
        m_showGidControl.ktt_delegate = self;
        m_showGidControl.view.frame = realFrame;
        [self addSubview:self.m_showGidControl.view];
    }
    return self;
}

- (void)setGidViewBeEdit:(ShowGidBlock)block_
{
    showGid_block = Block_copy(block_);
    [self.m_showGidControl sentGidControlEdit:^(BOOL isEditing){
        
        showGid_block(isEditing);
    }];
}

- (void)cancelEditTypeGid
{
    [self.m_showGidControl cancelEditGidControl];
}

- (void)sentUserToShowArray:(NSMutableArray *)array_ andCurrentPath:(NSString *)currentPath_
{
    self.m_currentDirPath = currentPath_;
    
    [self.m_showGidControl refreshViewWithMessage:array_];
}

- (void)editFileWithName:(NSString *)fileName
{
    if (self.showGid_delegate && [self.showGid_delegate respondsToSelector:@selector(chooseEditFileOrFolderWithNameGid:)])
    {
        [self.showGid_delegate chooseEditFileOrFolderWithNameGid:fileName];
    }
}

- (void)toNextPageWithName:(NSString *)fileName
{
    
    NSString *currentPath = [self.m_currentDirPath stringByAppendingPathComponent:fileName];
    
    // 判断如果是文件夹，则进入子目录
    if ([CommonDeal chectIsFolder:currentPath])
    {
        [self toNextPageGid:currentPath andFolderName:fileName];
    }
    // 否则进入详情
    else
    {
        // 表示普通文件，则按照原来的流程
        if ([[CommonDeal getFileType:fileName] isEqualToString:@"4"])
        {
            [self toDetailGid:currentPath andFileName:fileName];
        }
        else
        {
            [self toShowViewGid:currentPath andFileName:fileName];
        }
    }
}

// 进入子目录
- (void)toNextPageGid:(NSString *)currPath andFolderName:(NSString *)folderName
{
    if (self.showGid_delegate && [self.showGid_delegate respondsToSelector:@selector(goToNextPageGid:andFolderName:)])
    {
        [self.showGid_delegate goToNextPageGid:currPath andFolderName:folderName];
    }
}

// 查看文件详情
- (void)toDetailGid:(NSString *)currPath andFileName:(NSString *)fileName
{
    if (self.showGid_delegate && [self.showGid_delegate respondsToSelector:@selector(goToDetailGid:andFileName:)])
    {
        [self.showGid_delegate goToDetailGid:currPath andFileName:fileName];
    }
    
}

// 查看其他文件
- (void)toShowViewGid:(NSString *)currPath andFileName:(NSString *)fileName
{
    if (self.showGid_delegate && [self.showGid_delegate respondsToSelector:@selector(goToShowViewGid:andImageName:)])
    {
        [self.showGid_delegate goToShowViewGid:currPath andImageName:fileName];
    }
}

// 多选删除
- (void)moreDeleteWhenChooseOrFail:(BOOL)choosed andFileName:(NSString *)fileName
{
    if (self.showGid_delegate && [self.showGid_delegate respondsToSelector:@selector(moreDeleteWhileUserChooseOrFail:andFileName:)])
    {
        [self.showGid_delegate moreDeleteWhileUserChooseOrFail:choosed andFileName:fileName];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
