//
//  DetailViewController.h
//  TestFolderAndFile
//
//  Created by user on 13-7-28.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
{
    // 当前目录路径
    NSString *m_currentPath;
    // 是否展示Detail详情
    BOOL m_showDetail;
    // 文件名
    NSString *m_fileNameString;
}

@property (nonatomic, strong) NSString *m_currentPath;
@property (nonatomic) BOOL m_showDetail;
@property (nonatomic, strong) NSString *m_fileNameString;

@end
