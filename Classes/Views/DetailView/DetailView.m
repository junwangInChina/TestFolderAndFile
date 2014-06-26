//
//  DetailView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-28.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DetailView.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailView()<UITextViewDelegate>
{
    UILabel *m_fileNameLbl;
    UILabel *m_fileInfoLbl;
    
    UITextView *m_fileNameTextView;
    UITextView *m_fileInfoTextView;
}

@end

@implementation DetailView
@synthesize detail_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_fileNameLbl = [self createLabel:CGRectMake(10, 20, 85, 30)];
        m_fileNameLbl.text = @"File Name:";
        [self addSubview:m_fileNameLbl];
        
        m_fileInfoLbl = [self createLabel:CGRectMake(10, 70, 85, 30)];
        m_fileInfoLbl.text = @"File Info:";
        [self addSubview:m_fileInfoLbl];
        
        m_fileNameTextView = [self createTextView:CGRectMake(110, 20, 200, 30)];
        m_fileNameTextView.textAlignment = NSTextAlignmentNatural;
        m_fileNameTextView.delegate = self;
        [m_fileNameTextView becomeFirstResponder];
        [self addSubview:m_fileNameTextView];
        
        m_fileInfoTextView = [self createTextView:CGRectMake(110, 70, 200, 150)];
        m_fileInfoTextView.delegate = self;
        [self addSubview:m_fileInfoTextView];
    }
    return self;
}

- (UILabel *)createLabel:(CGRect)lblFrame
{
    UILabel *label_ = [[UILabel alloc] initWithFrame:lblFrame];
    label_.backgroundColor = [UIColor clearColor];
    
    return label_;
}

- (UITextView *)createTextView:(CGRect)frame_
{
    UITextView *textView_ = [[UITextView alloc] initWithFrame:frame_];
    textView_.layer.masksToBounds = YES;
    textView_.layer.cornerRadius = 6.0;
    textView_.layer.borderWidth = 0.5;
    textView_.layer.borderColor = [UIColor blackColor].CGColor;
    
    return textView_;
}

#pragma mark - Private Method
- (void)sentPageIsShowDetail:(BOOL)isShowDetail
{
    if (isShowDetail)
    {
        // 展示详情页面
        [self showDetailPage];
    }
    else
    {
        // 展示添加页面
        [self showAddPage];
    }
}

// 展示详情页面
- (void)showDetailPage
{
    m_fileNameLbl.hidden = YES;
    m_fileInfoLbl.hidden = YES;
    m_fileNameTextView.hidden = YES;
    [m_fileNameTextView resignFirstResponder];
    m_fileInfoTextView.hidden = NO;
    m_fileInfoTextView.editable = NO;
    m_fileInfoTextView.frame = CGRectMake(20, 20, 280, 300);
    m_fileInfoTextView.layer.borderColor = [UIColor clearColor].CGColor;
    
}

// 展示添加页面
- (void)showAddPage
{
    m_fileNameLbl.hidden = NO;
    m_fileInfoLbl.hidden = NO;
    m_fileNameTextView.hidden = NO;
    m_fileInfoTextView.hidden = NO;
    m_fileInfoTextView.editable = YES;
    m_fileInfoTextView.frame = CGRectMake(110, 70, 200, 150);
    m_fileInfoTextView.layer.borderColor = [UIColor blackColor].CGColor;
}

// 展示文件内容
- (void)sentFileInfo:(NSString *)fileInfo
{
    if (fileInfo)
    {
        m_fileInfoTextView.text = [NSString stringWithFormat:@"%@",fileInfo];
    }
    else
    {
        m_fileInfoTextView.text = @"not anything";
    }
}

// 开始修改
- (void)starUpdate
{
    m_fileInfoTextView.layer.borderColor = [UIColor blackColor].CGColor;
    m_fileInfoTextView.editable = YES;
}

#pragma mark - UITextView Delegate Method
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSString *fileName = m_fileNameTextView.text;
    NSString *fileInfo = m_fileInfoTextView.text;
  
    if (self.detail_delegate && [self.detail_delegate respondsToSelector:@selector(createFile:andFileInfo:)])
    {
        [self.detail_delegate createFile:fileName andFileInfo:fileInfo];
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
