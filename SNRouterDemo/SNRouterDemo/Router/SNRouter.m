//
//  SNRouter.m
//  SNFramework
//
//  Created by AsnailNeo on 17/1/5.
//  Copyright © 2017年 Qdaily. All rights reserved.
//

#import "SNRouter.h"
#import <objc/runtime.h>
#import "NSURL+QDParams.h"
#import "NSString+QDURLParams.h"

@interface RouterNode : NSObject

@property (nonatomic, strong) Class viewControllerClass;
@property (nonatomic, copy) NSArray* params;

@end

@implementation RouterNode
@end

static NSMutableDictionary<NSString *, RouterNode *> *RouterMap;

/// register router node into router map.
void RouterRegister(Class class, NSString *params, ...);
void RouterRegister(Class class, NSString *params, ...) {
    NSCAssert([NSThread currentThread] == [NSThread mainThread], @"force register in main thread!");
    if (class == nil || !class_conformsToProtocol(class, @protocol(QDeepLinkProtocol))) {
        return;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        RouterMap = [NSMutableDictionary dictionary];
    });
    
    NSString* routerName = params;
    NSMutableArray *paramArray = [NSMutableArray array];
    va_list args;
    va_start(args, params);
    {
        NSString* arg;
        while ((arg = va_arg(args, NSString *))) {
            [paramArray addObject:arg];
        }
    }
    va_end(args);
    
    RouterNode* router = [[RouterNode alloc] init];
    router.params = paramArray;
    router.viewControllerClass = class;
    
    [RouterMap setObject:router forKey:routerName];
}

@interface SNRouter ()

@property (nonatomic, strong) NSMutableSet *hosts;
@property (nonatomic, strong) NSMutableSet *schemes;
@property (nonatomic, weak) UINavigationController *defaultNavigationController;
@property (nonatomic, copy) SNRouterFail routerFailBlock;

@end

@implementation SNRouter

+ (id)defaultRouter {
    static dispatch_once_t onceToken;
    static SNRouter *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] _init];
    });
    return instance;
}

- (instancetype)_init {
    if (self = [super init]) {
        _schemes = [NSMutableSet new];
        _hosts = [NSMutableSet new];
    }
    return self;
}

- (SNRouter *)addScheme:(NSString *)scheme, ... {
    if (scheme) {
        [_schemes addObject:[scheme lowercaseString]];
        va_list args;
        va_start(args, scheme);
        NSString *eachScheme;
        while ((eachScheme = va_arg(args, NSString *))) {
            [_schemes addObject:[eachScheme lowercaseString]];
        }
        va_end(args);
    }
    return self;
}

- (SNRouter *)addHost:(NSString *)host, ... {
    if (host) {
        [_hosts addObject:[host lowercaseString]];
        va_list args;
        va_start(args, host);
        NSString *eachHost;
        while ((eachHost = va_arg(args, NSString *))) {
            [_hosts addObject:[eachHost lowercaseString]];
        }
        va_end(args);
    }
    return self;
}

- (SNRouter *)setDefaultNavigation:(UINavigationController *)navigationController {
    self.defaultNavigationController = navigationController;
    return self;
}

- (SNRouter *)setRouteFailBlock:(SNRouterFail)fail {
    self.routerFailBlock = fail;
    return self;
}

#pragma mark jump!

- (BOOL)traceSuccessWithDeeplinkURL:(NSURL *)deeplinkURL
                         routerType:(SNRouterType)type
                         controller:(nullable UIViewController *)controller {
    if (deeplinkURL) {
        NSString* scheme = deeplinkURL.scheme;
        NSString* host = deeplinkURL.host;
        NSString* routeName = deeplinkURL.qd_firstPath;
        BOOL result = NO;
        if ([self.schemes containsObject:[scheme lowercaseString]] && [self.hosts containsObject:[host lowercaseString]]) {
            result = [self traceSuccessWithRouterName:routeName paramas:deeplinkURL.qd_parameters routerType:type controller:controller];
        }
        if (!result && self.routerFailBlock) {
            result = self.routerFailBlock(deeplinkURL, controller, NO);
        }
        return result;
    }
    return NO;
}

//this method does not check the validity of scheme and host.
- (BOOL)traceSuccessWithRouterName:(NSString *)routerName
                           paramas:(NSDictionary *)paramas
                        routerType:(SNRouterType)type
                        controller:(nullable UIViewController *)controller {
    if (routerName) {
        BOOL result = NO;
        if (type == SNRouterTypeModal) {
            result = [self presentWithRouterName:routerName params:paramas viewcontroller:controller];
        }else {
            result = [self pushWithRouterName:routerName params:paramas navigationController:(UINavigationController *)controller];
        }
        return result;
    }
    return NO;
}

- (BOOL)pushWithRouterName:(NSString*)routerName params:(NSDictionary*)params navigationController:(UINavigationController*) navigationController {
    
    if (navigationController && ![navigationController isKindOfClass:[UINavigationController class]]) {
        NSLog(@"Invalid controller class (%@)! Must be UINavigationController when push.", [navigationController class]);
        return NO;
    }
    
    if (!navigationController) {
        navigationController = self.defaultNavigationController;
    }
    
    UIViewController* newVC = [self viewControllerWithRouterName:routerName params:params];
    if (newVC && navigationController) {
        [navigationController pushViewController:newVC animated:YES];
        return YES;
    }
    return NO;
}

- (BOOL)presentWithRouterName:(NSString*)routerName params:(NSDictionary*)params viewcontroller:(UIViewController*) viewController {
    if (!viewController) {
        viewController = self.defaultNavigationController;
    }
    UIViewController* newVC = [self viewControllerWithRouterName:routerName params:params];
    if (newVC && viewController) {
        [viewController presentViewController:newVC animated:YES completion:nil];
        return YES;
    }
    return NO;
}

#pragma mark - access to view controller

- (UIViewController*)viewControllerWithURLStr:(NSString*)urlString {
    return [self viewControllerWithDeeplinkURL:[NSURL URLWithString:urlString]];
}

- (UIViewController*)viewControllerWithDeeplinkURL:(NSURL*)url {
    if (url) {
        NSString* scheme = url.scheme;
        NSString* host = url.host;
        NSString* routeName = url.qd_firstPath;
        if ([self.schemes containsObject:[scheme lowercaseString]] && [self.hosts containsObject:[host lowercaseString]]) {
            return [self viewControllerWithRouterName:routeName params:url.qd_parameters];
        }
    }
    return nil;
}

- (UIViewController*)viewControllerWithRouterName:(NSString*)routerName params:(NSDictionary*)params {
    if (routerName) {
        RouterNode* router = RouterMap[routerName];
        if (router != nil) {
            for (NSString* key in router.params) {
                if (params[key] == nil || (![params[key] isKindOfClass:[NSNumber class]] && ![params[key] isKindOfClass:[NSString class]])) {
                    return nil;
                }
            }
            return [[router.viewControllerClass alloc] initWithURLParams:params];
        }
    }
    return nil;
}

@end
