//
//  UIViewController+ANAAlert.h
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ANAAlert)

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message handler:(void (^)(UIAlertAction *action))handler;

@end
