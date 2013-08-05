//
//  FSResultViewController.h
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-5.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSResultViewController : UIViewController

@property (nonatomic, strong) NSArray *bookResultArray;
@property (nonatomic, strong) NSArray *movieResultArray;
@property (nonatomic, strong) NSArray *musicResultArray;

@end

@interface FSResultCell : UITableViewCell

@end