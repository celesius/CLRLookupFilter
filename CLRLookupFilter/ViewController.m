//
//  ViewController.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/14.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "ViewController.h"
#import "CLRiOSPlug.h"
#import "CLRGPUImageVC.h"
#import "CLRGPUImageCameraVC.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController *ipc;
    UIPopoverController *popover;
    //CLRGPUImageVC *_clrGPUImageVC;
}

@property (nonatomic, strong) UIImage *getImage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *openGalleryButton = [UIButton buttonWithType:UIButtonTypeSystem];
    openGalleryButton.frame = CGRectMake((CGRectGetWidth([CLRiOSPlug screenInfo]) - 100)/2.0 , CGRectGetHeight([CLRiOSPlug screenInfo])/2.0 - 60, 100, 50);
    openGalleryButton.backgroundColor = [UIColor grayColor];
    [openGalleryButton setTitle:@"来个照片" forState:UIControlStateNormal];
    [openGalleryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openGalleryButton addTarget:self action:@selector(openGalleryButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openGalleryButton];

    UIButton *openCamera = [UIButton buttonWithType:UIButtonTypeSystem];
    openCamera.frame = CGRectMake((CGRectGetWidth([CLRiOSPlug screenInfo]) - 100)/2.0 , CGRectGetHeight([CLRiOSPlug screenInfo])/2.0 + 60, 100, 50);
    openCamera.backgroundColor = [UIColor grayColor];
    [openCamera setTitle:@"打开相机" forState:UIControlStateNormal];
    [openCamera setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [openCamera addTarget:self action:@selector(openCameraButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openCamera];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) openGalleryButtonFoo:(id)sender
{
    ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)openCameraButtonFoo:(id)sender
{
    CLRGPUImageCameraVC *cameraVC = [[CLRGPUImageCameraVC alloc]init];
    [self.navigationController pushViewController:cameraVC animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //_clrGPUImageVC = nil;
    NSLog(@"viewDidAppear");
}

#pragma make - ImagePickerController Delegate
//- (void)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    ViewController * __weak weakself = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //[picker dismissViewControllerAnimated:YES completion:^{[weakself vcPush];}];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
   
    //UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    //NSLog(@"%ld",(long)img.imageOrientation);
    
    _getImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self vcPush];
    //_clrGPUImageVC = [[CLRGPUImageVC alloc]init];
    //_clrGPUImageVC.getImage = _getImage;
    //NSLog(@"getImage");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)vcPush
{
    NSLog(@"vcPush");
    //ipc = nil;
    
    CLRGPUImageVC *_clrGPUImageVC = [[CLRGPUImageVC alloc]init];
    _clrGPUImageVC.getImage = _getImage;
    [self.navigationController pushViewController:_clrGPUImageVC animated:YES];
    
    //[self.navigationController pushViewController:_clrGPUImageVC animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(viewController == self){
        NSLog(@"111");
    }
}

@end
