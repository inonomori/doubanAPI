//
//  FSToolBox.h
//  ANJIVillages
//
//  Created by Zhefu Wang on 13-4-25.
//  Copyright (c) 2013年 zjgis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#define IFADOB(A,B) ((A)&&(B,0))
#define IFNADOB(A,B) ((A)||(B,0))

#define random(x) (rand()%x)

#ifdef DEBUG
#define DebugLog( s, ... ) NSLog( @"<%p %s %@:(%d)> %@", self, __func__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif

#define TLSWAP(A,B) do{\
__typeof__(A) __tmp = (A);\
A = B;\
B = __tmp;\
}while(0)

#define TN2(_x) 1<<_x

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface FSToolBox : NSObject

+ (CGSize)getApplicationFrameSize;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;
+ (NSInteger)getSystemVersionAsAnInteger;
+ (BOOL)isCurrentDevicePhone;
+ (BOOL)isCurrentDevicePad;
+ (void)DebugShowAllFonts;
+ (NSString*)hashString:(NSString *)string;
+ (NSString*)getSystemTimeString;
+ (CAAnimation*)getBoundsAnimation:(CGRect)fromFrame toValue:(CGRect)toFrame fromPosition:(CGPoint)fromPosition toPosition:(CGPoint)toPosition delegate:(id)delegate duration:(float)duration;
+ (CAAnimation*) getOpacityAnimation:(float)duration fromValue:(double)fromValue toValue:(double)toValue;
+ (BOOL)validateEmailWithString:(NSString*)email;

@end
