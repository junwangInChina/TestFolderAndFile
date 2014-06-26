//
//  BasciModel.h
//  TestFolderAndFile
//
//  Created by user on 13-7-30.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasciModel : NSObject

// 模型初始化
- (id) initFromDictionary:(NSDictionary*)dic;

// 解析数据来自于字典，子类重写该方法
- (void) parseFromDictionary:(NSDictionary*)dic;

@end
