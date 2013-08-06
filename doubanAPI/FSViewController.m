//
//  FSViewController.m
//  doubanAPI
//
//  Created by Zhefu Wang on 13-8-5.
//  Copyright (c) 2013年 Finder Studio. All rights reserved.
//

#import "FSViewController.h"
#import "AFNetworking.h"
#import "FSStringDefinition.h"
#import "FSResultViewController.h"
#import "MBProgressHUD.h"

@interface FSViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) NSArray *bookResultArray;
@property (nonatomic, strong) NSArray *movieResultArray;
@property (nonatomic, strong) NSArray *musicResultArray;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation FSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}

- (IBAction)searchButtonTouched:(UIButton *)sender
{
    [self searchBegin];
}

- (IBAction)DidEndOnExit:(UITextField *)sender
{
    [self searchBegin];
}

- (IBAction)EditingChanged:(UITextField *)sender
{
    //show&hide search button
    if ([self.searchField.text isEqualToString:@""])
    {
        [FSUIViewAnimation viewAnimationForView:self.searchButton WithDuration:0.2 isHidden:YES];
    }
    else
    {
        [FSUIViewAnimation viewAnimationForView:self.searchButton WithDuration:0.2 isHidden:NO];
    }
}

- (IBAction)tapOutsideSearchField:(UITapGestureRecognizer *)sender
{
    //dismiss keypad
    [self.view endEditing:YES];
}

- (void)searchBegin
{
    self.hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.hud];
	
	self.hud.labelText = SEARCH_TEXT;
	
    [self.hud show:YES];

    
    NSString* urlString = [NSString stringWithFormat:bookQuery_URL,self.searchField.text];
    NSString* escapedUrlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",escapedUrlString);

    NSURL *url = [NSURL URLWithString:escapedUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    //search
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             NSLog(@"data loading complete");
                                             self.bookResultArray = JSON[@"books"];
                                             
                                             NSString* urlString = [NSString stringWithFormat:movieQuery_URL,self.searchField.text];
                                             NSString* escapedUrlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                             NSLog(@"%@",escapedUrlString);

                                             NSURL *url = [NSURL URLWithString:escapedUrlString];
                                             NSURLRequest *request2 = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
                                             
                                             AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request2
                                                                                                                                 success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                                                  {
                                                                                      NSLog(@"data loading complete");
                                                                                      self.movieResultArray = JSON[@"subjects"];
                                                                                      NSString* urlString = [NSString stringWithFormat:musicQuery_URL,self.searchField.text];
                                                                                      NSString* escapedUrlString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                                                                      NSLog(@"%@",escapedUrlString);
                                                                                      
                                                                                      NSURL *url = [NSURL URLWithString:escapedUrlString];
                                                                                      NSURLRequest *request2 = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
                                                                                      
                                                                                      AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request2
                                                                                                                                                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                                                                                                           {
                                                                                                                               NSLog(@"data loading complete");
                                                                                                                               [self.hud hide:YES];

                                                                                                                               self.musicResultArray = JSON[@"musics"];
                                                                                                                               [self performSegueWithIdentifier:@"resultSegue" sender:self];
                                                                                                                           }
                                                                                                                                                                          failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                                                                                                           {
                                                                                                                               NSLog(@"%@",error);
                                                                                                                           }];
                                                                                      operation.JSONReadingOptions = NSJSONReadingMutableContainers;
                                                                                      NSLog(@"start");
                                                                                      
                                                                                      [operation start];                                             

                                                                                      
                                                                                  }
                                                                                                                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                                                                  {
                                                                                      NSLog(@"%@",error);
                                                                                  }];
                                             operation.JSONReadingOptions = NSJSONReadingMutableContainers;
                                             NSLog(@"start");
                                             
                                             [operation start];                                             
                                         }
                                                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             NSLog(@"%@",error);
                                         }];
    operation.JSONReadingOptions = NSJSONReadingMutableContainers;
    NSLog(@"start");

    [operation start];

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resultSegue"])
    {
        FSResultViewController *resultViewController = segue.destinationViewController;
        resultViewController.bookResultArray = self.bookResultArray;
        resultViewController.movieResultArray = self.movieResultArray;
        resultViewController.musicResultArray = self.musicResultArray;
    }
}

@end
