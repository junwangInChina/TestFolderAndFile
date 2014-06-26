//
//  DownLoadCell.m
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DownLoadCell.h"
#import "DownLoadManagement.h"

@interface DownLoadCell()<UIAlertViewDelegate>
{
    UILabel *m_imageNameLbl;
    NSString *m_requestURL;
    NSString *m_downCurrentPath;
    int m_chooseDelete;
}

@property (nonatomic, retain) UILabel *m_imageNameLbl;
@property (nonatomic, retain) NSString *m_requestURL;
@property (nonatomic, retain) NSString *m_downCurrentPath;
@property (nonatomic) int m_chooseDelete;

@end

@implementation DownLoadCell
@synthesize m_downLoadBtn;
@synthesize m_imageNameLbl;
@synthesize m_downLoadProgress;
@synthesize m_percentLbl;
@synthesize m_requestURL;
@synthesize m_downCurrentPath;
@synthesize downloadcell_delegate;
@synthesize m_deleteBtn;
@synthesize m_chooseDelete;

- (void)dealloc
{
    self.m_imageNameLbl = nil;
    self.m_percentLbl = nil;
    self.m_downLoadBtn = nil;
    self.m_downLoadProgress = nil;
    self.m_requestURL = nil;
    self.m_downCurrentPath = nil;
    self.downloadcell_delegate = nil;
    self.m_deleteBtn = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.m_imageNameLbl = [self createLabel:CGRectMake(10, 2, 280, 20)];
        [self.contentView addSubview:m_imageNameLbl];
        
        self.m_percentLbl = [self createLabel:CGRectMake(200, 22, 40, 20)];
        [self.contentView addSubview:m_percentLbl];
        
        self.m_downLoadBtn = [self createButton:CGRectMake(240, 22, 50, 20)];
        [m_downLoadBtn setTitle:@"DownLoad" forState:UIControlStateNormal];
        [m_downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        m_downLoadBtn.titleLabel.font = [UIFont boldSystemFontOfSize:8];
        [m_downLoadBtn setBackgroundColor:[UIColor blackColor]];
        [m_downLoadBtn addTarget:self action:@selector(starDownLoad:) forControlEvents:UIControlEventTouchUpInside];
        m_downLoadBtn.showsTouchWhenHighlighted = YES;
        [self.contentView addSubview:m_downLoadBtn];
        
        self.m_deleteBtn = [self createButton:CGRectMake(175, 20, 20, 20)];
        [m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteON.png"] forState:UIControlStateHighlighted];
        [m_deleteBtn addTarget:self action:@selector(deleteRequest:) forControlEvents:UIControlEventTouchUpInside];
        m_deleteBtn.hidden = YES;
        [self.contentView addSubview:m_deleteBtn];
        
        self.m_downLoadProgress = [self createProgressView:CGRectMake(10, 25, 160, 20)];
        [self.contentView addSubview:m_downLoadProgress];
        
        self.m_chooseDelete = -1;
    }
    return self;
}

- (UIButton *)createButton:(CGRect)buttonFrame
{
    UIButton *button_ = [[[UIButton alloc] initWithFrame:buttonFrame] autorelease];
    return button_;
}

- (UILabel *)createLabel:(CGRect)labelframe
{
    UILabel *label_ = [[[UILabel alloc] initWithFrame:labelframe] autorelease];
    label_.font = [UIFont boldSystemFontOfSize:10];
    label_.numberOfLines = 0;
    return label_;
}

- (UIProgressView *)createProgressView:(CGRect)progressFrame
{
    UIProgressView *progress_ = [[[UIProgressView alloc] initWithFrame:progressFrame] autorelease];
    return progress_;
}

/**
 * 使用Model实现时，出现bug，暂时屏蔽
 */
- (void)sentMessageShow:(FileModel *)fileModel_
{
    self.m_requestURL = fileModel_.m_downLoadURL;
    self.m_downCurrentPath = fileModel_.m_downSaveDirPath;
    self.m_imageNameLbl.text = [NSString stringWithFormat:@"%@",fileModel_.m_downLoadFileName];
    
    // 文件已经存在，表示已经下载过的
    if ([CommonDeal fileIsAleradyExists:self.m_downCurrentPath andFileName:fileModel_.m_downLoadFileName])
    {
        self.m_downLoadBtn.hidden = YES;
        [self.m_downLoadProgress setProgress:1.0 animated:YES];
        self.m_percentLbl.text = @"100.0%";
    }
    else
    {
        self.m_downLoadBtn.hidden = NO;
        [self.m_downLoadProgress setProgress:0.0 animated:YES];
        self.m_percentLbl.text = @"";
    }
     
    self.m_downLoadProgress.progress = fileModel_.m_downLoadProgress;
    self.m_percentLbl.text = [NSString stringWithFormat:@"%.1f%@",fileModel_.m_downLoadProgress*100,@"%"];
}
 

- (void)sentURL:(NSString *)downloadURL andDirPath:(NSString *)path andProgressDic:(NSMutableDictionary *)downLoadDic
{
    self.m_requestURL = downloadURL;
    self.m_downCurrentPath = path;
    
    NSString *nameString = [downloadURL lastPathComponent];
    self.m_imageNameLbl.text = [NSString stringWithFormat:@"%@",nameString];
    
    
    if ([CommonDeal fileIsAleradyExists:self.m_downCurrentPath andFileName:nameString])
    {
        self.m_downLoadBtn.hidden = YES;
        self.m_deleteBtn.hidden = YES;
        [self.m_downLoadProgress setProgress:1.0 animated:NO];
        self.m_percentLbl.text = @"100.0%";
    }
    else
    {
        
        self.m_downLoadBtn.hidden = NO;
        float progress_ = [[downLoadDic valueForKey:nameString] floatValue];
        [self.m_downLoadProgress setProgress:progress_ animated:NO];
        if (progress_ != 0)
        {
            self.m_percentLbl.text = [NSString stringWithFormat:@"%.1f%@",progress_*100,@"%"];
            self.m_deleteBtn.hidden = NO;
            [self.m_downLoadBtn setTitle:@"Stop" forState:UIControlStateNormal];
            if (progress_ == 1.0)
            {
                self.m_downLoadBtn.hidden = YES;
            }
            else
            {
                self.m_downLoadBtn.hidden = NO;
            }
        }
        else
        {
            self.m_percentLbl.text = @"";
            self.m_deleteBtn.hidden = YES;
            [self.m_downLoadBtn setTitle:@"DownLoad" forState:UIControlStateNormal];
        }
    }
}

- (void)starDownLoad:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([self.m_downLoadBtn.titleLabel.text isEqualToString:@"DownLoad"])
    {
        [self star:btn.tag];
    }
    else
    {
        [self stop:btn.tag];
    }
}

// 开始下载
- (void)star:(int)tapIndex
{
    [self.m_downLoadBtn setTitle:@"Stop" forState:UIControlStateNormal];
    
    // 开始下载，展示删除按钮
    self.m_deleteBtn.hidden = NO;
    
    if (self.downloadcell_delegate && [self.downloadcell_delegate respondsToSelector:@selector(starDownLoad:)])
    {
        [self.downloadcell_delegate starDownLoad:tapIndex - 100];
    }
}

// 停止下载
- (void)stop:(int)tapIndex
{
    [self.m_downLoadBtn setTitle:@"DownLoad" forState:UIControlStateNormal];
    
    if (self.downloadcell_delegate && [self.downloadcell_delegate respondsToSelector:@selector(stopDownLoad:)])
    {
        [self.downloadcell_delegate stopDownLoad:tapIndex - 100];
    }
}

- (void)deleteRequest:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    self.m_chooseDelete = btn.tag - 100;
    
    [self stop:btn.tag];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information"
                                                    message:@"Do you want delete this request and clear cache"
                                                   delegate:self
                                          cancelButtonTitle:@"NO"
                                          otherButtonTitles:@"YES", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        self.m_chooseDelete = -1;
    }
    else if (buttonIndex == 1)
    {
        // 下载完成，隐藏删除按钮
        self.m_deleteBtn.hidden = YES;
        
        // 进度条归0
        [self.m_downLoadProgress setProgress:0.0 animated:YES];
        // 百分比归0
        self.m_percentLbl.text = @"";
        
        if (self.downloadcell_delegate && [self.downloadcell_delegate respondsToSelector:@selector(removeRequest:)])
        {
            [self.downloadcell_delegate removeRequest:self.m_chooseDelete];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
