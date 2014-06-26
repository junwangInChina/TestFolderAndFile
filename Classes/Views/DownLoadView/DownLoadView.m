//
//  DownLoadView.m
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DownLoadView.h"
#import "DownLoadCell.h"
#import "FileModel.h"
#import "DownLoadManagement.h"

@interface DownLoadView()<UITableViewDelegate,UITableViewDataSource,DownLoadCellDelegate>
{
    UITableView *m_downLoadTableView;
    
    NSMutableArray *m_downLoadArray;
    
    NSString *m_currentDirectoryPath;
    
    DownLoadManagement *m_downLoadManagement;
    
    NSMutableDictionary *m_progressDic;
}

@property (nonatomic, retain) UITableView *m_downLoadTableView;
@property (nonatomic, retain) NSMutableArray *m_downLoadArray;
@property (nonatomic, retain) NSString *m_currentDirectoryPath;
@property (nonatomic, retain) DownLoadManagement *m_downLoadManagement;
@property (nonatomic, retain) NSMutableDictionary *m_progressDic;

@end

@implementation DownLoadView
@synthesize m_downLoadTableView;
@synthesize m_downLoadArray;
@synthesize m_currentDirectoryPath;
@synthesize m_downLoadManagement;
@synthesize m_progressDic;

- (void)dealloc
{
    self.m_currentDirectoryPath = nil;
    self.m_downLoadTableView = nil;
    self.m_downLoadArray = nil;
    self.m_downLoadManagement = nil;
    self.m_progressDic = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGRect realFrame = frame;
        realFrame.size.height -= 44;
        
        [self createDownLoadURLArray];
        
        self.m_downLoadTableView = [self createTableView:realFrame];
        [self addSubview:self.m_downLoadTableView];
        
        self.m_progressDic = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
    }
    return self;
}

- (void)sentCurrentDirPath:(NSString *)currentPath
{
    self.m_currentDirectoryPath = currentPath;
}

- (void)stopRequestWhenDown
{
    
}

- (void)createDownLoadURLArray
{
    /*
    self.m_downLoadArray = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    NSArray *array = [[NSArray alloc] initWithObjects:@"http://www.hollywooddesktop.com/w/actresses/1920x1200/jennifer_aniston-010-1920x1200-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/actresses/1920x1200/jennifer_aniston-009-1920x1200-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/musicians/2560x1600/katy_perry-009-2560x1600-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/musicians/2560x1600/katy_perry-008-2560x1600-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/musicians/2560x1600/katy_perry-007-2560x1600-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/wallpaper/musicians/1920x1200/katy_perry-001-1920x1200-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/actresses/2560x1600/kristen_stewart-009-2560x1600-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/musicians/1920x1200/taylor_swift-014-1920x1200-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/w/musicians/2560x1600/taylor_swift-011-2560x1600-hollywooddesktop.jpg",@"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywooddesktop.jpg", nil];

    for (int i = 0; i<[array count]; i++)
    {
        FileModel *fileModel_ = [[[FileModel alloc] init] autorelease];
        [fileModel_ setM_downLoadURL:[array objectAtIndex:i]];
        [fileModel_ setM_downSaveDirPath:self.m_currentDirectoryPath];
        [fileModel_ setM_downLoadFileName:[[array objectAtIndex:i] lastPathComponent]];
        [self.m_downLoadArray addObject:fileModel_];
    }
     */
    self.m_downLoadArray = [[[NSMutableArray alloc] initWithObjects:
                             @"http://www.hollywooddesktop.com/w/actresses/1920x1200/jennifer_aniston-010-1920x1200-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/actresses/1920x1200/jennifer_aniston-009-1920x1200-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/musicians/2560x1600/katy_perry-009-2560x1600-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/musicians/2560x1600/katy_perry-008-2560x1600-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/musicians/2560x1600/katy_perry-007-2560x1600-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/1920x1200/katy_perry-001-1920x1200-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/actresses/2560x1600/kristen_stewart-009-2560x1600-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/musicians/1920x1200/taylor_swift-014-1920x1200-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/w/musicians/2560x1600/taylor_swift-011-2560x1600-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywooddesktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywooddesk123top.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywoo4561453ddesktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywood582desktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywood8565desktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywood216456esktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywood364451desktop.jpg",
                             @"http://www.hollywooddesktop.com/wallpaper/musicians/2560x1600/taylor_swift-006-2560x1600-hollywood823455desktop.jpg", nil] autorelease];
}

- (UITableView *)createTableView:(CGRect)tableFrame
{
    UITableView *table_ = [[[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped] autorelease];
    table_.delegate = self;
    table_.dataSource = self;
    return table_;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_downLoadArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *downLoadCellIdentifier = @"DownLoadTableCellIdentifier";
    
    DownLoadCell *cell = (DownLoadCell *)[tableView dequeueReusableCellWithIdentifier:downLoadCellIdentifier];
    if (cell == nil)
    {
        cell = [[[DownLoadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:downLoadCellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.downloadcell_delegate = self;
    cell.m_downLoadBtn.tag = indexPath.row + 100;
    cell.m_deleteBtn.tag = indexPath.row + 100;
    if ([self.m_downLoadArray count] > indexPath.row)
    {
        [cell sentURL:[self.m_downLoadArray objectAtIndex:indexPath.row]
           andDirPath:self.m_currentDirectoryPath
       andProgressDic:self.m_progressDic];
    }
    return cell;
}

- (void)removeRequest:(int)index
{
    if (index != -1)
    {
        /*
        [self.m_downLoadArray removeObjectAtIndex:index];
        NSUInteger indexPathDices[2];
        indexPathDices[0] = 0;
        indexPathDices[1] = index;
        NSIndexPath *deletePath = [NSIndexPath indexPathWithIndexes:indexPathDices length:2];
        NSArray *deleteArray = [NSArray arrayWithObjects:deletePath, nil];
        [self.m_downLoadTableView deleteRowsAtIndexPaths:deleteArray withRowAnimation:UITableViewRowAnimationFade];
        */
        /*
        [self.m_downLoadArray removeObjectAtIndex:index];
        [self.m_downLoadTableView reloadData];
         */
        NSString *requestName = [[self.m_downLoadArray objectAtIndex:index] lastPathComponent];
        // 移除任务，且删除已下载的缓存文件
        [self.m_downLoadManagement deleteRequest:requestName];
        // 移除Progress表里内容，避免表格重用问题
        [self.m_progressDic removeObjectForKey:requestName];
    }
}

- (void)starDownLoad:(int)index
{
    NSURL *url = [NSURL URLWithString:[self.m_downLoadArray objectAtIndex:index]];
    NSString *fileName = [[self.m_downLoadArray objectAtIndex:index] lastPathComponent];
    
    if (!self.m_downLoadManagement)
    {
        self.m_downLoadManagement = [[[DownLoadManagement alloc] init] autorelease];
    }

    [self.m_downLoadManagement createDownLoadRequest:url
                                         andSavePath:self.m_currentDirectoryPath
                                         andFileName:fileName];
    [m_downLoadManagement starDownLoad:^(float progress , NSString *requestName)
     {

         [self downLoadProgress:progress andRequestName:requestName];
     }
                    andSuccess:^(NSString *requestName)
     {

         [self downLoadSuccess:requestName];
     }
                     andFailed:^(NSString *requestName)
     {
         [self downLoadFailed:requestName];
         [CommonDeal showAlertWithTitle:@"Error" andMsgBody:@"download failed"];
     }
                   andFileName:fileName];
}

- (void)downLoadProgress:(float)progress_ andRequestName:(NSString *)requestName
{
    DownLoadCell *cell = [self getNowChangeCell:requestName];
    
    float realProgress = [[self.m_progressDic objectForKey:requestName] floatValue] + progress_;
    cell.m_downLoadProgress.progress = realProgress;
    cell.m_percentLbl.text = [NSString stringWithFormat:@"%.1f%@",realProgress*100,@"%"];
    
    [self.m_progressDic setObject:[NSNumber numberWithFloat:realProgress] forKey:requestName];
}

- (void)downLoadSuccess:(NSString *)requestName
{
    DownLoadCell *cell = [self getNowChangeCell:requestName];
    [cell.m_downLoadBtn setTitle:@"DownLoad" forState:UIControlStateNormal];
    cell.m_downLoadBtn.hidden = YES;
    cell.m_deleteBtn.hidden = YES;
}

- (void)downLoadFailed:(NSString *)requestName
{
    DownLoadCell *cell = [self getNowChangeCell:requestName];
    [cell.m_downLoadBtn setTitle:@"DownLoad" forState:UIControlStateNormal];
    cell.m_downLoadBtn.hidden = NO;
    cell.m_deleteBtn.hidden = YES;
}

// 根据Request标识，获取当前正在下载的cell是哪一个
- (DownLoadCell *)getNowChangeCell:(NSString *)requestName
{
    int row = 0;
    for (int i = 0; i<[self.m_downLoadArray count]; i++)
    {
        if ([[[self.m_downLoadArray objectAtIndex:i] lastPathComponent] isEqualToString:requestName])
        {
            row = i;
            
            continue;
        }
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    DownLoadCell *cell = (DownLoadCell *)[self.m_downLoadTableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)stopDownLoad:(int)index
{
    // 停止请求
    [self.m_downLoadManagement stopDownLoad:[[self.m_downLoadArray objectAtIndex:index] lastPathComponent]];
    // 清除进度，避免再次启动时，进度百分比会超过100％
    [self.m_progressDic removeObjectForKey:[[self.m_downLoadArray objectAtIndex:index] lastPathComponent]];
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
