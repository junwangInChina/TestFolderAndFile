//
//  GidViewDataSource.h
//  TestFolderAndFile
//
//  Created by user on 13-8-5.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KTPhotoBrowserDataSource.h"

@interface GidViewDataSource : NSObject<KTPhotoBrowserDataSource>
{
    NSArray *m_gidViewImageArray;
}

@property (nonatomic, retain) NSArray *m_gidViewImageArray;

/*!
 @method
 @abstract     实例化方法
 @discussion
 @param        value:需要获取Image的数组
 @result
 */
- (id)initWithArr:(NSArray *)value;

@end
