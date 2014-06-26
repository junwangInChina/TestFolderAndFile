//
//  KTThumbsViewController.h
//  KTPhotoBrowser
//
//  Created by Kirby Turner on 2/3/10.
//  Copyright 2010 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTPhotoBrowserDataSource.h"
#import "KTThumbsView.h"

@class KTThumbsView;

@protocol KTThumbsViewControllerDelegate <NSObject>

/*!
 @method
 @abstract     编辑文件/文件夹  文件的重命名、复制、剪切等操作
 @discussion
 @param        fileName:需要修改名称的文件夹名
 @result
 */
- (void)editFileWithName:(NSString *)fileName;

/*!
 @method
 @abstract     进入下一个页面
 @discussion
 @param        fileName:选中文件的名称
 @result
 */
- (void)toNextPageWithName:(NSString *)fileName;

/*!
 @method
 @abstract     多选删除时，将选中/取消选中的信息传递到Controller层
 @discussion
 @param        choosed:是否选中  fileName:当前操作的文件名
 @result
 */
- (void)moreDeleteWhenChooseOrFail:(BOOL)choosed andFileName:(NSString *)fileName;
@end

@interface KTThumbsViewController : UIViewController <KTThumbsViewDataSource>
{
    NSMutableArray *m_fileModelArray;
    BOOL m_gidIsEditing;
    
    id<KTThumbsViewControllerDelegate>ktt_delegate;
    
@private
   id <KTPhotoBrowserDataSource> dataSource_;
   KTThumbsView *scrollView_;
   BOOL viewDidAppearOnce_;
   BOOL navbarWasTranslucent_;
}

@property (nonatomic, assign) id <KTPhotoBrowserDataSource> dataSource;
@property (nonatomic, assign) id<KTThumbsViewControllerDelegate>ktt_delegate;
@property (nonatomic, retain) NSMutableArray *m_fileModelArray;
@property (nonatomic) BOOL m_gidIsEditing;

/**
 * Re-displays the thumbnail images.
 */
- (void)reloadThumbs;

/**
 * Called before the thumbnail images are loaded and displayed.
 * Override this method to prepare. For instance, display an
 * activity indicator.
 */
- (void)willLoadThumbs;

/**
 * Called immediately after the thumbnail images are loaded and displayed.
 */
- (void)didLoadThumbs;

/**
 * Used internally. Called when the thumbnail is touched by the user.
 */
- (void)didSelectThumbAtIndex:(NSUInteger)index;

/**
 * 点击跳到下一页，或点击头像弹出编辑的ActionSheet 
 * 0:表示进入下一页
 * 1:表示弹出编辑的ActionSheet
 * 2:选中删除
 * isChoosed:表示选中或取消选中
 */
- (void)didSelectThumbAtIndex:(NSUInteger)index AndPressWhitchBtn:(NSUInteger)btnIndex andChoosed:(BOOL)isChoosed;

@end
