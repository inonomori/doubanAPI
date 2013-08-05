//
//  FSUIViewAnimation.h
//  Photo2GO
//
//  Created by Zhefu Wang on 13-6-28.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSUIViewAnimation : NSObject

+ (void)viewAnimationForView:(UIView*)view WithDuration:(NSTimeInterval)duration isHidden:(BOOL)isHidden;
+ (void)buttonAnimationWithSender:(id)sender View:(UIView*)view ViewColor:(UIColor*)viewColor WithSegueIdentifier:(NSString*)identifier additionCompletion:(void (^)(void))completion;
+ (void)AnimatedCenteringView:(UIView*)view Duration:(CGFloat)duration AddtionAnimation:(void(^)(void))addtionAnimation Completion:(void(^)(void))completion;
+ (void)buttonAnimationWithSender:(id)sender Button:(UIButton*)button ButtonColor:(UIColor*)buttonColor WithSegueIdentifier:(NSString*)identifier;

@end
