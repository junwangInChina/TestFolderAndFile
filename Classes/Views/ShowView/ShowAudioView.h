//
//  ShowAudioView.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowAudioView : UIView

/*!
 @method
 @abstract     传递音频的路径，用于播放音频
 @discussion
 @param        imagePath:用于展示图片
 @result
 */
- (void)sentAudioPath:(NSString *)audioPath;


@end
