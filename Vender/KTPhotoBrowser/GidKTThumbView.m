//
//  GidKTThumbView.m
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "GidKTThumbView.h"

@implementation GidKTThumbView
@synthesize m_iconBtn;
@synthesize m_deleteBtn;
@synthesize m_fileNameLbl;
@synthesize m_fileCreateLbl;
@synthesize m_fileSizeLbl;
@synthesize m_isChoosed;

- (void)dealloc
{
    self.m_iconBtn = nil;
    self.m_deleteBtn = nil;
    self.m_fileNameLbl = nil;
    self.m_fileCreateLbl = nil;
    self.m_fileSizeLbl = nil;

    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self addTarget:self action:@selector(toNextPage:) forControlEvents:UIControlEventTouchUpInside];
        
        self.m_iconBtn = [self createButton:CGRectMake(15, 5, 45, 45)];
        [m_iconBtn addTarget:self action:@selector(toShowFileEdit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.m_iconBtn];
        
        self.m_deleteBtn = [self createButton:CGRectMake(50, 75, 25, 25)];
        [m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
        [m_deleteBtn addTarget:self action:@selector(toChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.m_deleteBtn];
        
        self.m_fileNameLbl = [self createLabel:CGRectMake(5, 50, 65, 10)];
        [self addSubview:self.m_fileNameLbl];
        
        self.m_fileSizeLbl = [self createLabel:CGRectMake(5, 60, 65, 10)];
        [self addSubview:self.m_fileSizeLbl];
        
        self.m_fileCreateLbl = [self createLabel:CGRectMake(5, 70, 65, 10)];
        [self addSubview:self.m_fileCreateLbl];
    }
    return self;
}

- (UIButton *)createButton:(CGRect)btnFrame
{
    UIButton *button_ = [[[UIButton alloc] initWithFrame:btnFrame] autorelease];
    
    return button_;
}

- (UILabel *)createLabel:(CGRect)labelFrame
{
    UILabel *label_ = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
    label_.backgroundColor = [UIColor clearColor];
    label_.font = [UIFont boldSystemFontOfSize:8];
    label_.textAlignment = NSTextAlignmentCenter;
    return label_;
}

- (void)setThumbImage:(UIImage *)newImage
{
    [self.m_iconBtn setBackgroundImage:newImage forState:UIControlStateNormal];
}

- (void)sentFileModelToShow:(FileModel *)fileModel_
{
    self.m_fileNameLbl.text = [NSString stringWithFormat:@"%@",fileModel_.m_fileName];
    self.m_fileSizeLbl.text = [NSString stringWithFormat:@"%@",fileModel_.m_fileSizer];
    self.m_fileCreateLbl.text = [NSString stringWithFormat:@"%@",fileModel_.m_fileCreateDate];
    
    [self updateChooseBtnImageWithChooseType:fileModel_.m_fileIsChoose];
}

- (void)updateChooseBtnImageWithChooseType:(NSString *)fileChooseType
{
    if ([fileChooseType intValue] == 1)
    {
        self.m_isChoosed = YES;
        [m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.m_isChoosed = NO;
        [m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    }
}

- (void)sentEditDeleteBtn:(BOOL)edit andIsChoosed:(BOOL)choosed_
{
    if (edit)
    {
        self.m_deleteBtn.alpha = 1.0;
        self.m_deleteBtn.enabled = YES;
    }
    else
    {
        self.m_deleteBtn.alpha = 0.0;
        self.m_deleteBtn.enabled = NO;
    }
    
    self.m_isChoosed = choosed_;
    [self updateChooseBtnImage];
    
}

- (void)updateChooseBtnImage
{
    if (self.m_isChoosed)
    {
        [self.m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.m_deleteBtn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    }
}

// 选中删除
- (void)toChooseBtn:(id)sender
{
    self.m_isChoosed = !m_isChoosed;
    
    UIButton *btn = (UIButton *)sender;
    if (controller_)
    {
        [controller_ didSelectThumbAtIndex:btn.tag-100 AndPressWhitchBtn:2 andChoosed:self.m_isChoosed];
    }
    
    [self updateChooseBtnImage];
}

// 进入下一页
- (void)toNextPage:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (controller_)
    {
        [controller_ didSelectThumbAtIndex:btn.tag AndPressWhitchBtn:0 andChoosed:NO];
    }
}

// 弹出编辑视图
- (void)toShowFileEdit:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (controller_)
    {
        [controller_ didSelectThumbAtIndex:btn.tag-100 AndPressWhitchBtn:1 andChoosed:NO];
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
