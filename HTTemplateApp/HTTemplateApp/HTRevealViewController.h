//
//  HTRevealViewController.h
//  HTTemplateApp
//
//  Created by kazuya on 22/9/12.
//  Copyright (c) 2012 kazuya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTRevealViewController : UIViewController

@property (nonatomic, retain) UIViewController *menuViewController;
@property (nonatomic, retain) UIViewController *contentViewController;
@property (nonatomic, retain) UIViewController *customMenuViewController;

- (id)initWithMenuViewController:(UIViewController *)menuViewController
           contentViewController:(UIViewController *)contentViewController
        customMenuViewController:(UIViewController *)customMenuViewController;

- (void)setMenuVisible:(BOOL)menuVisible wantsFullWidth:(BOOL)wantsFullWidth;
- (void)setCustomMenuVisible:(BOOL)customMenuVisible wantsFullWidth:(BOOL)wantsFullWidth;

@end
