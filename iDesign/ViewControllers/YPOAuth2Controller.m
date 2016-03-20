//
//  YPOAuth2Controller.m
//  iDesign
//
//  Created by 千锋 on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPOAuth2Controller.h"
#import "AppDelegate.h"
#import "YPTabBarViewController.h"
#import <DRApiClient.h>
#import <NXOAuth2Account.h>
#import <NXOAuth2AccessToken.h>
#import "YPVCManager.h"


@interface YPOAuth2Controller ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) YPApiClient *client;

@end

@implementation YPOAuth2Controller

- (YPApiClient *)client
{
    if (_client == nil) {
        _client = [YPFactory shareApiClient];
    }
    return _client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor themeColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor themeBarTinColor]};

    self.navigationController.navigationBar.tintColor = [UIColor themeWhiteColor];
    
    NSString *requestStr = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@&scope=public+write+comment+upload&state=",OAuth2_BASE_URL,OAuth2_CLIENT_ID,OAuth2_RedirectUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:requestStr]];
    [_webView loadRequest:request];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(isLoginSuccess) userInfo:nil repeats:YES];
    _timer.fireDate = [NSDate distantPast];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
     
    __weak typeof(self) weakSelf = self;
    [self.client authorizeWithWebView:_webView authHandler:^(NXOAuth2Account *account, NSError *error) {
        if (account) {
            [weakSelf loginSuccess];
        }
    }];
}

- (void)isLoginSuccess
{
    YPApiClient *client = [[YPApiClient alloc] initWithSettings:self.client.settings];
    if ([client isUserAuthorized]) {
        AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
        delegate.client = client;
        [_timer invalidate];
        _timer = nil;
        [self loginSuccess];
    }else{
        client = nil;
    }
}

- (void)loginSuccess
{
    [SVProgressHUD showSuccessWithStatus:@"Success"];
    self.finishBlock(YES);
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)loadAcountInfoWithUser:(DRUser *)user
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
