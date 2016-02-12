//
//  ANAPeerPlayer.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "ANAPeerPlayer.h"

@interface ANAPeerPlayer ()
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) NSMutableArray *frames;
@property (nonatomic, strong) NSTimer *playerClock;

- (void)onTimer:(NSTimer *)timer;

@end

@implementation ANAPeerPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frames = @[].mutableCopy;
        self.isPlaying = NO;
    }
    
    return self;
}

- (void)onTimer:(NSTimer *)timer {
    if (self.isPlaying) {
        if (self.frames.count > 1) {
            [self.delegate showImage:self.frames[0]];
            [self.frames removeObjectAtIndex:0];
        } else {
            self.isPlaying = NO;
        }
        
    } else {
        self.isPlaying = (self.frames.count > 10);
    }
}

- (void)addImageFrame:(UIImage *)image withFPS:(NSNumber *)fps {
    if (!self.playerClock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSTimeInterval timeInterval = 1.0 / [fps floatValue];
            self.playerClock = [NSTimer scheduledTimerWithTimeInterval:timeInterval
                                                                target:self
                                                              selector:@selector(onTimer:)
                                                              userInfo:nil
                                                               repeats:YES];
        });
    }
    
    [self.frames addObject:image];
}

- (void) stopPlaying {
    if (self.playerClock) {
        [self.playerClock invalidate];
    }
}

@end
