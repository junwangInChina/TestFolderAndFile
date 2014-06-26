//
//  ShowImageView.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageView : UIView

/*!
 @method
 @abstract     传递图片的路径，用于展示
 @discussion
 @param        imagePath:用于展示图片
 @result
 */
- (void)sentImagePath:(NSString *)imagePath;

@end
