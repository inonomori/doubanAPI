//
//  FSToolBox.m
//  ANJIVillages
//
//  Created by Zhefu Wang on 13-4-25.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import "FSToolBox.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@implementation FSToolBox

+ (CGSize)getApplicationFrameSize
{
    CGSize size = [UIScreen mainScreen].applicationFrame.size;
    UIInterfaceOrientation deviceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (deviceOrientation == UIInterfaceOrientationLandscapeLeft || deviceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        TLSWAP(size.width, size.height);
    }
    return size;
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)opacity
{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:opacity];
}

+ (NSInteger)getSystemVersionAsAnInteger{
    NSInteger index = 0;
    NSInteger version = 0;
    
    NSArray* digits = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    NSEnumerator* enumer = [digits objectEnumerator];
    NSString* number;
    while (number = [enumer nextObject])
    {
        if (index>2)
            break;
        NSInteger multipler = powf(100, 2-index);
        version += [number intValue]*multipler;
        index++;
    }
    return version;
}

+ (BOOL)isCurrentDevicePhone
{
    //return (([self getiOSDevice]&(device_iPhone|device_iPod_touch))!=0)?YES:NO;
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

+ (BOOL)isCurrentDevicePad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (NSString*)hashString:(NSString *)string
{
    unsigned long cryptTable[0x500];
    unsigned long seed = 0x00100001, index1, index2, i;
    
    for( index1 = 0; index1 < 0x100; index1++ )
    {
        for( index2 = index1, i = 0; i < 5; i++, index2 += 0x100 )
        {
            unsigned long temp1, temp2;
            seed = (seed * 125 + 3) % 0x2AAAAB;
            temp1 = (seed & 0xFFFF) << 0x10;
            seed = (seed * 125 + 3) % 0x2AAAAB;
            temp2 = (seed & 0xFFFF);
            cryptTable[index2] = ( temp1 | temp2 );
        }
    }
    
    unsigned long seed1 = 0x7FED7FED, seed2 = 0xEEEEEEEE;
    int ch;
    
    for (i = 0;i<[string length];++i)
    {
        ch = toupper([string characterAtIndex:i]);
        
        seed1 = cryptTable[(1 << 8) + ch] ^ (seed1 + seed2);
        seed2 = ch + seed1 + seed2 + (seed2 << 5) + 3;
    }
    
    return [NSString stringWithFormat:@"%ld",seed1];
}

+ (NSString*)getSystemTimeString
{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //[dateformatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    //NSString *  morelocationString=[dateformatter stringFromDate:senddate];
    
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *  nsDateString= [NSString  stringWithFormat:@"%4d年%2d月%2d日",year,month,day];
    
    NSString* result = [NSString stringWithFormat:@"%@-%@",nsDateString,locationString];
    
    return result;
}

#pragma mark - DegugInfo
+ (void)DebugShowAllFonts
{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

+ (CAAnimation*)getBoundsAnimation:(CGRect)fromFrame toValue:(CGRect)toFrame fromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition delegate:(id)delegate duration:(float)duration
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    scaleAnimation.fromValue = [NSValue valueWithCGRect:fromFrame];
    scaleAnimation.toValue = [NSValue valueWithCGRect:toFrame];
    
    CABasicAnimation* positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:fromPosition];
    positionAnimation.toValue = [NSValue valueWithCGPoint:toPosition];
    
    CAAnimationGroup* groupAnimation = [CAAnimationGroup animation];
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.duration = duration;
    groupAnimation.animations = @[positionAnimation,scaleAnimation];
    groupAnimation.delegate = delegate;
    
    return groupAnimation;
}

+ (CAAnimation*)getOpacityAnimation:(float)duration fromValue:(double)fromValue toValue:(double)toValue
{
    CABasicAnimation* opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithDouble:fromValue];
    opacityAnimation.toValue = [NSNumber numberWithDouble:toValue];
    opacityAnimation.duration = duration;
    
    return opacityAnimation;
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


@end
