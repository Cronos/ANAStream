//
//  UIViewController+ANAAlert.h
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ANAAlertActionHandler)(UIAlertAction *action);

@interface UIViewController (ANAAlert)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   handler:(ANAAlertActionHandler)handler;

@end
