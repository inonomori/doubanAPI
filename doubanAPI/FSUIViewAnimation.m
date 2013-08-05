//
//  FSUIViewAnimation.m
//  Photo2GO
//
//  Created by Zhefu Wang on 13-6-28.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import "FSUIViewAnimation.h"

@implementation FSUIViewAnimation

+ (void)viewAnimationForView:(UIView*)view WithDuration:(NSTimeInterval)duration isHidden:(BOOL)isHidden
{
    IFNADOB(isHidden, view.hidden = NO);
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.alpha = (isHidden)?0:1;
                     }
                     completion:^(BOOL finished){
                         IFADOB(finished, IFADOB(isHidden, view.hidden = YES));
                     }];
}

+ (void)buttonAnimationWithSender:(id)sender View:(UIView*)view ViewColor:(UIColor*)viewColor WithSegueIdentifier:(NSString*)identifier additionCompletion:(void (^)(void))completion
{
    CGRect originalFrame = view.frame;
    UIColor *originalColor = view.backgroundColor;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         view.frame = CGRectMake(0, 0, [FSToolBox getApplicationFrameSize].width, [FSToolBox getApplicationFrameSize].height);
         view.backgroundColor = viewColor;
     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             [sender performSegueWithIdentifier:identifier sender:view];
             view.frame = originalFrame;
             view.backgroundColor = originalColor;
             if (completion)
                 completion();
         }
     }];
}

+ (void)buttonAnimationWithSender:(id)sender Button:(UIButton*)button ButtonColor:(UIColor*)buttonColor WithSegueIdentifier:(NSString*)identifier
{
    CGRect originalFrame = button.frame;
    UIColor *originalColor = button.backgroundColor;
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         button.frame = CGRectMake(0, 0, [FSToolBox getApplicationFrameSize].width, [FSToolBox getApplicationFrameSize].height);
         button.backgroundColor = buttonColor;
     }
                     completion:^(BOOL finished)
     {
         [sender performSegueWithIdentifier:identifier sender:button];
         button.frame = originalFrame;
         button.backgroundColor = originalColor;
     }];
}

/* duration must greater than 0.4 seconds */
+ (void)AnimatedCenteringView:(UIView*)view Duration:(CGFloat)duration AddtionAnimation:(void(^)(void))addtionAnimation Completion:(void(^)(void))completion
{
    view.frame = CGRectMake(([FSToolBox getApplicationFrameSize].width-view.frame.size.width)/2, [FSToolBox getApplicationFrameSize].height, view.frame.size.width, view.frame.size.height);
    [UIView animateWithDuration:duration - 0.4
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         view.frame = CGRectMake(([FSToolBox getApplicationFrameSize].width-view.frame.size.width)/2, ([FSToolBox getApplicationFrameSize].height-view.frame.size.height)/2-40, view.frame.size.width, view.frame.size.height);
                         IFADOB(addtionAnimation, addtionAnimation());
                     }
                     completion:^(BOOL finished){
                         if (finished){
                             [UIView animateWithDuration:0.1
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  view.frame = CGRectMake(([FSToolBox getApplicationFrameSize].width-view.frame.size.width)/2, ([FSToolBox getApplicationFrameSize].height-view.frame.size.height)/2+30, view.frame.size.width, view.frame.size.height);
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished){
                                                      [UIView animateWithDuration:0.1
                                                                            delay:0
                                                                          options:UIViewAnimationOptionCurveEaseIn
                                                                       animations:^{
                                                                           view.frame = CGRectMake(([FSToolBox getApplicationFrameSize].width-view.frame.size.width)/2, ([FSToolBox getApplicationFrameSize].height-view.frame.size.height)/2-20, view.frame.size.width, view.frame.size.height);
                                                                       }
                                                                       completion:^(BOOL finished){
                                                                           if (finished){
                                                                               [UIView animateWithDuration:0.1
                                                                                                     delay:0
                                                                                                   options:UIViewAnimationOptionCurveEaseIn
                                                                                                animations:^{
                                                                                                    view.frame = CGRectMake(([FSToolBox getApplicationFrameSize].width-view.frame.size.width)/2, ([FSToolBox getApplicationFrameSize].height-view.frame.size.height)/2+10, view.frame.size.width, view.frame.size.height);
                                                                                                }
                                                                                                completion:^(BOOL finished){
                                                                                                    if (finished){
                                                                                                        [UIView animateWithDuration:0.1
                                                                                                                              delay:0
                                                                                                                            options:UIViewAnimationOptionCurveEaseOut
                                                                                                                         animations:^{
                                                                                                                             view.frame = CGRectMake(([FSToolBox getApplicationFrameSize].width-view.frame.size.width)/2, ([FSToolBox getApplicationFrameSize].height-view.frame.size.height)/2, view.frame.size.width, view.frame.size.height);
                                                                                                                         }
                                                                                                                         completion:^(BOOL finished){
                                                                                                                             IFADOB(completion, completion());
                                                                                                                         }];
                                                                                                    }
                                                                                                }];
                                                                           }
                                                                       }];
                                                  }
                                              }];
                         }
                     }];
}


@end
