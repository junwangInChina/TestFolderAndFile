//
//  AudioViewController.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioViewController : UIViewController
{
    // 当前录音文件存储目录路径
    NSString *m_currentDirectorPath;
}

@property (nonatomic, retain) NSString *m_currentDirectorPath;

@end
