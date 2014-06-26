//
//  AppContextManagement.m
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AppContextManagement.h"

static AppContextManagement *global_contextManagement = nil;

@interface AppContextManagement()

@end

@implementation AppContextManagement
@synthesize global_isAlreadyCopy;
@synthesize global_isChooseCopy;
@synthesize global_copyFileDirePath;
@synthesize global_copyFileName;
@synthesize global_showView;

- (void)dealloc
{
    self.global_copyFileDirePath = nil;
    self.global_copyFileName = nil;
    self.global_showView = nil;
    
    [super dealloc];
}

+ (AppContextManagement *)shareInstance
{
    @synchronized(self)
    {
        if (!global_contextManagement)
        {
            global_contextManagement = [[AppContextManagement alloc] init];
        }
    }
    return global_contextManagement;
}

@end
