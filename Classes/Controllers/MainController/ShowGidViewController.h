//
//  ShowGidViewController.h
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"

typedef void(^ShowGidControlBlock)(BOOL isEditing);

@interface ShowGidViewController : KTThumbsViewController
{
    ShowGidControlBlock showGidControl_block;
}

/*!
 @method
 @abstract     编辑九宫格
 @discussion
 @param        block_: 用于返回表格编辑状态
 @result
 */
- (void)sentGidControlEdit:(ShowGidControlBlock)block_;

/*!
 @method
 @abstract     取消编辑九宫格
 @discussion
 @param
 @result
 */
- (void)cancelEditGidControl;

/*!
 @method
 @abstract     刷新页面
 @discussion
 @param        messageArray:需要展示的数组信息
 @result
 */
- (void)refreshViewWithMessage:(NSMutableArray *)messageArray;

@end
