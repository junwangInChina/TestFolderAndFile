//
//  DetailView.h
//  TestFolderAndFile
//
//  Created by user on 13-7-28.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewDelegate <NSObject>

/*!
 @method
 @abstract     将用户输入的值传入Controller
 @discussion
 @param        fileName:创建的文件名  fileInfo:文件内容
 @result 
 */
- (void)createFile:(NSString *)fileName andFileInfo:(NSString *)fileInfo;

@end

@interface DetailView : UIView
{
    __weak id<DetailViewDelegate>detail_delegate;
}

@property (nonatomic, weak) id<DetailViewDelegate>detail_delegate;

/*!
 @method
 @abstract     根据传过来的值，判断是展示详情还是添加页面
 @discussion
 @param        isShowDetail:判断是否展示详情
 @result
 */
- (void)sentPageIsShowDetail:(BOOL)isShowDetail;

/*!
 @method
 @abstract     将数据传递到View层展示
 @discussion
 @param        fileInfo:需要展示的文件内容
 @result
 */
- (void)sentFileInfo:(NSString *)fileInfo;

/*!
 @method
 @abstract     修改文件内容
 @discussion
 @param        
 @result
 */
- (void)starUpdate;

@end
