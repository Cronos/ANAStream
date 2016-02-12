//
//  ANAPeerPlayer.h
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MCPeerID;

@protocol ANAPeerPlayerDelegate
- (void)showImage:(UIImage*)image;

@end

@interface ANAPeerPlayer : NSObject
@property (nonatomic, strong) id<ANAPeerPlayerDelegate> delegate;

- (instancetype)init;

- (void)addImageFrame:(UIImage *)image withFPS:(NSNumber *)fps;
- (void)stopPlaying;

@end
