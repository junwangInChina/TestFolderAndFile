//
//  AppDelegate.m
//  TestFolderAndFile
//
//  Created by user on 13-7-26.
//  Copyright (c) 2013年 user. All rights reserved.
//

#import "AppDelegate.h"
#import "AppContextManagement.h"

@implementation AppDelegate
@synthesize window = _window;
@synthesize mainCon = _mainCon;
@synthesize mongooseDaemon = _mongooseDaemon;

- (void)dealloc
{
    self.window = nil;
    self.mainCon = nil;
    [self.mongooseDaemon stopMongooseDaemon];
    self.mongooseDaemon = nil;

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[AppContextManagement shareInstance] setGlobal_isAlreadyCopy:NO];
    [[AppContextManagement shareInstance] setGlobal_showView:@"0"];
    
    self.mongooseDaemon = [[MongooseDaemon alloc] init];
    [self.mongooseDaemon startMongooseDaemon:@"8800"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.mainCon = [[MainViewController alloc] init];
    [self.mainCon setM_currentDirectoryPath:[CommonDeal getHomePath]];
    [self.mainCon setTitle:@"Home"];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:self.mainCon];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
