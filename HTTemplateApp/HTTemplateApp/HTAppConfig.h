//
//  HTAppConfig.h
//  HTTemplateApp
//
//  Created by kazuya on 22/9/12.
//  Copyright (c) 2012 kazuya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTAppConfig : NSObject
+ (HTAppConfig *)sharedAppConfig;
- (id)objectForKey:(NSString *)key;
@end

@interface UIColor (strings)
+ (UIColor *)colorFromRGBHexString:(NSString *)colorString;
@end