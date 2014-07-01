//
//  UIWebViewController.m
//  FailedBankCD
//
//  Created by Admin on 26.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "UIWebViewController.h"
#import "Reachability.h"

#define SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)

@interface UIWebViewController () <UIWebViewDelegate>
{
    UIWebView *webView;
    UIView* loadingView;
}

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
    [webView loadRequest:urlRequest];
//   [[UIApplication sharedApplication] openURL:url];
    } else
    {
        NSString *asd = @"Internet connection is not available!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Internet" message:asd
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [loadingView setHidden:YES];
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
    
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 40, SCREEN_HEIGHT / 2 - 40, 80, 80)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    webView.delegate = self;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
    
    [self configureView];
}

+ (CGFloat) window_height   {
    return [UIScreen mainScreen].applicationFrame.size.height;
}

+ (CGFloat) window_width   {
    return [UIScreen mainScreen].applicationFrame.size.width;
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
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [loadingView setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingView setHidden:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadingView setHidden:YES];
}

@end
