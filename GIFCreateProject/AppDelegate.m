//
//  AppDelegate.m
//  GIFCreateProject
//
//  Created by lsy on 16/7/26.
//  Copyright © 2016年 lsy. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoChooseViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    PhotoChooseViewController *controller = [[PhotoChooseViewController alloc] init];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
