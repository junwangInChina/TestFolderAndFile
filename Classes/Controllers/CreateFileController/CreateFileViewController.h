//
//  CreateFileViewController.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateFileViewController : UIViewController
{
    // 当前目录的路径
    NSString *m_currentDicPath;
}

@property (nonatomic, retain) NSString *m_currentDicPath;

@end
