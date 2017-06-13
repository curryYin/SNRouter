# SNRouter
a router for transition between view controllers 
#### Usage
*  register scheme and host in your appdelegate

```
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[[[[SNRouter defaultRouter] addScheme:@"router", nil]
                                addHost:kRHost, nil]
                                setDefaultNavigation:(UINavigationController *)self.window.rootViewController]
                                setRouteFailBlock:^BOOL(NSURL * _Nonnull url, UIViewController * _Nonnull viewController, BOOL isPresent) {
        return NO;
    }];
    return YES;
}
```

*  config your link url ,and transform to your vc

```
NSURL *url = [NSURL URLWithString:@"router://demo/Peoples?count=100"];
[[SNRouter defaultRouter] traceSuccessWithDeeplinkURL:url routerType:indexPath.row == 0 ? SNRouterTypePush : SNRouterTypeModal controller:nil];
```

*  your view controller must confrom the protocol `<QDeepLinkProtocol>`,and implement the required method `- initWithURLParams:`

```
- (instancetype)initWithURLParams:(NSDictionary *)params {
    if (self = [super initWithURLParams:params]) {
        
    }
    return self;
}
```


