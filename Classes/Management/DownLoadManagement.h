//
//  DownLoadManagement.h
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^DownLoadSuccessBlock)(NSString *requestName);
typedef void(^DownLoadFailedBlock)(NSString *requestName);
typedef void(^DownLoadProgressBlock)(float progress, NSString *requestName);

@interface DownLoadManagement : NSObject
{
    DownLoadSuccessBlock successBlock;
    DownLoadFailedBlock failedBlock;
    DownLoadProgressBlock progressBlock;
}

/*!
 @method
 @abstract     下载管理类实例化方法
 @discussion
 @param        downLoadURL: 下载链接    savePath:保存路径   fileName:保存文件名
 @result
 */
- (id)initWithURL:(NSURL *)downLoadURL andSaveDirectoryPath:(NSString *)savePath andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     创建一个下载请求
 @discussion
 @param        downLoadURL: 下载链接    savePath:保存路径   fileName:保存文件名
 @result
 */
- (void)createDownLoadRequest:(NSURL *)downLoadURL andSavePath:(NSString *)savePath andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     开始下载
 @discussion
 @param        progressBlock: 进度条    successBlock:成功   failedBlock:失败  requestName:根据它来分别多个request
 @result
 */
- (void)starDownLoad:(DownLoadProgressBlock)progressBlock_
          andSuccess:(DownLoadSuccessBlock)successBlock_
           andFailed:(DownLoadFailedBlock)failedBlock_
         andFileName:(NSString *)requestName;

/*!
 @method
 @abstract     停止下载
 @discussion
 @param        requestName:根据它来分别多个request
 @result
 */
- (void)stopDownLoad:(NSString *)requestName;

/*!
 @method
 @abstract     删除下载任务
 @discussion
 @param        requestName:根据它来分别多个request
 @result
 */
- (void)deleteRequest:(NSString *)requestName;
@end
