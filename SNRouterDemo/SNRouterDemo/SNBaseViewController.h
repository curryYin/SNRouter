//
//  SNBaseViewController.h
//  SNRouterDemo
//
//  Created by CongXiao Yin on 2017/6/12.
//  Copyright © 2017年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNRouter.h"

@protocol QDeepLinkProtocol;
@interface SNBaseViewController : UIViewController<QDeepLinkProtocol>

@property(nonatomic, copy)NSString *displayString;
- (instancetype)initWithURLParams:(NSDictionary *)params;

@end
