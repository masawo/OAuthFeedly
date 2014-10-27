//
//  WebViewController.m
//  OAuthFeedly
//
//  Created by Masao S on 2014/10/27.
//  Copyright (c) 2014年 masawo. All rights reserved.
//

#import "WebViewController.h"
#import "NXOAuth2AccountStore.h"
#import "NXOAuth2Account.h"
#import "NXOAuth2Request.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _webView.delegate = self;

    [self p_addOauth2Notification];
    [self p_startRequest];
}

- (void)p_addOauth2Notification {
    self.successObserver = [
            [NSNotificationCenter defaultCenter]
            addObserverForName:NXOAuth2AccountStoreAccountsDidChangeNotification
                        object:[NXOAuth2AccountStore sharedStore]
                         queue:nil
                    usingBlock:^(NSNotification *notification) {
                        NSLog(@"Success.");
                        NSDictionary *dictionary = notification.userInfo;
                        NXOAuth2Account *account = dictionary[NXOAuth2AccountStoreNewAccountUserInfoKey];
                        [self p_getUserProfile:account];
                    }];
    self.failObserver = [
            [NSNotificationCenter defaultCenter]
            addObserverForName:NXOAuth2AccountStoreDidFailToRequestAccessNotification
                        object:[NXOAuth2AccountStore sharedStore]
                         queue:nil
                    usingBlock:^(NSNotification *notification) {
                        NSLog(@"Fail.");
                        [self.navigationController popViewControllerAnimated:YES];
                    }
    ];
}

- (void)p_startRequest {
    [[NXOAuth2AccountStore sharedStore] requestAccessToAccountWithType:@"Feedly"
                                   withPreparedAuthorizationURLHandler:^(NSURL *preparedURL) {
                                       [_webView loadRequest:[NSURLRequest requestWithURL:preparedURL]];
                                   }];
}

- (void)p_getUserProfile:(NXOAuth2Account *)account {
    NSLog(@"account info:%@", account);

    NSURL *targetURL = [NSURL URLWithString:@"https://sandbox.feedly.com/v3/profile"];
    [NXOAuth2Request performMethod:@"GET"
                        onResource:targetURL
                   usingParameters:nil
                       withAccount:account
               sendProgressHandler:^(unsigned long long bytesSend, unsigned long long bytesTotal) {
                   // TODO
               }
                   responseHandler:^(NSURLResponse *response, NSData *responseData, NSError *error) {
                       NSLog(@"error : %@", error);
                       NSLog(@"response : %@", response);
                       NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                       NSLog(@"response data : %@", jsonString);

                       if (!error) {
                           //success
                           NSLog(@"get profile success.");
                           //json変換してDictionary型をuserDataとして格納する
                           NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                           if (dict) {
                               //set user data
                               [account setUserData:dict];
                           }

                           //pop viewcontroller
                           [self.navigationController popViewControllerAnimated:YES];

                       } else {
                           //error
                           NSLog(@"get profile failer.");
                       }
                   }];
}

- (void)viewDidDisappear:(BOOL)animated {
    //hide network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //remove notifications
    [self p_removeOauth2Notification];

}

- (void) p_removeOauth2Notification {
    [[NSNotificationCenter defaultCenter] removeObserver:self.successObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.failObserver];
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

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%s", sel_getName(_cmd));
    NSLog(@"%@", request);

    if ([[NXOAuth2AccountStore sharedStore] handleRedirectURL:[request URL]]) {
        return NO;
    }
    return YES;
}


@end
