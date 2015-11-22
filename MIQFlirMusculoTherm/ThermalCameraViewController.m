//
//  ThermalCameraViewController.m
//  MIQFlirMusculoTherm
//
//  Created by XianLi on 21/11/2015.
//  Copyright © 2015 XianLi. All rights reserved.
//

#import "ThermalCameraViewController.h"
#import <FLIROneSDK/FLIROneSDK.h>
#import <FLIROneSDK/FLIROneSDKLibraryViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <FLIROneSDK/FLIROneSDKUIImage.h>
#import <FLIROneSDK/FLIROneSDKSimulation.h>
#import "ThermalDataUploader.h"
#import "WorkOutTimerViewController.h"
#import "MuscleGroupPoint.h"
#import "WorkOutResultViewController.h"

@interface ThermalCameraViewController () <FLIROneSDKImageReceiverDelegate, FLIROneSDKStreamManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView * thermalIV;
@property (strong, nonatomic) UIImage *visualJPEGImage;
@property (strong, nonatomic) UIImage *radiometricImage;
@property (strong, nonatomic) UIImage *thermalImage;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;

@property (nonatomic) BOOL connected;

@end

@implementation ThermalCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.thermalIV.userInteractionEnabled = YES;
    self.thermalData.musclePoints = [MuscleGroupPoint createPointArrForTypeLeg];
    for (MuscleGroupPoint *p in self.thermalData.musclePoints) {
        [self.thermalIV addSubview:p.view];
        p.view.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [p.view addGestureRecognizer:panGr];
    }
    
    [[FLIROneSDKStreamManager sharedInstance] addDelegate:self];
    [self setImgFormatOptions];
    [self connectSimulator];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_nav"]];
    self.navigationItem.titleView = imageView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.thermalData.imgViewSize = CGSizeMake(self.thermalIV.bounds.size.width, self.thermalIV.bounds.size.height);
    self.photoButton.selected = NO;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.thermalIV];
    NSLog(@"translation = %@", NSStringFromCGPoint(translation));
    
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.thermalIV];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self disconnectSimulator];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImgFormatOptions
{
    [FLIROneSDKStreamManager sharedInstance].imageOptions = FLIROneSDKImageOptionsVisualJPEGImage |FLIROneSDKImageOptionsThermalRadiometricKelvinImage | FLIROneSDKImageOptionsThermalLinearFlux14BitImage | FLIROneSDKImageOptionsThermalRGBA8888Image;
}

#pragma mark - stream man delegate
- (void)FLIROneSDKDidConnect
{
    self.connected = YES;
}
- (void)FLIROneSDKDidDisconnect
{
   self.connected = NO;
}

- (void)connectSimulator{
//    [[FLIROneSDKSimulation sharedInstance] connectWithFrameBundleName:@"sampleframes_hq" withBatteryChargePercentage:@42];
}

- (void)disconnectSimulator{
//    [[FLIROneSDKSimulation sharedInstance] disconnect];
}

- (void)updateUI
{
    if (self.photoButton.selected) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.thermalIV.image = self.thermalImage;
    });
}

- (BOOL)isVCOnTop
{
    return self.navigationController.topViewController == self;
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermalRGBA8888Image:(NSData *)thermalImage imageSize:(CGSize)size{
    if (![self isVCOnTop]) {
        return;
    }
    
    //NSLog(@"DID RECEIVE didReceiveThermalRGBA8888Image");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.thermalImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRGBA8888Image andData:thermalImage andSize:size];
        if (!self.photoButton.selected) {
            self.thermalData.img = [self.thermalImage copy];
        }
        [self updateUI];
    });
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveThermal14BitLinearFluxImage:(NSData *)linearFluxImage imageSize:(CGSize)size {
    if (![self isVCOnTop]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.radiometricImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalLinearFlux14BitImage andData:linearFluxImage andSize:size];
        [self updateUI];
    });
}

- (void)FLIROneSDKDelegateManager:(FLIROneSDKDelegateManager *)delegateManager didReceiveRadiometricData:(NSData *)radiometricData imageSize:(CGSize)size {
    
    if (![self isVCOnTop]) {
        return;
    }
    
    @synchronized(self) {
        self.thermalData.data = radiometricData;
        self.thermalData.size = size;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.radiometricImage = [FLIROneSDKUIImage imageWithFormat:FLIROneSDKImageOptionsThermalRadiometricKelvinImage andData:radiometricData andSize:size];
        [self updateUI];
    });
}

- (ThermalData *)thermalData
{
    if (!_thermalData) {
        _thermalData = [[ThermalData alloc] init];
    }
    return _thermalData;
}

- (void)setWorkoutType:(NSInteger)workoutType
{
    _workoutType = workoutType;
    self.thermalData.workoutType = workoutType;
}

- (IBAction)photoButtonTapped:(id)sender
{
    self.photoButton.selected = YES;
    if (!_isPost) {
        [MuscleGroupPoint saveLocationForPointArr:self.thermalData.musclePoints];
        [self.thermalData prepareForUpload];
        [ThermalDataUploader sharedInstance].preData = self.thermalData;
        WorkOutTimerViewController *timerVC = [[WorkOutTimerViewController alloc] init];
        [self.navigationController pushViewController:timerVC animated:YES];
    } else {
        [MuscleGroupPoint saveLocationForPointArr:self.thermalData.musclePoints];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.frame = self.view.bounds;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        
        [self.thermalData prepareForUpload];
        [ThermalDataUploader sharedInstance].postData = self.thermalData;
        
        [[ThermalDataUploader sharedInstance] postWithSuccess:^(NSDictionary *resultDict) {
            NSDictionary *dataDict = resultDict[@"data"];
            WorkOutResultViewController *resultVC = [[WorkOutResultViewController alloc] init];
            resultVC.title = dataDict[@"title"];
            resultVC.body = dataDict[@"body"];
            resultVC.shareURL = dataDict[@"endpoint"];
            resultVC.preImg = [ThermalDataUploader sharedInstance].preData.img;
            resultVC.postImg = [ThermalDataUploader sharedInstance].postData.img;
            dispatch_async(dispatch_get_main_queue(), ^{
                [activityView removeFromSuperview];
                [self.navigationController pushViewController:resultVC animated:YES];
            });
        } failure:^(NSError *error) {
        }];
         
    }
}

@end
