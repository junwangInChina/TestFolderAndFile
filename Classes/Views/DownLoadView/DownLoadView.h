//
//  DownLoadView.h
//  TestFolderAndFile
//
//  Created by user on 13-8-9.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownLoadView : UIView

/*!
 @method
 @abstract     将当前路径传递到下一层
 @discussion
 @param        currentPath:当前所在的目录路径
 @result
 */
- (void)sentCurrentDirPath:(NSString *)currentPath;

/*!
 @method
 @abstract     点击Down，先取消请求
 @discussion
 @param        
 @result
 */
- (void)stopRequestWhenDown;

@end
