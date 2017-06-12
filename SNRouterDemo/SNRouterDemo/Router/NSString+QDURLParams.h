//
//  NSString+QDURLParams.h
//  SNFrameworkDemo
//
//  Created by AsnailNeo on 2017/2/18.
//  Copyright © 2017年 Qdaily. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QDURLParams)

- (NSURL *)qd_toURL;
- (NSString *)qd_parameterForKey:(NSString *)key;
- (NSDictionary *)qd_parameters;
- (NSString *)qd_url;

@end
