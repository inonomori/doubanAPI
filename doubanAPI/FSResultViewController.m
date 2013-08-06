//
//  FSResultViewController.m
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-5.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import "FSResultViewController.h"
#import "FSNavigationController.h"
#import "UIImageView+WebCache.h"
#import "FSDetailsViewController.h"

@interface FSResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *previewImage;
@property (weak, nonatomic) IBOutlet UILabel *entryTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailsLabel;

@end

@implementation FSResultCell


@end


@interface FSResultViewController ()

@property (nonatomic, strong) NSDictionary *passResultDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FSResultViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonTouched:(UIButton *)sender
{
    FSNavigationController *navCV = (FSNavigationController*)self.navigationController;
    [navCV popViewControllerWithSlideAnimation];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"图书";
        case 1:
            return @"电影";
        case 2:
            return @"音乐";
        default:
            return @"undefined";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.bookResultArray.count;
        case 1:
            return self.movieResultArray.count;
        case 2:
            return self.musicResultArray.count;
        default:
            return 0;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return @[@"图书",@"电影",@"音乐"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"bookCell";
    FSResultCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
        {
            cell.entryTitle.text = self.bookResultArray[indexPath.row][@"title"];
            if (((NSArray*)self.bookResultArray[indexPath.row][@"author"]).count != 0)
                cell.detailsLabel.text = self.bookResultArray[indexPath.row][@"author"][0];
            else
                cell.detailsLabel.text = @"Unknown Author";
            [cell.previewImage setImageWithURL:[NSURL URLWithString:self.bookResultArray[indexPath.row][@"image"]]
                              placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
        }
            break;
        case 1:
        {
            cell.entryTitle.text = self.movieResultArray[indexPath.row][@"title"];
            cell.detailsLabel.text = self.movieResultArray[indexPath.row][@"original_title"];
            [cell.previewImage setImageWithURL:[NSURL URLWithString:self.bookResultArray[indexPath.row][@"images"][@"medium"]]
                              placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
        }
        case 2:
        {
            cell.entryTitle.text = self.musicResultArray[indexPath.row][@"title"];
            if (((NSArray*)self.musicResultArray[indexPath.row][@"author"]).count != 0){
                NSLog(@"%@",self.musicResultArray[indexPath.row]);

                cell.detailsLabel.text = self.musicResultArray[indexPath.row][@"author"][0][@"name"];
            }
            else
                cell.detailsLabel.text = @"Unknown Author";
            [cell.previewImage setImageWithURL:[NSURL URLWithString:self.musicResultArray[indexPath.row][@"image"]]
                              placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];

        }
            
        default:
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO; 
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0: //books
            self.passResultDictionary = self.bookResultArray[indexPath.row];
            [self performSegueWithIdentifier:@"bookDetailsSegue" sender:self];
            break;
        case 1: //movies
            self.passResultDictionary = self.movieResultArray[indexPath.row];
            [self performSegueWithIdentifier:@"movieDetailsSegue" sender:self];
            break;
        case 2: //musics
            self.passResultDictionary = self.musicResultArray[indexPath.row];
            [self performSegueWithIdentifier:@"musicDetailsSegue" sender:self];
            break;
        default:
            break;
    }
}

#pragma mark - segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    FSDetailsViewController *viewController = segue.destinationViewController;
    viewController.title = self.passResultDictionary[@"title"];
    viewController.detailData = self.passResultDictionary;
}

@end
