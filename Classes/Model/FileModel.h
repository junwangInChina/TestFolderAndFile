//
//  FileModel.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasciModel.h"

@interface FileModel : BasciModel
{
    NSString *m_fileName;           // 文件名
    NSString *m_filePath;           // 文件所在目录的路径
    NSString *m_fileCreateDate;     // 创建日期
    NSString *m_fileType;           // 文件类型
    NSString *m_fileSizer;          // 文件大小
    NSString *m_fileImageName;      // 文件图标名称
    NSString *m_fileSortDate;       // 用户排序的时间
    NSString *m_fileIsChoose;       // 表示是否被选中 0未选中  1选中
    NSString *m_downLoadURL;        // 下载URL
    NSString *m_downLoadFileName;   // 下载文件名
    NSString *m_downSaveDirPath;    // 下载保存时目录路径
    float m_downLoadSize;           // 下载文件总大小
    float m_downLoadProgress;       // 已下载百分比
}

@property (nonatomic, retain) NSString *m_fileName;
@property (nonatomic, retain) NSString *m_filePath;
@property (nonatomic, retain) NSString *m_fileCreateDate;
@property (nonatomic, retain) NSString *m_fileType;
@property (nonatomic, retain) NSString *m_fileSizer;
@property (nonatomic, retain) NSString *m_fileImageName; 
@property (nonatomic, retain) NSString *m_fileSortDate;
@property (nonatomic, retain) NSString *m_fileIsChoose;
@property (nonatomic, retain) NSString *m_downLoadURL;
@property (nonatomic, retain) NSString *m_downLoadFileName;
@property (nonatomic, retain) NSString *m_downSaveDirPath;
@property (nonatomic) float m_downLoadSize;
@property (nonatomic) float m_downLoadProgress;

@end
