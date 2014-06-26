//
//  GidKTThumbView.h
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbView.h"
#import "KTThumbsViewController.h"
#import "FileModel.h"

@interface GidKTThumbView : KTThumbView
{
    // 图标按钮
    UIButton *m_iconBtn;
    // 删除按钮
    UIButton *m_deleteBtn;
    
    // 文件名
    UILabel *m_fileNameLbl;
    // 创建时间
    UILabel *m_fileCreateLbl;
    // 大小
    UILabel *m_fileSizeLbl;
    
    BOOL m_isChoosed;
}

@property (nonatomic, retain) UIButton *m_deleteBtn;
@property (nonatomic, retain) UIButton *m_iconBtn;
@property (nonatomic, retain) UILabel *m_fileNameLbl;
@property (nonatomic, retain) UILabel *m_fileCreateLbl;
@property (nonatomic, retain) UILabel *m_fileSizeLbl;
@property (nonatomic) BOOL m_isChoosed;

/*!
 @method
 @abstract     将Model传递到最终view层展示
 @discussion
 @param        fileModel_:需要展示的Model
 @result
 */
- (void)sentFileModelToShow:(FileModel *)fileModel_;

/*!
 @method
 @abstract     将是否展示删除按钮传递到View层
 @discussion
 @param        edit:是否需要展示
 @result
 */
- (void)sentEditDeleteBtn:(BOOL)edit andIsChoosed:(BOOL)choosed_;

@end
