//
//  SATableViewController.m
//  SNRouterDemo
//
//  Created by CongXiao Yin on 2017/6/12.
//  Copyright © 2017年 Personal. All rights reserved.
//

#import "SATableViewController.h"
#import "NSURL+QDParams.h"
#import "SNRouter.h"
#import "DemoRouterMap.h"

@interface DesViewControllerItem : NSObject
@property(nonatomic, copy)NSString *title;
@property(nonatomic, strong)NSURL *deeplink;
+ (instancetype)desViewControllerWithTiele:(NSString *)title deeplinkURL:(NSURL *)deeplink;
@end

@implementation DesViewControllerItem
+ (instancetype)desViewControllerWithTiele:(NSString *)title deeplinkURL:(NSURL *)deeplink {
    DesViewControllerItem *item = [DesViewControllerItem new];
    item.title = title.copy;
    item.deeplink = deeplink;
    return item;
}
@end

@interface SATableViewController ()

@end

static NSString * const reuseID = @"demoCell";

@implementation SATableViewController {
    NSMutableArray <DesViewControllerItem *> *_dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseID];
    
    //实际项目中可以搞一个专门的类,根据业务逻辑生成相应的url
    NSString *schemeAndHost = [NSString stringWithFormat:@"%@%@",kRScheme, kRHost];
    
    NSString *detailUrl = [[schemeAndHost stringByAppendingString:@"/"] stringByAppendingString:kDetailRouterName];
    NSURL *detaiDeeplink = [NSURL URLWithString:detailUrl queryParameters:@{kParame_Detail_Id : @12 , kParame_Detail_Desctrption: @"nice article by snail~"}];
    DesViewControllerItem *detail = [DesViewControllerItem desViewControllerWithTiele:kDetailRouterName deeplinkURL:detaiDeeplink];
    
    NSString *peopleUrl = [[schemeAndHost stringByAppendingString:@"/"] stringByAppendingString:kPeoplesRouterName];
    NSURL *peoplesDl = [NSURL URLWithString:peopleUrl queryParameters:@{kParame_Peoples_Count : @100}];
    DesViewControllerItem *peoples = [DesViewControllerItem desViewControllerWithTiele:kPeoplesRouterName deeplinkURL:peoplesDl];
    
    [_dataSource addObject:detail];
    [_dataSource addObject:peoples];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DesViewControllerItem *item = _dataSource[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    cell.textLabel.text = item.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DesViewControllerItem *item = _dataSource[indexPath.row];
    [[SNRouter defaultRouter] traceSuccessWithDeeplinkURL:item.deeplink routerType:indexPath.row == 0 ? SNRouterTypePush : SNRouterTypeModal controller:nil];
}

@end
