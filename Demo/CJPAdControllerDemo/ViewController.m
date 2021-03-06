//
//  ViewController.m
//  CJPAdControllerDemo
//
//  Created by Chris Phillips on 06/02/2015.
//  Copyright (c) 2015 Midnight Labs. All rights reserved.
//

#import "ViewController.h"
#import "AnotherViewController.h"
#import "CJPAdController.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

- (void)anotherExample;
- (void)removeAdsPermanently;
- (void)removeAdsTemporarily;
- (void)restoreAds;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"CJPAdController Demo";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Let's put everything in a ScrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_scrollView];
    
    // TextView describing basic functionality
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 220)];
    textView.text = @"After a couple of seconds you should see ads appear at the bottom of this view.\nYou can rotate your device any way you want; the ad will automatically resize and/or reposition itself.\n\nTap the button below to push another view. You'll notice the ad remains in position across views as advised by Apple.";
    textView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.font = [UIFont systemFontOfSize:16.0];
    textView.textColor = [UIColor darkTextColor];
    [_scrollView addSubview:textView];
    CGRect textFrame = textView.frame;
    textFrame.size.height = textView.contentSize.height;
    textView.frame = textFrame;
    
    // Button to push another view
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, textView.frame.size.height+10, 200, 40);
    button.center = CGPointMake(self.view.frame.size.width/2, button.center.y);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button setTitle:@"Push Another View" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(anotherExample) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:button];
    if ([self.parentViewController.parentViewController isKindOfClass:[UITabBarController class]]) button.hidden = YES;
    
    // Button to remove ads temporarily
    UIButton *buttonRAT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonRAT.frame = CGRectMake(0, button.frame.origin.y+button.frame.size.height+10, 200, 40);
    buttonRAT.center = CGPointMake(self.view.frame.size.width/2, buttonRAT.center.y);
    buttonRAT.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [buttonRAT setTitle:@"Remove Ads Temporarily" forState:UIControlStateNormal];
    [buttonRAT addTarget:self action:@selector(removeAdsTemporarily) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buttonRAT];
    
    // Button to remove ads permanently
    UIButton *buttonRAP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonRAP.frame = CGRectMake(0, buttonRAT.frame.origin.y+buttonRAT.frame.size.height+10, 200, 40);
    buttonRAP.center = CGPointMake(self.view.frame.size.width/2, buttonRAP.center.y);
    buttonRAP.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [buttonRAP setTitle:@"Remove Ads Permanently" forState:UIControlStateNormal];
    [buttonRAP addTarget:self action:@selector(removeAdsPermanently) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buttonRAP];
    
    // Button to restore ad
    UIButton *buttonRestore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonRestore.frame = CGRectMake(0, buttonRAP.frame.origin.y+buttonRAP.frame.size.height+10, 200, 40);
    buttonRestore.center = CGPointMake(self.view.frame.size.width/2, buttonRestore.center.y);
    buttonRestore.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [buttonRestore setTitle:@"Restore Ads" forState:UIControlStateNormal];
    [buttonRestore addTarget:self action:@selector(restoreAds) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:buttonRestore];
    
    // Set scrollview content size
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, buttonRestore.frame.size.height+buttonRestore.frame.origin.y+10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)anotherExample
{
    AnotherViewController *anotherView = [[AnotherViewController alloc] init];
    [self.navigationController pushViewController:anotherView animated:YES];
}

- (void)removeAdsPermanently
{
    // In production, you might call this when someone makes an IAP to remove ads for example. In such a case, you'll want to set andRemember to NO so that it is remembered across future app launches.
    [[CJPAdController sharedInstance] removeAdsAndMakePermanent:YES andRemember:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ads Removed" message:@"Ads will NOT show again until restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)removeAdsTemporarily
{
    [[CJPAdController sharedInstance] removeAds];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ads Removed" message:@"Ads will be hidden off-screen until the next ad request fires (usually within 1-5 minutes)." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)restoreAds
{
    // NOTE: restoreBanner's parameter can be left blank - if you're using multiple ad networks and have presumably removed any and all instances from your view before calling this, this will then create a new banner of your default ad type.
    [[CJPAdController sharedInstance] restartAds];
}

@end
