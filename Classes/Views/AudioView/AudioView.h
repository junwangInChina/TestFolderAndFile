//
//  AudioView.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AudioViewDelegate <NSObject>

/*!
 @method
 @abstract     音频录制保存成功，准备返回前页面
 @discussion
 @param        
 @result
 */
- (void)saveFinishWillBack;

@end

@interface AudioView : UIView
{
    id<AudioViewDelegate>audio_delegate;
}

@property (nonatomic, assign) id<AudioViewDelegate>audio_delegate;

/*!
 @method
 @abstract     初始化录音器
 @discussion
 @param        currentPath:录音文件存放的根目录
 @result
 */
- (void)initializeRecorder:(NSString *)currentPath;

@end
