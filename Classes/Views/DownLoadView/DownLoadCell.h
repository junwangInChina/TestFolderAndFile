//
//  DownLoadCell.h
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@protocol DownLoadCellDelegate <NSObject>

/*!
 @method
 @abstract     开始下载
 @discussion
 @param        index:点击的第几行
 @result
 */
- (void)starDownLoad:(int)index;

/*!
 @method
 @abstract     暂停下载
 @discussion
 @param        index:点击的第几行
 @result
 */
- (void)stopDownLoad:(int)index;

/*!
 @method
 @abstract     移除下载任务
 @discussion
 @param        index:点击的第几行
 @result
 */
- (void)removeRequest:(int)index;

@end

@interface DownLoadCell : UITableViewCell
{
    UIButton *m_downLoadBtn;
    UIButton *m_deleteBtn;
    UIProgressView *m_downLoadProgress;
    UILabel *m_percentLbl;
    
    id<DownLoadCellDelegate>downloadcell_delegate;
}

@property (nonatomic, assign) id<DownLoadCellDelegate>downloadcell_delegate;
@property (nonatomic, retain) UIButton *m_downLoadBtn;
@property (nonatomic, retain) UIButton *m_deleteBtn;
@property (nonatomic, retain) UIProgressView *m_downLoadProgress;
@property (nonatomic, retain) UILabel *m_percentLbl;

/*!
 @method
 @abstract     用于展示
 @discussion
 @param        imageUrl:图片地址
 @result
 */
- (void)sentMessageShow:(FileModel *)fileModel_;

/*!
 @method
 @abstract     用于展示
 @discussion
 @param        downloadURL:图片地址  path:目录路径
 @result
 */
- (void)sentURL:(NSString *)downloadURL
     andDirPath:(NSString *)path
 andProgressDic:(NSMutableDictionary *)downLoadDic;

@end
