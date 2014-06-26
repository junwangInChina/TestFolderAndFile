//
//  BasciModel.m
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "BasciModel.h"

@implementation BasciModel

- (id)initFromDictionary:(NSDictionary *)dic
{
	self = [super init];
	
	if (nil != dic) {
		// 将字典的数据转化为模型的数据
		[self parseFromDictionary:dic];
	}
	
	return self;
}

- (void)parseFromDictionary:(NSDictionary *)dic
{
	
}

@end
