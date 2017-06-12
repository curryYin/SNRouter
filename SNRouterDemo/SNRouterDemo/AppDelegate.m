//
//  AppDelegate.m
//  SNRouterDemo
//
//  Created by CongXiao Yin on 2017/6/9.
//  Copyright © 2017年 Qdaily. All rights reserved.
//

#import "AppDelegate.h"
#import "SNRouter.h"
#import "DemoRouterMap.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //将所有 router 节点注册进router map
    [[[[[SNRouter defaultRouter] addScheme:@"router", nil]
                                addHost:kRHost, nil]
                                setDefaultNavigation:(UINavigationController *)self.window.rootViewController]
                                setRouteFailBlock:^BOOL(NSURL * _Nonnull url, UIViewController * _Nonnull viewController, BOOL isPresent) {
        return NO;
    }];
    return YES;
}

@end
