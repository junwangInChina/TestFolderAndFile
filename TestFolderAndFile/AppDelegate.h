//
//  AppDelegate.h
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "MongooseDaemon.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainCon;

@property (strong, nonatomic) MongooseDaemon *mongooseDaemon;

@end
