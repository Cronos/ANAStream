//
//  UIViewController+ANAAlert.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "UIViewController+ANAAlert.h"

@implementation UIViewController (ANAAlert)

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   handler:(ANAAlertActionHandler)handler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:handler];
    [alertController addAction:action];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
