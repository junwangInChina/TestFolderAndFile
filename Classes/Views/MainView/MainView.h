//
//  MainView.h
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@protocol MainViewDelegate <NSObject>

/*!
 @method
 @abstract     进入子目录
 @discussion
 @param        currentPath:子目录的路径  folderName:文件夹名称
 @result
 */
- (void)goToNextPage:(NSString *)currentPath andFolderName:(NSString *)folderName;

/*!
 @method
 @abstract     查看文件详情
 @discussion
 @param        currentPath:文件路径 fileName:文件名称
 @result
 */
- (void)goToDetail:(NSString *)currentPath andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     查看图片
 @discussion
 @param        imagePath:图片路径 imageName:图片名称
 @result
 */
- (void)goToShowView:(NSString *)currentFilePath andImageName:(NSString *)currentFileName;

/*!
 @method
 @abstract     删除文件
 @discussion
 @param        currentPath:文件路径 fileName:文件名称
 @result
 */
- (void)deleteFileWithPath:(NSString *)currentPath andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     删除文件,多选删除
 @discussion
 @param        choosed:表示是否选中 fileName:需要删除的文件名
 @result
 */
- (void)userChooseFileDelete:(BOOL)choosed andFileName:(NSString *)fileName;

/*!
 @method
 @abstract     编辑文件/文件夹  文件的重命名、复制、剪切等操作
 @discussion
 @param        fileName:需要修改名称的文件夹名
 @result
 */
- (void)chooseEditFileOrFolderWithName:(NSString *)fileName;

@end

typedef void(^MainViewBlock)(BOOL isEditing);

@interface MainView : UIView
{
    __weak id<MainViewDelegate>main_delegate;
    
    MainViewBlock main_block;
}

@property (nonatomic, weak) id<MainViewDelegate>main_delegate;

/*!
 @method
 @abstract     编辑表格
 @discussion
 @param        block_: 用于返回表格编辑状态
 @result
 */
- (void)sentUserEditTableView:(MainViewBlock)block_;

/*!
 @method
 @abstract     设置表格不可编辑
 @discussion
 @param        
 @result
 */
- (void)sentTableCancelEdit;

/*!
 @method
 @abstract     将数据传递到View层，展示
 @discussion
 @param        fileArray:文件列表数组  currentPath_:当前目录的路径
 @result       
 */
- (void)sentFileArray:(NSMutableArray *)fileArray
       andCurrentPath:(NSString *)currentPath_;

@end
