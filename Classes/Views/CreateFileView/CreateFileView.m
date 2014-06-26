//
//  CreateFileView.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "CreateFileView.h"

@interface CreateFileView()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *m_messageArray;
    UITableView *m_createtableView;
}

@property (nonatomic, retain) NSArray *m_messageArray;
@property (nonatomic, retain) UITableView *m_createtableView;

@end

@implementation CreateFileView
@synthesize m_messageArray;
@synthesize m_createtableView;
@synthesize createFile_delegate;

- (void)dealloc
{
    self.m_messageArray = nil;
    self.m_createtableView = nil;
    self.createFile_delegate = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createMessageArray];
        
        [self createTableView:frame];
    }
    return self;
}

- (void)createMessageArray
{
    self.m_messageArray = [[[NSArray alloc] initWithObjects:@"Create File",@"Local Upload",@"Upload Photo",@"Local Vedio",@"Upload Vedio",@"Upload Audio", nil] autorelease];
}

- (void)createTableView:(CGRect)frame_
{
    self.m_createtableView = [[[UITableView alloc] initWithFrame:frame_ style:UITableViewStyleGrouped] autorelease];
    m_createtableView.delegate = self;
    m_createtableView.dataSource = self;
    [self addSubview:m_createtableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableViewIdentifier = @"CreatViewTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableViewIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.m_messageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.createFile_delegate && [self.createFile_delegate respondsToSelector:@selector(userChooseCreate:)])
    {
        [self.createFile_delegate userChooseCreate:indexPath.row];
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
