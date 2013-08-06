//
//  FSDetailsViewController.m
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-5.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import "FSDetailsViewController.h"
#import "FSNavigationController.h"

@interface FSDetailsViewController ()

@end

@implementation FSDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)popBack
{
    FSNavigationController *navCV = (FSNavigationController*)self.navigationController;
    [navCV popViewControllerWithSlideAnimation];
}

@end
