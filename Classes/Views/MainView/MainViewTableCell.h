//
//  MainViewTableCell.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FileModel.h"

@protocol MainViewTableCellDelegate <NSObject>

/*!
 @method
 @abstract     用户点击选择按钮时，将按钮信息传递到View层
 @discussion
 @param        isChoose:表示当前是选中还是未选中  index_:表示选中的行数
 @result
 */
- (void)chooseFile:(BOOL)isChoose andIndex:(int)index_;

/*!
 @method
 @abstract     编辑文件/文件夹   复制、剪切、重命名等操作
 @discussion
 @param        index_:选中的文件
 @result
 */
- (void)fileOrFolderEdit:(int)index_;

@end

@interface MainViewTableCell : UITableViewCell
{
    NSString *m_currPath;
    
    UIButton *m_chooseBtn;
    
    UIButton *m_iconImageBtn;
    
    // 表示表格处于编辑状态
    BOOL m_isEdited;
    // 表示当前行已经被选中
    BOOL m_isChoosed;
    
    id<MainViewTableCellDelegate>mainCell_delegate;
}

@property (nonatomic, retain) NSString *m_currPath;
@property (nonatomic, retain) UIButton *m_chooseBtn;
@property (nonatomic, retain) UIButton *m_iconImageBtn;
@property (nonatomic) BOOL m_isEdited;
@property (nonatomic) BOOL m_isChoosed;
@property (nonatomic, assign) id<MainViewTableCellDelegate>mainCell_delegate;

/*!
 @method
 @abstract     将文件名传递到Cell中展示
 @discussion
 @param        fileName:文件名称
 @result
 */
- (void)sentMessageToShowCell:(FileModel *)fileMod;

/*!
 @method
 @abstract     将表格编辑状态传递到Cell页面，以便展示选择按钮
 @discussion
 @param        isEditing_:编辑状态
 @result
 */
- (void)sentTableViewIsEdit:(BOOL)isEditing_;

/*!
 @method
 @abstract     将表格选中状态传递到Cell页面，以便展示选择按钮
 @discussion
 @param        isChoosed:选中状态
 @result
 */
- (void)sentUserChoosed:(BOOL)isChoosed;
@end
