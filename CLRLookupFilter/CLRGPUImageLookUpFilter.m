//
//  CLRGPUImageLookUpFilter.m
//  gpuBEEPS
//
//  Created by vk on 15/12/29.
//  Copyright © 2015年 clover. All rights reserved.
//

#import "CLRGPUImageLookUpFilter.h"
#import <GPUImage.h>

@interface CLRGPUImageLookUpFilter ()
{
    UIImageOrientation _imgOrientation;
    
}

@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) GPUImageLookupFilter *lookFilter;
@property (nonatomic, strong) GPUImagePicture *lookupImageSource;

@end

@implementation CLRGPUImageLookUpFilter

- (id)initWithLookUpName:(NSString *)name
{
    if(self = [super init]) {
        _lookupImageSource = [[GPUImagePicture alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@".png" ]]];  //[UIImage imageNamed:@"lookupYKS.png"]];
        _lookFilter = [[GPUImageLookupFilter alloc]init];
    }
    return self;
}

- (id)initWithLookUpImg:(UIImage *)lookupImg;
{
    if(self = [super init]) {
        _lookupImageSource = [[GPUImagePicture alloc]initWithImage:lookupImg];//[[GPUImagePicture alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@".png" ]]];  //[UIImage imageNamed:@"lookupYKS.png"]];
        _lookFilter = [[GPUImageLookupFilter alloc]init];
    }
    return self;
}


- (void) setFilterImg:(UIImage *)filterImg
{
    _filterImg = filterImg;
    _imgOrientation = _filterImg.imageOrientation;
    _stillImageSource = [[GPUImagePicture alloc]initWithImage:_filterImg];
 //   _stillImageSource = [[GPUImagePicture alloc]initWithCGImage:_filterImg.CGImage ];
    [_stillImageSource addTarget:_lookFilter];
    [_lookupImageSource addTarget:_lookFilter];
}

- (UIImage *)getFilterResultBySetValue:(float) value
{
    _lookFilter.intensity = value;
    [_lookFilter useNextFrameForImageCapture];
    [_stillImageSource processImage];
    [_lookupImageSource processImage];
//     UIImage *image =   [_lookFilter imageFromCurrentFramebuffer];
     UIImage *image = [_lookFilter imageFromCurrentFramebufferWithOrientation:_imgOrientation];
    NSLog(@"%ld",(long)image.imageOrientation);
    return image;
}

- (void)dealloc
{
    //[super dealloc];
    NSLog(@"dealloc");
}
@end
