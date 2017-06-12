//
//  PeoplesViewController.m
//  SNRouterDemo
//
//  Created by CongXiao Yin on 2017/6/12.
//  Copyright © 2017年 Personal. All rights reserved.
//

#import "PeoplesViewController.h"
#import "SNRouter.h"
#import "DemoRouterMap.h"

@implementation PeoplesViewController

ROUTER_REGISTER(kPeoplesRouterName, kParame_Peoples_Count)

- (instancetype)initWithURLParams:(NSDictionary *)params {
    if (self = [super initWithURLParams:params]) {
        self.displayString = [NSString stringWithFormat:@"article count is %@",params[kParame_Peoples_Count]];
    }
    return self;
}

@end
