//
//  RotatableViewController.m
//  Calculator
//
//  Created by Robert Cole on 7/25/12.
//  Copyright (c) 2012 The Shopper. All rights reserved.
//

#import "RotatableViewController.h"
#import "SplitViewBarButtonPresenter.h"

@interface RotatableViewController ()

@property (nonatomic, readonly) id <SplitViewBarButtonPresenter> splitViewBarButtonPresenter;

@end

@implementation RotatableViewController

@synthesize splitViewBarButtonPresenter = _splitViewBarButtonPresenter;

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Mangement

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.splitViewController.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - UISplitViewDelegate methods

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    BOOL rotate = NO;
    
    if (self.splitViewController) {
        rotate = UIInterfaceOrientationIsPortrait(orientation);
    }
    
    return rotate;
}

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSLog(@"%s", __FUNCTION__);
    self.splitViewBarButtonPresenter.splitViewBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    barButtonItem.title = self.title;
    NSLog(@"%s", __FUNCTION__);
    self.splitViewBarButtonPresenter.splitViewBarButtonItem = barButtonItem;
}

#pragma mark -

- (id <SplitViewBarButtonPresenter>)splitViewBarButtonPresenter {
    id <SplitViewBarButtonPresenter> detailViewController = [self.splitViewController.viewControllers lastObject];
    
    if (![detailViewController conformsToProtocol:@protocol(SplitViewBarButtonPresenter)]) {
        detailViewController = nil;
    }
    
    return detailViewController;
}

@end
