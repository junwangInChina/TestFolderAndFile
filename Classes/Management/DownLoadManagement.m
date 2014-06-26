//
//  DownLoadManagement.m
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "DownLoadManagement.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface DownLoadManagement()<ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    ASINetworkQueue * m_networkQueue;
    
    NSMutableDictionary *m_allBytesDic;
}

@property (nonatomic, retain) ASINetworkQueue * m_networkQueue;
@property (nonatomic, retain) NSMutableDictionary *m_allBytesDic;

@end

@implementation DownLoadManagement
@synthesize m_networkQueue;
@synthesize m_allBytesDic;

- (void)dealloc
{
    [self.m_networkQueue cancelAllOperations];
    self.m_networkQueue.delegate = nil;
    self.m_networkQueue = nil;
    self.m_allBytesDic = nil;
    
    Block_release(successBlock);
    Block_release(failedBlock);
    Block_release(progressBlock);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"downLoadGiveUp" object:nil];
    
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        if (!self.m_networkQueue)
        {
            self.m_networkQueue = [[[ASINetworkQueue alloc] init] autorelease];
            m_networkQueue.delegate = self;
            m_networkQueue.downloadProgressDelegate = self;
            m_networkQueue.maxConcurrentOperationCount = 2;
            m_networkQueue.showAccurateProgress = YES;

            self.m_allBytesDic = [[[NSMutableDictionary alloc] init] autorelease];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giveUpRequest) name:@"downLoadGiveUp" object:nil];
        }
    }
    return self;
}

/**
 * 方法无法实现队列功能，放弃使用
 */
- (id)initWithURL:(NSURL *)downLoadURL andSaveDirectoryPath:(NSString *)savePath andFileName:(NSString *)fileName
{
    self = [super init];
    if (self)
    {
        if (!self.m_networkQueue)
        {
            self.m_networkQueue = [[[ASINetworkQueue alloc] init] autorelease];
            m_networkQueue.maxConcurrentOperationCount = 2;
            m_networkQueue.showAccurateProgress = YES;
        }
        /*
        self.m_request = [[[ASIHTTPRequest alloc] initWithURL:downLoadURL] autorelease];
        m_request.delegate = self;
        m_request.downloadProgressDelegate = self;
        m_request.showAccurateProgress = YES;
        [m_request setDownloadDestinationPath:[savePath stringByAppendingPathComponent:fileName]];
        [m_request setTemporaryFileDownloadPath:[[CommonDeal getCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileName]]];
        [m_request setUserInfo:[NSDictionary dictionaryWithObject:fileName forKey:@"name"]];
        m_request.allowResumeForFileDownloads = YES;
        */
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:downLoadURL] ;
        request.delegate = self;
        //request.downloadProgressDelegate = self;
        request.showAccurateProgress = YES;
        [request setDownloadDestinationPath:[savePath stringByAppendingPathComponent:fileName]];
        [request setTemporaryFileDownloadPath:[[CommonDeal getCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileName]]];
        [request setUserInfo:[NSDictionary dictionaryWithObject:fileName forKey:@"name"]];
        request.allowResumeForFileDownloads = YES;
        [m_networkQueue addOperation:request];
        [request release];
        
        
    }
    return self;
}

- (void)createDownLoadRequest:(NSURL *)downLoadURL
                  andSavePath:(NSString *)savePath
                  andFileName:(NSString *)fileName
{
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:downLoadURL] ;
    // 下载委托
    request.delegate = self;
    // 进度条委托
    request.downloadProgressDelegate = self;
    // 设置精确显示进度条信息
    request.showAccurateProgress = YES;
    // 设置下载文件保存路径
    [request setDownloadDestinationPath:[savePath stringByAppendingPathComponent:fileName]];
    // 设置下载时临时文件保存路径（下载时，数据保存在临时文件中。下载完整后数据被copy到下载文件中，临时文件被删除）
    [request setTemporaryFileDownloadPath:[[CommonDeal getCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileName]]];
    // 设置request信息，用于标识多个请求
    [request setUserInfo:[NSDictionary dictionaryWithObject:fileName forKey:@"name"]];
    // 设置支持文件断点续传
    request.allowResumeForFileDownloads = YES;
    // 将请求加入队列
    [self.m_networkQueue addOperation:request];
    [request release];
     /*
    self.m_request = [[[ASIHTTPRequest alloc] initWithURL:downLoadURL] autorelease];
    m_request.delegate = self;
    m_request.downloadProgressDelegate = self;
    m_request.showAccurateProgress = YES;
    [m_request setDownloadDestinationPath:[savePath stringByAppendingPathComponent:fileName]];
    [m_request setTemporaryFileDownloadPath:[[CommonDeal getCachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",fileName]]];
    [m_request setUserInfo:[NSDictionary dictionaryWithObject:fileName forKey:@"name"]];
    m_request.allowResumeForFileDownloads = YES;
    [self.m_networkQueue addOperation:self.m_request];
    */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(giveUpRequest) name:@"downLoadGiveUp" object:nil];
}

// 请求完成
- (void)requestFinished:(ASIHTTPRequest *)request
{
    request.delegate = nil;
    
    successBlock([request.userInfo objectForKey:@"name"]);
}

// 请求失败
- (void)requestFailed:(ASIHTTPRequest *)request
{
    request.delegate = nil;
    
    failedBlock([request.userInfo objectForKey:@"name"]);
}

/*!
 @method        downloadProgressDelegate Method 
 @abstract      每秒接收到数据会走这个方法
 @discussion
 @param         request:哪个请求     bytes:当前接收到的数据量
 @result
 */
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    NSString *requestName = [request.userInfo objectForKey:@"name"];
    float progress = bytes / [[self.m_allBytesDic objectForKey:requestName] floatValue];
    if (progressBlock)
    {
        progressBlock(progress,requestName);
    }
}

///*!
// @method        进度条委托方法
// @abstract      这是进度条的委托方法，它能准确的反映当前下载的进度。但是由于无法区分是哪个请求的，故适用于单个请求
// @discussion
// @param         newProgress:当前进度
// @result
// */
//- (void)setProgress:(float)newProgress
//{
//    
//}

/*!
 @method        
 @abstract      请求开始时会走这个方法，用于返回当前请求的数据量大小
 @discussion
 @param         request:哪个请求     newLength:当前请求的数据量
 @result
 */
- (void)request:(ASIHTTPRequest *)request incrementDownloadSizeBy:(long long)newLength
{
    float allBytes = newLength;
    [self.m_allBytesDic setObject:[NSNumber numberWithFloat:allBytes] forKey:[request.userInfo objectForKey:@"name"]];
}

- (void)starDownLoad:(DownLoadProgressBlock)progressBlock_
          andSuccess:(DownLoadSuccessBlock)successBlock_
           andFailed:(DownLoadFailedBlock)failedBlock_
         andFileName:(NSString *)requestName
{
    [self.m_networkQueue go];
    progressBlock = Block_copy(progressBlock_);
    successBlock = Block_copy(successBlock_);
    failedBlock = Block_copy(failedBlock_);
    
}

- (void)stopDownLoad:(NSString *)requestName
{
    for (int i = 0; i<[[self.m_networkQueue operations] count]; i++)
    {
        ASIHTTPRequest *request_ = [[self.m_networkQueue operations] objectAtIndex:i];
        if ([[request_.userInfo objectForKey:@"name"] isEqualToString:requestName])
        {
            [request_ clearDelegatesAndCancel];

            return;
        }
    }
}

- (void)deleteRequest:(NSString *)requestName
{
    // 删除缓存文件
    NSString *deleteName = [NSString stringWithFormat:@"%@.temp",requestName];
    NSString *cachePath = [[CommonDeal getCachePath] stringByAppendingPathComponent:deleteName];
    [CommonDeal deleteFile:cachePath andFileName:@""];
    
    [self stopDownLoad:requestName];
    
    [self.m_allBytesDic removeObjectForKey:requestName];
}

// 放弃下载
- (void)giveUpRequest
{
    for (int i = 0; i<[[self.m_networkQueue operations] count]; i++)
    {
        ASIHTTPRequest *request_ = [[self.m_networkQueue operations] objectAtIndex:i];
       
        [request_ clearDelegatesAndCancel];
    }
    
    [self.m_networkQueue cancelAllOperations];
    self.m_networkQueue.delegate = nil;
    self.m_networkQueue = nil;
}

@end
