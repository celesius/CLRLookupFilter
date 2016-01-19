//
//  CLRGPUImageVC.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/14.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRGPUImageVC.h"
#import "CLRiOSPlug.h"
#import <GPUImage.h>
#import "CLRGPUImageLookUpFilter.h"
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>

@interface CLRGPUImageVC() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CLRGPUImageLookUpFilter *filter;
    UIImagePickerController *ipc;
}

@property (nonatomic, strong) UIImageView *dispView;
@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) UIImage *processedImg;
@property (nonatomic, strong) UIImage *loopUpImg;
@property (nonatomic, strong) UISlider *loopUpSlider;
@property (nonatomic, strong) UILabel *sliderLabel;
@property (nonatomic, strong) UILabel *nameLabel;


@end

@implementation CLRGPUImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    float imgWH = self.getImage.size.width / self.getImage.size.height;
    self.dispView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([CLRiOSPlug screenInfo]), CGRectGetWidth([CLRiOSPlug screenInfo])/imgWH)];
    self.dispView.image = self.getImage;//[self processImage:self.getImage];//self.getImage;
    self.dispView.center = self.view.center;
    [self.view addSubview:self.dispView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 10, 100, 40);
    backButton.backgroundColor = [UIColor grayColor];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth([CLRiOSPlug screenInfo]) - 200, 10, 200, 40)];
    self.nameLabel.backgroundColor = [UIColor grayColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.nameLabel];
    
    
    self.loopUpSlider = [[UISlider alloc]initWithFrame:CGRectMake((CGRectGetWidth([CLRiOSPlug screenInfo]) - 250.0)/2.0 - 30, CGRectGetHeight([CLRiOSPlug screenInfo]) - 100, 250, 30)];
    self.loopUpSlider.minimumValue = 0.0;
    self.loopUpSlider.maximumValue = 1.0;
    self.loopUpSlider.value = 1.0;
    [self.loopUpSlider addTarget:self action:@selector(loopUpSliderFoo:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.loopUpSlider];
   
    self.sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.loopUpSlider.frame) + 10, CGRectGetMinY(self.loopUpSlider.frame) , 60, 30)];
    self.sliderLabel.textColor = [UIColor whiteColor];
    NSString *labelText = [NSString stringWithFormat:@"%2d", (int)(self.loopUpSlider.value*100) ];
    [self.sliderLabel setText:labelText];
    [self.view addSubview:self.sliderLabel];
    
    
    UIButton *selectLookupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectLookupButton setTitle:@"来个滤镜" forState:UIControlStateNormal];
    selectLookupButton.frame = CGRectMake(0, CGRectGetHeight([CLRiOSPlug screenInfo]) - 50, CGRectGetWidth([CLRiOSPlug screenInfo]), 50);
    selectLookupButton.backgroundColor = [UIColor grayColor];
    [selectLookupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectLookupButton addTarget:self action:@selector(selectLookupButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectLookupButton];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)processImage:(UIImage *)srcImg
{
//    filter = [[CLRGPUImageLookUpFilter alloc]initWithLookUpName:@"淡黄色"];
    filter = [[CLRGPUImageLookUpFilter alloc]initWithLookUpImg:self.loopUpImg];
    filter.filterImg = srcImg;
    self.processedImg = [filter getFilterResultBySetValue:self.loopUpSlider.value];
    self.dispView.image = self.processedImg;
}

- (void)backButtonFoo:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    _getImage = nil;
    filter = nil;
}

- (void)selectLookupButtonFoo:(id)sender
{
    ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)loopUpSliderFoo:(id)sender
{
    if(self.processedImg){
        self.processedImg = [filter getFilterResultBySetValue:self.loopUpSlider.value];
        self.dispView.image = self.processedImg;
    }
    NSString *labelText = [NSString stringWithFormat:@"%2d", (int)(self.loopUpSlider.value*100) ];
    [self.sliderLabel setText:labelText];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    CLRGPUImageVC* __weak weakself = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        [weakself processImage:weakself.getImage];
        
        }];
        //[picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIImage *bufferImg =[info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.loopUpImg = bufferImg;//  [UIImage imageWithCGImage:bufferImg.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp] ;
  
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
   
    NSArray *array = [[NSArray alloc]initWithContentsOfURL:url];
    
    PHAsset *asset;
    //asset =   [PHAsset fetchAssetsWithALAssetURLs:array options:nil];  //[PHAsset fetchAssetsWithALAssetURLs:array options:nil];
    asset = [[PHAsset fetchAssetsWithALAssetURLs:@[info[@"UIImagePickerControllerReferenceURL"]] options:nil] lastObject];
    
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
    
    [self.nameLabel setText:orgFilename];
    
    //NSString *name = PHAssetResource
    //PHAssetResource *rr = [[PHAssetResource assetResourcesForAsset:asset] lastObject];
    //NSString *name = [rr assetLocalIdentifier];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint touchPoint = [aTouch locationInView:self.dispView];
    if(CGRectContainsPoint(self.dispView.bounds, touchPoint)) {
        self.dispView.image = self.getImage;
    }

}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint touchPoint = [aTouch locationInView:self.dispView];
    //if(CGRectContainsPoint(self.dispView.bounds, touchPoint)) {
    if(self.processedImg){
        self.dispView.image = self.processedImg;
    }
    //}
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

- (void)dealloc
{
    NSLog(@"dealloc CLRGPUImageVC");
}

@end
