//
//  FSDetailsViewController.h
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-5.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSDetailsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *detailData;

- (void)popBack;

@end
