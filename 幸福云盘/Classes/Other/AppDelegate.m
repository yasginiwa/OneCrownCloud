//
//  AppDelegate.m
//  幸福云盘
//
//  Created by YGLEE on 2018/7/10.
//  Copyright © 2018年 YGLEE. All rights reserved.
//

#import "AppDelegate.h"
#import "YGMainTabBarVC.h"
#import "YGMainNavVC.h"
#import "YGLoginVC.h"
#import <Photos/Photos.h>
#import <CoreTelephony/CTCellularData.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //  检查相册权限
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthorStatus) {
        case PHAuthorizationStatusAuthorized:
            YGLog(@"Authorized");
            break;
        case PHAuthorizationStatusDenied:
            YGLog(@"Denied");
            break;
        case PHAuthorizationStatusNotDetermined:
            YGLog(@"not Determined");
            break;
        case PHAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
    
    //  申请相册权限
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            YGLog(@"Authorized");
        }else{
            YGLog(@"Denied or Restricted");
        }
    }];
    

    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 启动界面停留3秒
//    [NSThread sleepForTimeInterval:3.0];

    //  显示登录界面或是文件界面
    [self chooseRootVC];

    return YES;
}

- (void)chooseRootVC
{
    // 创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, scrnW, scrnH)];
    [self.window makeKeyAndVisible];
    
    // 判断token文件是否存在
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:YGTokenPath]) {
        YGMainTabBarVC *tabBarVC = [[YGMainTabBarVC alloc] init];
        self.window.rootViewController = tabBarVC;
    } else {
        YGLoginVC *loginVC = [[YGLoginVC alloc] init];
        YGMainNavVC *navVC = [[YGMainNavVC alloc] initWithRootViewController:loginVC];
        self.window.rootViewController = navVC;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
