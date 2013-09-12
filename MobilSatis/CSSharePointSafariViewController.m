//
//  CSSharePointSafariViewController.m
//  MobilSatis
//
//  Created by alp keser on 10/8/12.
//
//

#import "CSSharePointSafariViewController.h"

@interface CSSharePointSafariViewController ()

@end

@implementation CSSharePointSafariViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithURL:(NSString *)i_url {
    self = [super init];
    
    if (self) {
        urlAdress = i_url;
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self stopAnimationOnView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:urlAdress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
