//
//  FSMovieDetailsViewController.m
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-6.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FSMovieDetailsViewController.h"
#import "HMSegmentedControl.h"
#import "FSStarCoverView.h"

@interface FSMovieDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) HMSegmentedControl *segementController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *descriptionTextView;

@end

@implementation FSMovieDetailsViewController

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
    
    self.movieTitleLabel.text = self.title;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.detailData[@"images"][@"medium"]]
                   placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
    
    self.imageView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.imageView.layer.shadowOffset = CGSizeMake(5, 5);
    self.imageView.layer.shadowOpacity = 0.6f;
    self.imageView.layer.shadowRadius = 5.0f;
    
    
    //segement control
    self.segementController = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 250, 320, 50)];
    [self.segementController setSectionTitles:@[@"资 料", @"评 价"]];
    [self.segementController setSelectedSegmentIndex:0];
    [self.segementController setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
    [self.segementController setTextColor:[UIColor whiteColor]];
    [self.segementController setSelectedTextColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]];
    [self.segementController setSelectionIndicatorColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1]];
    [self.segementController setSelectionStyle:HMSegmentedControlSelectionStyleBox];
    [self.segementController setSelectionLocation:HMSegmentedControlSelectionLocationUp];
    
    __weak typeof(self) weakSelf = self;
    [self.segementController setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(320 * index, 0, 320, 200) animated:YES];
    }];
    
    [self.view addSubview:self.segementController];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, [FSToolBox getApplicationFrameSize].width, [FSToolBox getApplicationFrameSize].height-300)];
    [self.scrollView setBackgroundColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1]];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setContentSize:CGSizeMake(640, [FSToolBox getApplicationFrameSize].height-300)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, [FSToolBox getApplicationFrameSize].height-300) animated:NO];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = NO;
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
        
    //section 1
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 320, 30)];
    titleLabel.text = [NSString stringWithFormat:@"片 名: %@",self.detailData[@"title"]];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    titleLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:titleLabel];
    
    UILabel *originalTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.scrollView.frame.size.height)/4, 320, 30)];
    originalTitleLabel.text = [NSString stringWithFormat:@"原 名: %@",self.detailData[@"original_title"]];
    originalTitleLabel.backgroundColor = [UIColor clearColor];
    originalTitleLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    originalTitleLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:originalTitleLabel];
    
    UILabel *subTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.scrollView.frame.size.height)/4*2, 320, 30)];
    subTypeLabel.text = [NSString stringWithFormat:@"类 型: %@",self.detailData[@"subtype"]];
    subTypeLabel.backgroundColor = [UIColor clearColor];
    subTypeLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    subTypeLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:subTypeLabel];
    
    UILabel *yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.scrollView.frame.size.height)/4*3, 320, 30)];
    yearLabel.text = [NSString stringWithFormat:@"年 代: %@",self.detailData[@"year"]];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    yearLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:yearLabel];
    
    
    
    //section 2
    FSStarCoverView *starBackGroundView = [[FSStarCoverView alloc] initWithFrame:CGRectMake(320, self.scrollView.frame.size.height/2-33, 300, 66)];
    starBackGroundView.backgroundColor = [UIColor clearColor];
    CGFloat avgRate = [self.detailData[@"rating"][@"average"] floatValue];
    starBackGroundView.ratio = avgRate/10.0;
    [self.scrollView addSubview:starBackGroundView];
    
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(320,self.scrollView.frame.size.height/2+33,300,66)];
    ratingLabel.textAlignment = NSTextAlignmentCenter;
    
    ratingLabel.text = [NSString stringWithFormat:@"评价: %d/%@ (%@ 个评价)",[self.detailData[@"rating"][@"average"] intValue],@"10", self.detailData[@"rating"][@"stars"]];
    
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    ratingLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:ratingLabel];
    
    
    UIImageView *starsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stars.png"]];
    starsImageView.frame = starBackGroundView.frame;
    [self.scrollView addSubview:starsImageView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouched:(UIButton *)sender
{
    [self popBack];
}

@end
