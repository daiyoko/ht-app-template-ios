//
//  HTRevealViewController.m
//  HTTemplateApp
//
//  Created by kazuya on 22/9/12.
//  Copyright (c) 2012 kazuya. All rights reserved.
//

#import "HTRevealViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface HTRevealViewController ()
@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIView *contentShieldView;
@end

@implementation HTRevealViewController

@synthesize menuViewController = _menuViewController;
@synthesize contentViewController = _contentViewController;
@synthesize contentContainerView = _contentContainerView;
@synthesize contentShieldView = _contentShieldView;
@synthesize customMenuViewController = _customMenuViewController;

- (id)initWithMenuViewController:(UIViewController *)menuViewController contentViewController:(UIViewController *)contentViewController customMenuViewController:(UIViewController *)customMenuViewController
{
    self = [super initWithNibName:nil bundle:nil];
    
    if(self)
    {
        self.menuViewController = menuViewController;
        self.customMenuViewController = customMenuViewController;
        self.contentViewController = contentViewController;
    }
    
    return self;
}

- (CGFloat)menuWidth
{
    return 265;
}

- (CGFloat)customMenuWidth
{
    return 265;
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    _menuViewController = menuViewController;
    
    [self addChildViewController:menuViewController];
    
    UIView *menuView = self.menuViewController.view;
    CGRect bounds = self.view.bounds;
    bounds.size.width = [self menuWidth];
    menuView.frame = bounds;
    menuView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
    [self.view addSubview:menuView];
    
    [menuViewController didMoveToParentViewController:self];
}

- (void)setContentViewController:(UIViewController *)contentViewController
{
    UIView *oldContentView = self.contentViewController.view;
    [oldContentView removeFromSuperview];
    
    _contentViewController = contentViewController;
    
    [self addChildViewController:contentViewController];
    
    if(self.view)
    {
        UIView *contentView = contentViewController.view;
        contentView.frame = (oldContentView?oldContentView.frame:self.view.bounds);
        contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.contentContainerView addSubview:contentView];
    }
    
    [contentViewController didMoveToParentViewController:self];
    
    [self.view bringSubviewToFront:self.contentContainerView];
    [self.contentContainerView bringSubviewToFront:self.contentShieldView];
}

- (void)setCustomMenuViewController:(UIViewController *)customMenuViewController
{
    _customMenuViewController = customMenuViewController;
    
    [self addChildViewController:customMenuViewController];
    
    UIView *customMenuView = self.customMenuViewController.view;
    CGRect bounds = self.view.bounds;
    bounds.size.width = [self customMenuWidth];
    customMenuView.frame = bounds;
    customMenuView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:customMenuView];
    
    [customMenuViewController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *container = [[UIView alloc] initWithFrame:self.view.bounds];
    
    CALayer *layer = container.layer;
    layer.shadowOffset = CGSizeMake(0, 0);
    layer.shadowOpacity = 0.5;
    layer.shadowRadius = 5.0;
    
    CGPathRef path = CGPathCreateWithRect(layer.bounds, NULL);
    layer.shadowPath = path;
    CGPathRelease(path);
    
    container.backgroundColor = [UIColor whiteColor];
    container.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:container];
    self.contentContainerView = container;
    
    UIView *shield = [[UIView alloc] initWithFrame:container.bounds];
    shield.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu:)];
    [shield addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [shield addGestureRecognizer:swipe];
    
    [shield setHidden:YES];
    [container addSubview:shield];
    self.contentShieldView = shield;
}

- (void)dismissMenu:(UITapGestureRecognizer *)gesture
{
    [self setMenuVisible:NO wantsFullWidth:NO];
}

- (void)setMenuVisible:(BOOL)menuVisible wantsFullWidth:(BOOL)wantsFullWidth
{
    [UIView beginAnimations:@"ShowMenu" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect contentFrame = self.contentContainerView.frame;
    CGRect menuFrame = self.menuViewController.view.frame;
    CGRect customMenuFrame = self.customMenuViewController.view.frame;
    
    [self.customMenuViewController viewWillDisappear:YES];
    
    if(menuVisible)
    {
        [self.contentContainerView setHidden:NO];
        
        if(wantsFullWidth)
        {
            contentFrame.origin.x = self.view.bounds.size.width;
            self.contentContainerView.layer.shadowOpacity = 0.0;
            menuFrame.size.width = self.view.bounds.size.width;
        }
        else
        {
            contentFrame.origin.x = [self menuWidth];
            menuFrame.size.width = [self menuWidth];
            self.contentContainerView.layer.shadowOpacity = 0.5;
        }
        
        [self.menuViewController viewWillAppear:YES];
    }
    else
    {
        [self.contentShieldView setHidden:YES];
        
        contentFrame.origin.x = 0;
        [self.menuViewController viewWillDisappear:YES];
        menuFrame.size.width = [self menuWidth];
    }
    
    // TODO:
    //customMenuFrame.origin.x = self.view.bounds.size.width;
    
    self.contentContainerView.frame = contentFrame;
    self.menuViewController.view.frame = menuFrame;
    self.customMenuViewController.view.frame = customMenuFrame;
    
    // TODO:
    if([self.menuViewController respondsToSelector:@selector(searchBar)])
    {
        [[self.menuViewController performSelector:@selector(searchBar)] layoutSubviews];
    }
    
    [UIView commitAnimations];
}

- (void)setCustomMenuVisible:(BOOL)customMenuVisible wantsFullWidth:(BOOL)wantsFullWidth
{
    [UIView beginAnimations:@"ShowCustomMenu" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect contentFrame = self.contentContainerView.frame;
    CGRect customMenuFrame = self.customMenuViewController.view.frame;
    
    if(customMenuVisible)
    {
        [self.contentShieldView setHidden:NO];
        
        if(wantsFullWidth)
        {
            contentFrame.origin.x = -self.view.bounds.size.width;
            self.contentContainerView.layer.shadowOpacity = 0.0;
            customMenuFrame.origin.x = 0;
            customMenuFrame.size.width = self.view.bounds.size.width;
        }
        else
        {
            contentFrame.origin.x = -[self customMenuWidth];
            customMenuFrame.origin.x = self.view.bounds.size.width - [self customMenuWidth];
            customMenuFrame.size.width = [self customMenuWidth];
            self.contentContainerView.layer.shadowOpacity = 0.5;
        }
        
        [self.customMenuViewController viewWillAppear:YES];
    }
    else
    {
        [self.contentShieldView setHidden:YES];
        contentFrame.origin.x = 0;
        [self.customMenuViewController viewWillDisappear:YES];
        customMenuFrame.size.width = [self customMenuWidth];
    }
    
    self.contentContainerView.frame = contentFrame;
    self.customMenuViewController.view.frame = customMenuFrame;
    
    [UIView commitAnimations];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.menuViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.contentViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.customMenuViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.menuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.contentViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.customMenuViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.menuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.contentViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.customMenuViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

// TODO:
/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.contentViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

































