//
//  AppDelegate.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "ANAAppDelegate.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBNotifications/FBNotifications.h>

@interface ANAAppDelegate ()

@end

@implementation ANAAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

#pragma mark -
#pragma mark Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [FBSDKAppEvents setPushNotificationsDeviceToken:deviceToken];
}

- (void)       application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
     forRemoteNotification:(NSDictionary *)userInfo
         completionHandler:(void (^)())completionHandler
{
    [FBSDKAppEvents logPushNotificationOpen:userInfo action:identifier];
}

- (void)         application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler
{
    [FBSDKAppEvents logPushNotificationOpen:userInfo];

    FBNotificationsManager *notificationsManager = [FBNotificationsManager sharedManager];
    [notificationsManager presentPushCardForRemoteNotificationPayload:userInfo
                                                   fromViewController:nil
                                                           completion:^(FBNCardViewController * _Nullable viewController, NSError * _Nullable error) {
                                                               if (error) {
                                                                   completionHandler(UIBackgroundFetchResultFailed);
                                                               } else {
                                                                   completionHandler(UIBackgroundFetchResultNewData);
                                                               }
                                                           }];
}


@end
