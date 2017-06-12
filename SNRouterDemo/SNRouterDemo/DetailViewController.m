//
//  DetailViewController.m
//  SNRouterDemo
//
//  Created by CongXiao Yin on 2017/6/12.
//  Copyright © 2017年 Personal. All rights reserved.
//

#import "DetailViewController.h"
#import "DemoRouterMap.h"

//view controller 想要实现隐式跳转必须遵守<QDeepLinkProtocol>协议,实现协议方法
@implementation DetailViewController

//注册router name以及必传参数
ROUTER_REGISTER(kDetailRouterName, kParame_Detail_Id);

- (instancetype)initWithURLParams:(NSDictionary *)params {
    if (self = [super initWithURLParams:params]) {
        self.displayString = [NSString stringWithFormat:@"article id is %@, discription is %@",params[kParame_Detail_Id], params[kParame_Detail_Desctrption]];
    }
    return self;
}

@end
