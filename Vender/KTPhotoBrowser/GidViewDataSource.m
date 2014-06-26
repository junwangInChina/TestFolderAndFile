//
//  GidViewDataSource.m
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "GidViewDataSource.h"
#import "FileModel.h"

@implementation GidViewDataSource
@synthesize m_gidViewImageArray;

- (void)dealloc
{
    self.m_gidViewImageArray = nil;
    
    [super dealloc];
}

- (id)initWithArr:(NSArray *)value
{
    self = [super init];
    if (self)
    {
        [self getProductImage:value];
    }
    return self;
}

- (void)getProductImage:(NSArray *)arr
{
    NSString *filePath = nil;
    FileModel *model = nil;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < [arr count]; i ++)
    {
        model = [arr objectAtIndex:i];
        filePath = [model.m_filePath stringByAppendingPathComponent:model.m_fileName];
        // 如果是文件夹
        if ([CommonDeal chectIsFolder:filePath])
        {
            [array addObject:@"folder.png"];
        }
        // 是文件
        else
        {
            [array addObject:model.m_fileImageName];
        }
    }
    
    self.m_gidViewImageArray = [NSArray arrayWithArray:array];
    
    [array release];
}


- (NSInteger)numberOfPhotos
{
    NSInteger count = [m_gidViewImageArray count];
    return count;
}

- (UIImage *)imageAtIndex:(NSInteger)index
{
    NSString *url = [m_gidViewImageArray objectAtIndex:index];
    
    return [self imageWithURLString:url];
}

- (UIImage *)thumbImageAtIndex:(NSInteger)index
{
    NSString *url = [m_gidViewImageArray objectAtIndex:index];
    
    return [self imageWithURLString:url];
}

- (UIImage *)imageWithURLString:(NSString *)string
{
    UIImage *image = [UIImage imageNamed:string];
    return image;
}

@end
