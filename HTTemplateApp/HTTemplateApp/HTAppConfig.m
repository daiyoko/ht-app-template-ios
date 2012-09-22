//
//  HTAppConfig.m
//  HTTemplateApp
//
//  Created by kazuya on 22/9/12.
//  Copyright (c) 2012 kazuya. All rights reserved.
//

#import "HTAppConfig.h"

static HTAppConfig *sharedInstance;

@interface HTAppConfig ()
@property (nonatomic, strong) NSDictionary *config;
@end

@implementation HTAppConfig

@synthesize config;

- (id)init
{
    if((self = [self init]))
    {
        NSString *configPath = [[NSBundle mainBundle] pathForResource:@"AppConfig" ofType:@"plist"];
        NSData *data = [NSData dataWithContentsOfFile:configPath];
        NSPropertyListFormat format;
        NSString *errorDescription;
        NSDictionary *configObject = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&errorDescription];
        
        if(configObject)
        {
            self.config = configObject;
        }
        else
        {
            NSLog(@"Error reading config plist (%@): %@", configPath, errorDescription);
        }
    }
    
    return self;
}

+ (HTAppConfig *)sharedAppConfig
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HTAppConfig alloc] init];
    });
    
    return sharedInstance;
}

- (id)objectForKey:(NSString *)key
{
    id result = [self.config objectForKey:key];
    if(!result)
    {
        [NSException raise:NSGenericException format:@"No value found for config key: %@", key];
    }
    return result;
}

@end

@implementation UIColor (strings)
+ (UIColor *)colorFromRGBHexString:(NSString *)colorString
{
    if(colorString.length == 7)
    {
        const char *colorUTF8String = [colorString UTF8String];
        int r, g, b;
        sscanf(colorUTF8String, "#%2x%2x%2x", &r, &g, &b);
        return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1.0];
    }
    
    return nil;
}

@end





















