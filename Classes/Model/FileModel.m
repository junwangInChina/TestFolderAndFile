//
//  FileModel.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "FileModel.h"

@implementation FileModel
@synthesize m_fileName;
@synthesize m_filePath;
@synthesize m_fileCreateDate;
@synthesize m_fileSizer;
@synthesize m_fileType;
@synthesize m_fileImageName;
@synthesize m_fileSortDate;
@synthesize m_fileIsChoose;
@synthesize m_downLoadURL;
@synthesize m_downLoadFileName;
@synthesize m_downSaveDirPath;
@synthesize m_downLoadSize;
@synthesize m_downLoadProgress;

- (id)init
{
    if (self = [super init])
    {
        self.m_fileName = @"";
        self.m_filePath = @"";
        self.m_fileCreateDate = @"";
        self.m_fileSizer = @"";
        self.m_fileType = @"";
        self.m_fileImageName = @"";
        self.m_fileSortDate = @"";
        self.m_fileIsChoose = @"0";
        self.m_downLoadFileName = @"";
        self.m_downLoadURL = @"";
        self.m_downSaveDirPath = @"";
        self.m_downLoadSize = 0.0;
        self.m_downLoadProgress = 0.0;
    }
    return self;
}

- (void)dealloc
{
    self.m_fileName = nil;
    self.m_filePath = nil;
    self.m_fileCreateDate = nil;
    self.m_fileSizer = nil;
    self.m_fileType = nil;
    self.m_fileImageName = nil;
    self.m_fileSortDate = nil;
    self.m_fileIsChoose = nil;
    self.m_downLoadFileName = nil;
    self.m_downLoadURL = nil;
    self.m_downSaveDirPath = nil;
    
    [super dealloc];
}

@end
