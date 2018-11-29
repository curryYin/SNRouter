//
//  SNBaseViewController.m
//  SNRouterDemo
//
//  Created by CongXiao Yin on 2017/6/12.
//  Copyright © 2017年 Personal. All rights reserved.
//

#import "SNBaseViewController.h"
#import "DemoRouterMap.h"

@implementation SNBaseViewController {
    UILabel *_label;
}

- (instancetype)initWithURLParams:(NSDictionary *)params {
    if (self = [super init]) {
        self.title = params[kVCTitle];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topR = 30;
    UILabel *remind = [[UILabel alloc] initWithFrame:CGRectMake(10, topR, self.view.frame.size.width - 20, 0)];
    remind.text = @"轻触屏幕返回";
    [remind sizeToFit];
    [self.view addSubview:remind];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width - 20, 0)];
    _label.numberOfLines = 0;
    _label.text = self.displayString;
    [_label sizeToFit];
    [self.view addSubview:_label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.presentationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
