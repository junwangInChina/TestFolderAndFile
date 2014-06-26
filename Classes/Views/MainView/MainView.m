//
//  MainView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "MainView.h"
#import "MainViewTableCell.h"
#import "FileModel.h"

@interface MainView()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MainViewTableCellDelegate>
{
    // 用于展示的表格
    UITableView *m_mainTableView;
    
    // 当前目录下的文件列表
    NSMutableArray *m_allFileArray;
    
    // 当前目录路径
    NSString *m_currentPath;
    
    // 表示选中的删除行（单个删除）
    int m_chooseIndex;
    
    // 表示多选删除时，选中的行数集合
    NSMutableArray *m_chooseRowArray;
    
    // 表示表格是否处于编辑状态;
    BOOL m_isEditing;
}

@property (nonatomic, strong) NSMutableArray *m_allFileArray;
@property (nonatomic, strong) NSString *m_currentPath;
@property (nonatomic, strong) UITableView *m_mainTableView;
@property (nonatomic, strong) NSMutableArray *m_chooseRowArray;
@property (nonatomic) int m_chooseIndex;
@property (nonatomic) BOOL m_isEditing;

@end

@implementation MainView
@synthesize m_allFileArray;
@synthesize m_currentPath;
@synthesize main_delegate;
@synthesize m_chooseIndex;
@synthesize m_mainTableView;
@synthesize m_isEditing;
@synthesize m_chooseRowArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.m_chooseIndex = -1;
        self.m_isEditing = NO;
        self.m_chooseRowArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self createTableView:frame];
    }
    return self;
}

- (void)sentUserEditTableView:(MainViewBlock)block_
{
    main_block = block_;
    if ([self.m_allFileArray count] == 0)
    {
        self.m_isEditing = NO;
        main_block(NO);
    }
    else
    {
        self.m_isEditing = !m_isEditing;
    }
    
    if (m_isEditing)
    {
        main_block(YES);
    }
    else
    {
        main_block(NO);
    }
        
    [m_mainTableView  reloadData];
}

- (void)sentTableCancelEdit
{
    self.m_isEditing = NO;
    
    [m_mainTableView reloadData];
}

- (void)sentFileArray:(NSMutableArray *)fileArray andCurrentPath:(NSString *)currentPath_
{
    self.m_allFileArray = fileArray;
    self.m_currentPath = currentPath_;
    
    [m_mainTableView reloadData];
}

- (void)createTableView:(CGRect)frame_
{
    self.m_mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, frame_.size.height - 44) style:UITableViewStyleGrouped];
    m_mainTableView.delegate = self;
    m_mainTableView.dataSource = self;
    [self addSubview:m_mainTableView];
}

#pragma mark - UITableView Delegate Method
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.m_allFileArray count] == 0)
    {
        return 1;
    }
    else
    {
        return [self.m_allFileArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.m_allFileArray count] == 0)
    {
        static NSString *NoResultsIdentifierString_ =
        @"NoResultsTableCellIdentifierString_";
        UITableViewCell *cell_ = [tableView dequeueReusableCellWithIdentifier:
                                  NoResultsIdentifierString_];
        if (cell_ == nil)
        {
            cell_ = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NoResultsIdentifierString_] ;
        }
        cell_.textLabel.text = @"No Record";
        cell_.textLabel.textAlignment = NSTextAlignmentCenter;
        cell_.userInteractionEnabled = NO;
        return cell_;
    }
    else
    {
        static NSString *fileTableViewIdentifier = @"FileArrayTableViewIdentifier";
        MainViewTableCell *cell = (MainViewTableCell *)[tableView dequeueReusableCellWithIdentifier:fileTableViewIdentifier];
        if (cell == nil)
        {
            cell = [[MainViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fileTableViewIdentifier];
        }
        cell.mainCell_delegate = self;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setM_currPath:self.m_currentPath];
        cell.m_chooseBtn.tag = indexPath.row + 200;
        cell.m_iconImageBtn.tag = indexPath.row + 300;
        [cell sentTableViewIsEdit:self.m_isEditing];
        [cell sentUserChoosed:NO];
        if ([self.m_allFileArray count] > indexPath.row)
        {
            [cell sentMessageToShowCell:[self.m_allFileArray objectAtIndex:indexPath.row]];
            
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FileModel *fileModel_ = [self.m_allFileArray objectAtIndex:indexPath.row];
    NSString *fileName = fileModel_.m_fileName;
    NSString *currentPath = [self.m_currentPath stringByAppendingPathComponent:fileName];
    
    // 判断如果是文件夹，则进入子目录
    if ([CommonDeal chectIsFolder:currentPath])
    {
        [self toNextPage:currentPath andFolderName:fileName];
    }
    // 否则进入详情
    else
    {
        // 表示普通文件，则按照原来的流程
        if ([fileModel_.m_fileType isEqualToString:@"4"])
        {
            [self toDetail:currentPath andFileName:fileName];
        }
        else
        {
            [self toShowView:currentPath andImageName:fileName];
        }
        
        /*
        // 如果是图片
        if ([CommonDeal checkIsImage:fileName])
        {
            [self toShowImage:currentPath andImageName:fileName];
        }
        // 普通文件
        else
        {
            [self toDetail:currentPath andFileName:fileName];
        }
        */
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        self.m_chooseIndex = indexPath.row;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete"
                                                        message:@"Are you sure?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Confirm", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        FileModel *fileModel_ = [self.m_allFileArray objectAtIndex:self.m_chooseIndex];
        NSString *fileName = fileModel_.m_fileName;
        NSString *currentPath = [self.m_currentPath stringByAppendingPathComponent:fileName];
        
        if (self.main_delegate && [self.main_delegate respondsToSelector:@selector(deleteFileWithPath:andFileName:)])
        {
            [self.main_delegate deleteFileWithPath:currentPath andFileName:fileName];
        }
    }
}

#pragma mark - TableViewCell Private Delegate Method
// 选中/取消选中 
- (void)chooseFile:(BOOL)isChoose andIndex:(int)index_
{
    NSString *fileName = [[self.m_allFileArray objectAtIndex:index_] m_fileName];
    
    if (self.main_delegate && [self.main_delegate respondsToSelector:@selector(userChooseFileDelete:andFileName:)])
    {
        [self.main_delegate userChooseFileDelete:isChoose andFileName:fileName];
    }
}

// 修改文件夹名称
- (void)fileOrFolderEdit:(int)index_
{
    NSString *fileName = [[self.m_allFileArray objectAtIndex:index_] m_fileName];
    if (self.main_delegate && [self.main_delegate respondsToSelector:@selector(chooseEditFileOrFolderWithName:)])
    {
        [self.main_delegate chooseEditFileOrFolderWithName:fileName];
    }
}

#pragma mark - Private Delegate Method
// 进入下级目录
- (void)toNextPage:(NSString *)currPath_ andFolderName:(NSString *)folderName
{
    if (self.main_delegate && [self.main_delegate respondsToSelector:@selector(goToNextPage:andFolderName:)])
    {
        [self.main_delegate goToNextPage:currPath_ andFolderName:folderName];
    }
}

// 查看其他文件
- (void)toShowView:(NSString *)currentPath_ andImageName:(NSString *)imageName_
{
    if (self.main_delegate && [self.main_delegate respondsToSelector:@selector(goToShowView:andImageName:)])
    {
        [self.main_delegate goToShowView:currentPath_ andImageName:imageName_];
    }
}

// 查看文件详情
- (void)toDetail:(NSString *)currpath_ andFileName:(NSString *)fileName
{
    if (self.main_delegate && [self.main_delegate respondsToSelector:@selector(goToDetail:andFileName:)])
    {
        [self.main_delegate goToDetail:currpath_ andFileName:fileName];
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
