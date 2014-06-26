//
//  AppContextManagement.h
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContextManagement : NSObject
{
    // 表示当前是否已经有文件或文件夹被复制
    BOOL global_isAlreadyCopy;
    
    // 表示当前选择复制还是剪切
    BOOL global_isChooseCopy;
    
    // 表示当前显示的是那一钟页面 0表示表格，1表示九宫格
    NSString *global_showView;
    // 表示当前Copy的文件/文件夹的目录路径
    NSString *global_copyFileDirePath;
    // 表示当前Copy的文件/文件夹的名称
    NSString *global_copyFileName;
}

@property (nonatomic) BOOL global_isAlreadyCopy;
@property (nonatomic) BOOL global_isChooseCopy;
@property (nonatomic, retain) NSString *global_showView;
@property (nonatomic, retain) NSString *global_copyFileDirePath;
@property (nonatomic, retain) NSString *global_copyFileName;
// 单利模式创建AppContextManagement
+ (AppContextManagement *)shareInstance;

@end
