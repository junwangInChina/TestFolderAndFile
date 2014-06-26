//
//  MainViewTableCell.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MainViewTableCell.h"

@interface MainViewTableCell()
{
    
    UILabel *m_nameLbl;
    UILabel *m_sizerLbl;
    UILabel *m_dateLbl;
    UILabel *m_typeLbl;
}


@property (nonatomic, retain) UILabel *m_nameLbl;
@property (nonatomic, retain) UILabel *m_sizerLbl;
@property (nonatomic, retain) UILabel *m_dateLbl;
@property (nonatomic, retain) UILabel *m_typeLbl;

@end

@implementation MainViewTableCell
@synthesize m_iconImageBtn;
@synthesize m_nameLbl;
@synthesize m_sizerLbl;
@synthesize m_dateLbl;
@synthesize m_typeLbl;
@synthesize m_chooseBtn;
@synthesize m_currPath;
@synthesize m_isEdited;
@synthesize m_isChoosed;
@synthesize mainCell_delegate;

- (void)dealloc
{
    self.m_currPath = nil;
    self.m_iconImageBtn = nil;
    self.m_nameLbl = nil;
    self.m_sizerLbl = nil;
    self.m_dateLbl = nil;
    self.m_typeLbl = nil;
    self.m_chooseBtn = nil;
    self.mainCell_delegate = nil;
    
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.m_isChoosed = NO;
        
        [self createIconImage];
        
        self.m_nameLbl = [self createLabel:CGRectMake(50, 0, 190, 28)];
        m_nameLbl.font = [UIFont boldSystemFontOfSize:11];
        m_nameLbl.numberOfLines = 0;
        [self.contentView addSubview:m_nameLbl];
        
        self.m_dateLbl = [self createLabel:CGRectMake(50, 24, 180, 18)];
        [self.contentView addSubview:m_dateLbl];
        
        self.m_sizerLbl = [self createLabel:CGRectMake(150, 4, 120, 18)];
        m_sizerLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:m_sizerLbl];
        
        self.m_typeLbl = [self createLabel:CGRectMake(150, 24, 120, 18)];
        m_typeLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:m_typeLbl];
        
        // 此按钮的作用是防止用户在多选删除时，不小心点到Cell而进入下级目录了
        UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 0, 100, 44)];
        stopBtn.backgroundColor = [UIColor clearColor];
        [stopBtn addTarget:self action:@selector(stopBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:stopBtn];
        [stopBtn release];
        
        [self createChooseBtn];
    }
    return self;
}

- (void)stopBtnPress
{
    
}

- (void)createIconImage
{
    self.m_iconImageBtn = [[[UIButton alloc] initWithFrame:CGRectMake(4, 2, 40, 40)] autorelease];
    [m_iconImageBtn addTarget:self action:@selector(imageBtnPress:) forControlEvents:UIControlEventTouchUpInside];
    m_iconImageBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:m_iconImageBtn];

}

- (UILabel *)createLabel:(CGRect)lblFrame
{
    UILabel *label_ = [[[UILabel alloc] initWithFrame:lblFrame] autorelease];
    label_.backgroundColor = [UIColor clearColor];
    label_.font = [UIFont fontWithName:@"Arial" size:11];
    return label_;
}

- (void)createChooseBtn
{
    self.m_chooseBtn = [[[UIButton alloc] initWithFrame:CGRectMake(240, 7, 30, 30)] autorelease];
    [m_chooseBtn addTarget:self action:@selector(choosePress:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:m_chooseBtn];
}

- (void)sentMessageToShowCell:(FileModel *)fileMod
{
    self.m_nameLbl.text = [NSString stringWithFormat:@"%@",fileMod.m_fileName];
    self.m_sizerLbl.text = [NSString stringWithFormat:@"%@",fileMod.m_fileSizer];
    self.m_dateLbl.text = [NSString stringWithFormat:@"%@",fileMod.m_fileCreateDate];
    NSString *filePath = [fileMod.m_filePath stringByAppendingPathComponent:fileMod.m_fileName];
    if ([CommonDeal chectIsFolder:filePath])
    {
        [self.m_iconImageBtn setBackgroundImage:[UIImage imageNamed:@"folder.png"] forState:UIControlStateNormal];
        self.m_typeLbl.text = @"目录文件";
    }
    else
    {
        if ([fileMod.m_fileType intValue] == 2)
        {
            NSString *videoPath = [fileMod.m_filePath stringByAppendingPathComponent:fileMod.m_fileName];
            [self.m_iconImageBtn setBackgroundImage:[CommonDeal getVideoThumbnailImage:videoPath] forState:UIControlStateNormal];
            //[self.m_iconImageBtn setBackgroundImage:[CommonDeal getVideoImage:videoPath] forState:UIControlStateNormal];
        }
        else
        {
            [self.m_iconImageBtn setBackgroundImage:[UIImage imageNamed:fileMod.m_fileImageName] forState:UIControlStateNormal];
        }
        
        self.m_typeLbl.text = [NSString stringWithFormat:@"%@",[self getTypeDesctiption:fileMod.m_fileType]];
    }
    
    [self updateChooseBtnImageWithChooseType:fileMod.m_fileIsChoose];
}

- (NSString *)getTypeDesctiption:(NSString *)type
{
    NSString *iconNameString = @"";
    
    switch ([type intValue])
    {
        case 1:
            iconNameString = @"图片文件";
            break;
        case 2:
            iconNameString = @"视频文件";
            break;
        case 3:
            iconNameString = @"音频文件";
            break;
        case 4:
            iconNameString = @"文档文件";
            break;
        case 5:
            iconNameString = @"网页文件";
            break;
        case 6:
            iconNameString = @"PDF文件";
            break;
        default:
            iconNameString = @"未知文件";
            break;
    }
    
    return iconNameString;
}

- (void)sentTableViewIsEdit:(BOOL)isEditing_
{
    self.m_isEdited = isEditing_;
    if (m_isEdited)
    {
        m_chooseBtn.alpha = 1.0;
        m_chooseBtn.enabled = YES;
    }
    else
    {
        m_chooseBtn.alpha = 0.0;
        m_chooseBtn.enabled = NO;
    }
}

- (void)sentUserChoosed:(BOOL)isChoosed
{
    self.m_isChoosed = isChoosed;
    
    [self updateChooseBtnImageWithChooseType:@"0"];
}

- (void)choosePress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    self.m_isChoosed = !m_isChoosed;
    
    if (self.mainCell_delegate && [self.mainCell_delegate respondsToSelector:@selector(chooseFile:andIndex:)])
    {
        [self.mainCell_delegate chooseFile:self.m_isChoosed andIndex:btn.tag - 200];
    }
}

- (void)updateChooseBtnImageWithChooseType:(NSString *)fileChooseType
{
    if ([fileChooseType intValue] == 1)
    {
        self.m_isChoosed = YES;
        [m_chooseBtn setBackgroundImage:[UIImage imageNamed:@"selected.png"] forState:UIControlStateNormal];
    }
    else
    {
        self.m_isChoosed = NO;
        [m_chooseBtn setBackgroundImage:[UIImage imageNamed:@"select.png"] forState:UIControlStateNormal];
    }
}

// 修改文件夹名称
- (void)imageBtnPress:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if (self.mainCell_delegate && [self.mainCell_delegate respondsToSelector:@selector(fileOrFolderEdit:)])
    {
        [self.mainCell_delegate fileOrFolderEdit:btn.tag - 300];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
