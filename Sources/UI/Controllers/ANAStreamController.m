//
//  ANAStreamController.m
//  ANAStream
//
//  Created by Voropaev Vitali on 12.02.16.
//  Copyright © 2016 Anadea. All rights reserved.
//

#import "ANAStreamController.h"
#import <AVFoundation/AVFoundation.h>
#import "AVCaptureMultipeerVideoDataOutput.h"
#import "UIViewController+ANAAlert.h"

static const NSInteger kANADefaultStreamFPS = 10;

@interface ANAStreamController ()
@property (nonatomic, strong) IBOutlet UIButton *backButton;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, strong) UIView *previewView;

- (void)setFrameRate:(NSInteger)framerate onDevice:(AVCaptureDevice*)videoDevice;

- (IBAction)backButtonPressed:(id)sender;

@end

@implementation ANAStreamController

@dynamic previewView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.captureSession = [[AVCaptureSession alloc] init];
    
    // Setup the preview view
    self.captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    self.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.captureVideoPreviewLayer.frame = self.previewView.frame;
    [self.previewView.layer addSublayer:self.captureVideoPreviewLayer];
    [self.view bringSubviewToFront:self.backButton];

    // Create video device input
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if (videoDevice) {
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        [self.captureSession addInput:videoDeviceInput];
        
        // Create output
        AVCaptureMultipeerVideoDataOutput *multipeerVideoOutput = [[AVCaptureMultipeerVideoDataOutput alloc] initWithDisplayName:[[UIDevice currentDevice] name] withAssistant:NO];
        [self.captureSession addOutput:multipeerVideoOutput];
        [self setFrameRate:kANADefaultStreamFPS onDevice:videoDevice];
        [self.captureSession startRunning];
    } else {
        [self showAlertWithTitle:@"Error" message:@"No video device" handler:nil];
    }
}

- (void)dealloc {
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

#pragma mark -
#pragma mark Accessors

- (UIView *)previewView {
    return self.view;
}

#pragma mark -
#pragma mark Private

- (void)setFrameRate:(NSInteger) framerate onDevice:(AVCaptureDevice*) videoDevice {
    if ([videoDevice lockForConfiguration:nil]) {
        videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1,(int32_t)framerate);
        videoDevice.activeVideoMinFrameDuration = CMTimeMake(1,(int32_t)framerate);
        [videoDevice unlockForConfiguration];
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
