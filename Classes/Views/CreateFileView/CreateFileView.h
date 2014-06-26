//
//  CreateFileView.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateFileViewDelegate <NSObject>

/*!
 @method
 @abstract     用户选择创建什么文件
 @discussion
 @param        index:根据index可以获取到用户选择的哪种方式
 @result
 */
- (void)userChooseCreate:(int)index;

@end

@interface CreateFileView : UIView
{
    id <CreateFileViewDelegate>createFile_delegate;
}

@property (nonatomic, assign) id <CreateFileViewDelegate>createFile_delegate;

@end
