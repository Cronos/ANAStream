//
//  ANAViewStreamController.h
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCSession;

@interface ANAViewStreamController : UIViewController
@property (nonatomic, strong) MCSession *session;

@end
