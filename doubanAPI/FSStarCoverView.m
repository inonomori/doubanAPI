//
//  FSStarCoverView.m
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-6.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import "FSStarCoverView.h"

@implementation FSStarCoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 255.0/255.0, 250.0/255.0, 80.0/255.0, 1);
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 0);
    CGContextFillRect(context,CGRectMake(0, 0, self.frame.size.width*self.ratio, 200));
}

@end
