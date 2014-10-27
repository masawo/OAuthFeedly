//
//  WebViewController.h
//  OAuthFeedly
//
//  Created by Masao S on 2014/10/27.
//  Copyright (c) 2014年 masawo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) id successObserver;
@property (strong, nonatomic) id failObserver;
@end
