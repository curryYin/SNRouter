//
//  SNRouter.h
//  SNFramework
//
//  Created by AsnailNeo on 17/1/5.
//  Copyright © 2017年 Qdaily. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ROUTER_REGISTER(...) \
UIKIT_EXTERN void RouterRegister(Class, NSString *, ...); \
+ (void)load { RouterRegister(self, ##__VA_ARGS__, nil); }


NS_ASSUME_NONNULL_BEGIN

//each view controller registed in the router map must confrom this protocol.
@protocol QDeepLinkProtocol <NSObject>

- (instancetype)initWithURLParams:(NSDictionary*)params;

@optional

+ (NSArray*) optionParams;

@end

typedef NS_ENUM(NSUInteger, SNRouterType) {
    SNRouterTypePush,//default push
    SNRouterTypeModal,
};

typedef BOOL(^SNRouterFail)(NSURL *url, UIViewController* viewController, BOOL isPresent);

@interface SNRouter : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

/// Get the default Router manager
+ (id)defaultRouter;

//chain pattern
//config scheme, host
- (SNRouter *)addScheme:(NSString*)scheme, ...;
- (SNRouter *)addHost:(NSString*)host, ...;
- (SNRouter *)setDefaultNavigation:(UINavigationController *)navigationController;
- (SNRouter *)setRouteFailBlock:(SNRouterFail)fail;

//jump with deep link url, such as "qdaily://articleDetail?genre=1&id=41777"
//this method will check the validity of scheme and host. and will call failBlock when jump fail
- (BOOL)traceSuccessWithDeeplinkURL:(NSURL *)deeplinkURL
                         routerType:(SNRouterType)type
                         controller:(nullable UIViewController *)controller;

//this method does not check the validity of scheme and host. and not call failBlock when jump fail
- (BOOL)traceSuccessWithRouterName:(NSString *)routerName
                           paramas:(NSDictionary *)paramas
                        routerType:(SNRouterType)type
                        controller:(nullable UIViewController *)controller;

//access to view controller
- (UIViewController*)viewControllerWithURLStr:(NSString*)urlString;
- (UIViewController*)viewControllerWithDeeplinkURL:(NSURL*)url;
- (UIViewController*)viewControllerWithRouterName:(NSString*)routerName params:(NSDictionary*)params;

@end

NS_ASSUME_NONNULL_END
