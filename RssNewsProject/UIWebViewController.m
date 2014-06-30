//
//  UIWebViewController.m
//  FailedBankCD
//
//  Created by Admin on 26.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "UIWebViewController.h"
#import "Reachability.h"

@interface UIWebViewController ()

@end

@implementation UIWebViewController

- (void)setOpenURL:(id)stringURL
{
    if (_openURL != stringURL) {
        _openURL = stringURL;
    }
}

- (void)configureView
{
    if ([self connectedToInternet])
    {

    NSString *urlReadyForConvert = self.openURL;
    if ([self.openURL length] > 0) {
        urlReadyForConvert = [urlReadyForConvert substringWithRange:NSMakeRange(0, [urlReadyForConvert length] - 2)];
    } else {
        //no characters to delete... attempting to do so will result in a crash
    }
    
    NSURL *url = [NSURL URLWithString:urlReadyForConvert];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
//   [[UIApplication sharedApplication] openURL:url];
    } else
    {
        NSString *asd = @"Internet connection is not available!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Internet" message:asd
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (BOOL)connectedToInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];

    return (networkStatus == NotReachable) ? NO : YES;
}

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
    [self configureView];
//    self.navigationItem.hidesBackButton = YES; // Important
//	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
//                            style:UIBarButtonItemStyleBordered target:self action:@selector(myCustomBack)];
}

-(void) myCustomBack {
	// Some anything you need to do before leaving
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
