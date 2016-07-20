//
//  AppDelegate.m
//  MyWallet
//
//  Created by 美鑫科技 on 16/6/22.
//  Copyright © 2016年 MorpLCP. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "SystemManager.h"
#import "WelcomeViewController.h"
#import "InitViewController.h"
#import "LockView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if ([[SystemManager manager] checkDataBase]) {
        WelcomeViewController *welcomeVC = [WelcomeViewController new];
        self.window.rootViewController = welcomeVC;
    } else{
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Init"] isEqualToString:@"Y"]) {
            IndexViewController *indexVC = [IndexViewController new];
            indexVC.shouldLock = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:indexVC];
            self.window.rootViewController = nav;
        } else{
            InitViewController *initVC = [InitViewController new];
            self.window.rootViewController = initVC;
        }
    }
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Init"] isEqualToString:@"Y"]) {
         [[LockView lock] show];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
