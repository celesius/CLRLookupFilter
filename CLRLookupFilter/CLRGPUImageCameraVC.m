//
//  CLRGPUImageCameraVC.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/22.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <GPUImage.h>
#import "CLRGPUImageCameraVC.h"
#import "CLRiOSPlug.h"
#import "CLRSwitchFilterTestView.h"

@interface CLRGPUImageCameraVC()

@property (nonatomic)GPUImageStillCamera *gpuCamera;

@end

@implementation CLRGPUImageCameraVC

- (id)init
{
    if(self = [super init]){
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gpuCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPresetPhoto cameraPosition:AVCaptureDevicePositionFront];
    self.gpuCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    CGFloat viewWidth = CGRectGetWidth([CLRiOSPlug screenInfo]);
    CGFloat viewHight = viewWidth*4.0/3.0;
    //GPUImageView *filteredVideoView = [[GPUImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHight)];
    CLRSwitchFilterTestView *filteredVideoView = [[CLRSwitchFilterTestView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHight)];
    [self.view addSubview:filteredVideoView];
    
    GPUImageGrayscaleFilter *gFilter = [[GPUImageGrayscaleFilter alloc]init];
    filteredVideoView.center = self.view.center;
//    [self.gpuCamera addTarget:gFilter];
//    [gFilter addTarget:filteredVideoView];
    [self.gpuCamera addTarget:filteredVideoView];

    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 10, 100, 40);
    backButton.backgroundColor = [UIColor grayColor];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.gpuCamera startCameraCapture];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.gpuCamera stopCameraCapture];
}
- (void)backButtonFoo:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"didReceiveMemoryWarning CLRGPUImageCameraVC");
}

@end
