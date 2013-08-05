//
//  FSNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Modified by Zhefu Wang on 13-6-24
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]

#import "FSNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+FSViewController.h"

@interface FSNavigationController ()

@property (nonatomic) CGPoint startTouch;
@property (nonatomic, strong) UIImageView *lastScreenShotView;
@property (nonatomic, strong) UIView *blackMask;

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation FSNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib
{
    self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    self.canDragBack = YES;
}

- (void)dealloc
{
    self.screenShotsList = nil;
    
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, self.view.frame.size.height);
    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                 action:@selector(paningGestureReceive:)];
    recognizer.delegate = self;
    [recognizer delaysTouchesBegan];
    
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// override the push method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.screenShotsList addObject:[self capture]];
    
    [super pushViewController:viewController animated:animated];
}

// override the pop method
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.screenShotsList removeLastObject];
    
    if (self.lastScreenShotView)
        [self.lastScreenShotView removeFromSuperview];

    return [super popViewControllerAnimated:animated];
}

- (NSArray*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    for (int i = [self.viewControllers count]-2; i>0; --i)
    {
        if (self.viewControllers[i] == viewController)
            break;
        [self.screenShotsList removeObjectAtIndex:i];
    }
    
    if (!self.backgroundView)
    {
        CGRect frame = self.view.frame;
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        
        self.blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        self.blackMask.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview:self.blackMask];
    }
    
    self.backgroundView.hidden = NO;
    
    if (self.lastScreenShotView)
        [self.lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    [self.screenShotsList removeLastObject];
    self.lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
    [self.backgroundView insertSubview:self.lastScreenShotView belowSubview:self.blackMask];
    
    [self moveViewWithX:0];
    __block NSArray *cvs;
    [UIView animateWithDuration:0.35 animations:^{
        [self moveViewWithX:320];
    } completion:^(BOOL finished) {
        cvs = [super popToViewController:viewController animated:NO];
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        self.view.frame = frame;
    }];
    return cvs;
}

// custome pop method
- (UIViewController*)popViewControllerWithSlideAnimation
{    
    if (!self.backgroundView)
    {
        CGRect frame = self.view.frame;
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
        
        self.blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
        self.blackMask.backgroundColor = [UIColor blackColor];
        [self.backgroundView addSubview:self.blackMask];
    }
    
    self.backgroundView.hidden = NO;
    
    if (self.lastScreenShotView)
        [self.lastScreenShotView removeFromSuperview];
    
    UIImage *lastScreenShot = [self.screenShotsList lastObject];
    self.lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
    [self.backgroundView insertSubview:self.lastScreenShotView belowSubview:self.blackMask];
    
    [self moveViewWithX:0];
    __block UIViewController *cv;
    [UIView animateWithDuration:0.35 animations:^{
        [self moveViewWithX:320];
    } completion:^(BOOL finished) {
        cv = [self popViewControllerAnimated:NO];
        CGRect frame = self.view.frame;
        frame.origin.x = 0;
        self.view.frame = frame;
        [self.lastScreenShotView removeFromSuperview]; //TODO: need more test here
    }];

    return cv;
}

#pragma mark - Utility Methods -

// get the current view screen shot
- (UIImage *)capture
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

// set lastScreenShotView 's position and alpha when paning
- (void)moveViewWithX:(float)x
{
    IFADOB(x>320, x=320);
    IFADOB(x<0, x=0);
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float scale = (x/6400)+0.95;
    float alpha = 0.4 - (x/800);

    self.lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
    self.blackMask.alpha = alpha;
    
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (![[self.viewControllers lastObject] isAllowedSwipeBack])
        return;
    
    // If the viewControllers has only one vc or disable the interaction, then return.
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    // we get the touch position by the window's coordinate
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    // begin paning, show the backgroundView(last screenshot),if not exist, create it.
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        self.isMoving = YES;
        self.startTouch = touchPoint;
        
        if (!self.backgroundView)
        {
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            self.blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            self.blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:self.blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (self.lastScreenShotView) [self.lastScreenShotView removeFromSuperview];
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        self.lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        [self.backgroundView insertSubview:self.lastScreenShotView belowSubview:self.blackMask];
        
        //End paning, always check that if it should move right or move left automatically
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - self.startTouch.x > 50)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:320];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                self.isMoving = NO;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                self.isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
        // cancal panning, alway move to left side automatically
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            self.isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    // it keeps move with touch
    if (self.isMoving) {
        [self moveViewWithX:touchPoint.x - self.startTouch.x];
    }
}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    if ([[touch.view.superview superview] isKindOfClass:[BMKMapView class]])
//        return NO;
//    return YES;
//}

@end
