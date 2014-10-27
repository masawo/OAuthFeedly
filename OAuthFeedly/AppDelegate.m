//
//  AppDelegate.m
//  OAuthFeedly
//
//  Created by Masao S on 2014/10/24.
//  Copyright (c) 2014年 masawo. All rights reserved.
//

#import "AppDelegate.h"
#import "NXOAuth2AccountStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (void)initialize {
    NSDictionary *appNetConfigDict = @{ kNXOAuth2AccountStoreConfigurationClientID: @"sandbox",
            kNXOAuth2AccountStoreConfigurationSecret: @"__your_client_secret__",
            kNXOAuth2AccountStoreConfigurationScope: [NSSet setWithObjects:@"https://cloud.feedly.com/subscriptions", nil],
            kNXOAuth2AccountStoreConfigurationAuthorizeURL: [NSURL URLWithString:@"https://sandbox.feedly.com/v3/auth/auth"],
            kNXOAuth2AccountStoreConfigurationTokenURL: [NSURL URLWithString:@"https://sandbox.feedly.com/v3/auth/token"],
            kNXOAuth2AccountStoreConfigurationRedirectURL: [NSURL URLWithString:@"http://localhost"],
//            kNXOAuth2AccountStoreConfigurationTokenType: @"Bearer",
    };

    [[NXOAuth2AccountStore sharedStore] setConfiguration:appNetConfigDict
                                          forAccountType:@"Feedly"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
