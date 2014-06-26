//
//  MainViewController.h
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    // 当前页面的目录的路径
    NSString *m_currentDirectoryPath;
}

@property (nonatomic, strong) NSString *m_currentDirectoryPath;

@end
