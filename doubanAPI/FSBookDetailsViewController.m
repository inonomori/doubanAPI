//
//  FSBookDetailsViewController.m
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-5.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "FSBookDetailsViewController.h"
#import "HMSegmentedControl.h"
#import "FSStarCoverView.h"

@interface FSBookDetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) HMSegmentedControl *segementController;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *descriptionTextView;

@end

@implementation FSBookDetailsViewController

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
    self.bookTitleLabel.text = self.title;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.detailData[@"image"]]
                   placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
    
    self.imageView.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    self.imageView.layer.shadowOffset = CGSizeMake(5, 5);
    self.imageView.layer.shadowOpacity = 0.6f;
    self.imageView.layer.shadowRadius = 5.0f;

    
    //segement control
    self.segementController = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 250, 320, 50)];
    [self.segementController setSectionTitles:@[@"介 绍", @"资 料", @"评 价"]];
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
    [self.scrollView setContentSize:CGSizeMake(960, [FSToolBox getApplicationFrameSize].height-300)];
    [self.scrollView scrollRectToVisible:CGRectMake(0, 0, 320, [FSToolBox getApplicationFrameSize].height-300) animated:NO];
    self.scrollView.backgroundColor = [UIColor lightGrayColor];
    self.scrollView.scrollEnabled = NO;
    [self.scrollView setDelegate:self];
    [self.view addSubview:self.scrollView];
    
    //section 1
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, [FSToolBox getApplicationFrameSize].width-10, self.scrollView.frame.size.height-5)];
    self.descriptionTextView.backgroundColor = [UIColor clearColor];
    self.descriptionTextView.text = self.detailData[@"summary"];
    self.descriptionTextView.editable = NO;
    self.descriptionTextView.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    self.descriptionTextView.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    [self.scrollView addSubview:self.descriptionTextView];
    
    //section 2
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, 5, 330, 30)];
    authorLabel.text = [NSString stringWithFormat:@"作 者: %@",(((NSArray*)self.detailData[@"author"]).count == 0)?@"Unknown":self.detailData[@"author"][0]];
    authorLabel.backgroundColor = [UIColor clearColor];
    authorLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    authorLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:authorLabel];
    
    UILabel *bindingLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, (self.scrollView.frame.size.height)/6, 330, 30)];
    bindingLabel.text = [NSString stringWithFormat:@"装 订: %@",([(NSString*)self.detailData[@"binding"] isEqualToString:@""])?@"Unknown":self.detailData[@"binding"]];
    bindingLabel.backgroundColor = [UIColor clearColor];
    bindingLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    bindingLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:bindingLabel];
    
    UILabel *pageCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, (self.scrollView.frame.size.height)/6*2, 330, 30)];
    pageCountLabel.text = [NSString stringWithFormat:@"页 码: %@",([(NSString*)self.detailData[@"pages"] isEqualToString:@""])?@"Unknown":self.detailData[@"pages"]];
    pageCountLabel.backgroundColor = [UIColor clearColor];
    pageCountLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    pageCountLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:pageCountLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, (self.scrollView.frame.size.height)/6*3, 330, 30)];
    priceLabel.text = [NSString stringWithFormat:@"价 格: %@",([(NSString*)self.detailData[@"price"] isEqualToString:@""])?@"Unknown":self.detailData[@"price"]];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    priceLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:priceLabel];
    
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, (self.scrollView.frame.size.height)/6*4, 330, 30)];
    publisherLabel.text = [NSString stringWithFormat:@"出 版 商: %@",([(NSString*)self.detailData[@"publisher"] isEqualToString:@""])?@"Unknown":self.detailData[@"publisher"]];
    publisherLabel.backgroundColor = [UIColor clearColor];
    publisherLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    publisherLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:publisherLabel];
    
    UILabel *publishDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(330, (self.scrollView.frame.size.height)/6*5, 330, 30)];
    publishDateLabel.text = [NSString stringWithFormat:@"出版时间: %@",([(NSString*)self.detailData[@"pubdate"] isEqualToString:@""])?@"Unknown":self.detailData[@"pubdate"]];
    publishDateLabel.backgroundColor = [UIColor clearColor];
    publishDateLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    publishDateLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:publishDateLabel];
    
    
    //section 3
    FSStarCoverView *starBackGroundView = [[FSStarCoverView alloc] initWithFrame:CGRectMake(640, self.scrollView.frame.size.height/2-33, 300, 66)];
    starBackGroundView.backgroundColor = [UIColor clearColor];
    CGFloat avgRate = [self.detailData[@"rating"][@"average"] floatValue];
    starBackGroundView.ratio = avgRate/10.0;
    [self.scrollView addSubview:starBackGroundView];
    
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(640,self.scrollView.frame.size.height/2+33,300,66)];
    ratingLabel.textAlignment = NSTextAlignmentCenter;
    
    ratingLabel.text = [NSString stringWithFormat:@"评价: %@/%@ (%d 个评价)",([(NSString*)self.detailData[@"rating"][@"average"] isEqualToString:@""])?@"NA":self.detailData[@"rating"][@"average"],@"10", [self.detailData[@"rating"][@"numRaters"] intValue]];
    
    ratingLabel.backgroundColor = [UIColor clearColor];
    ratingLabel.font = [UIFont fontWithName:@"RTWSShangYaG0v1-Regular" size:14];
    ratingLabel.textColor = [FSToolBox colorWithHex:0x3c3c3c alpha:1];
    [self.scrollView addSubview:ratingLabel];

    
    UIImageView *starsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"stars.png"]];
    starsImageView.frame = starBackGroundView.frame;
    [self.scrollView addSubview:starsImageView];

    
	// Do any additional setup after loading the view.
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
