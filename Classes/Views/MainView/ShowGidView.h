//
//  ShowGidView.h
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShowGidViewDelegate <NSObject>


/*!
 @method
 @abstract     进入子目录
 @discussion
 @param        currentPath:子目录的路径  folderName:文件夹名称
 @result
 */
- (void)goToNextPageGid:(NSString *)currentPath andFolderName:(NSString *)folderName;

/*!
 @method
 @abstract     查看文件详情
 @discussion
 @param        currentPath:文件路径 fileName:文件名称
 @result
 */
- (void)goToDetailGid:(NSString *)currentPath andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     查看图片
 @discussion
 @param        imagePath:图片路径 imageName:图片名称
 @result
 */
- (void)goToShowViewGid:(NSString *)currentFilePath andImageName:(NSString *)fileName;

/*!
 @method
 @abstract     编辑文件/文件夹  文件的重命名、复制、剪切等操作
 @discussion
 @param        fileName:需要修改名称的文件夹名
 @result
 */
- (void)chooseEditFileOrFolderWithNameGid:(NSString *)fileName;

/*!
 @method
 @abstract     多选删除时，将选中/取消选中的信息传递到Controller层
 @discussion
 @param        choosed:是否选中  fileName:当前操作的文件名
 @result
 */
- (void)moreDeleteWhileUserChooseOrFail:(BOOL)choosed andFileName:(NSString *)fileName;

@end

typedef void(^ShowGidBlock)(BOOL isEditing);

@interface ShowGidView : UIView
{
    id <ShowGidViewDelegate>showGid_delegate;
    
    ShowGidBlock showGid_block;
}

@property (nonatomic, assign) id <ShowGidViewDelegate>showGid_delegate;

/*!
 @method
 @abstract     编辑九宫格
 @discussion
 @param        block_: 用于返回表格编辑状态
 @result
 */
- (void)setGidViewBeEdit:(ShowGidBlock)block_;

/*!
 @method
 @abstract     取消编辑九宫格
 @discussion
 @param        
 @result
 */
- (void)cancelEditTypeGid;

/*!
 @method
 @abstract     将用户展示的数组，传递到View层
 @discussion
 @param        array_:需要展示的数组信息  currentPath_:当前目录路径
 @result
 */
- (void)sentUserToShowArray:(NSMutableArray *)array_ andCurrentPath:(NSString *)currentPath_;

@end
