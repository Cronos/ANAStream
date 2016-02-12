//
//  ANAViewStreamController.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "ANAViewStreamController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ANAPeerPlayer.h"

@interface ANAViewStreamController () <MCSessionDelegate, ANAPeerPlayerDelegate>
@property (nonatomic, strong) IBOutlet UIImageView *streamView;
@property (nonatomic, strong) ANAPeerPlayer* player;

@end

@implementation ANAViewStreamController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.session.delegate = self;
}

- (void)dealloc {
    self.session.delegate = nil;
}

#pragma mark -
#pragma mark MCSessionDelegate Methods

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    switch (state) {
        case MCSessionStateConnected:
        {
            NSLog(@"PEER CONNECTED: %@", peerID.displayName);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.player = [ANAPeerPlayer new];
                self.player.delegate = self;
            });
        }
            break;
        
        case MCSessionStateConnecting:
            NSLog(@"PEER CONNECTING: %@", peerID.displayName);
            break;
            
        case MCSessionStateNotConnected: {
            NSLog(@"PEER NOT CONNECTED: %@", peerID.displayName);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.player stopPlaying];
                self.player = nil;
                [self.navigationController popViewControllerAnimated:YES];
             });
            break;
        }
    }
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
        
    NSDictionary* dictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (dictionary) {
        UIImage* image = [UIImage imageWithData:dictionary[@"image"] scale:2.0];
        NSNumber* framesPerSecond = dictionary[@"framesPerSecond"];
        
        [self.player addImageFrame:image withFPS:framesPerSecond];
    }
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
}

#pragma mark -
#pragma mark ANAPeerPlayer delegate
    
- (void)showImage:(UIImage *)image {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.streamView.image = image;
    });
}

@end
