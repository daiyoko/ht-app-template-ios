//
//  HTAppDelegate.m
//  HTTemplateApp
//
//  Created by kazuya on 22/9/12.
//  Copyright (c) 2012 kazuya. All rights reserved.
//

#import "HTAppDelegate.h"

@interface HTAppDelegate ()
@property (nonatomic, strong) HTRevealViewController *reveal;
@property (nonatomic, strong) HTRootMenuViewController *menu;
@property (nonatomic, strong) HTCustomMenuViewController *customMenu;
@end

@implementation HTAppDelegate

@synthesize window = _window;
@synthesize reveal = _reveal;
@synthesize menu;
@synthesize customMenu;

- (void)configureAppearance
{
    
}

- (HTRootMenuViewController *)loadMenu
{
    HTRootMenuViewController *menuController = [[HTRootMenuViewController alloc] initWithNibName:nil bundle:nil];
    
    return menuController;
}

- (HTCustomMenuViewController *)loadCustomMenu
{
    HTCustomMenuViewController *customMenuController = [[HTCustomMenuViewController alloc] initWithNibName:nil bundle:nil];
    
    return customMenuController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self configureAppearance];
    
    self.menu = [self loadMenu];
    self.customMenu = [self loadCustomMenu];
    
    UIViewController *defaultViewController = [[UIViewController alloc] init];
    
    self.reveal = [[HTRevealViewController alloc] initWithMenuViewController:self.menu contentViewController:defaultViewController customMenuViewController:self.customMenu];
    self.window.rootViewController = self.reveal;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
