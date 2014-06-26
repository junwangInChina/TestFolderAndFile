//
//  ShowViewController.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowViewController : UIViewController
{
    // 需要展示的文件的目录路径
    NSString *m_showFileCurrentDirPath;
    // 需要展示的文件的名称
    NSString *m_showFileName;
}

@property (nonatomic, retain) NSString *m_showFileCurrentDirPath;
@property (nonatomic, retain) NSString *m_showFileName;

@end
