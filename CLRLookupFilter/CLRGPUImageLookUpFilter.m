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
@property (nonatomic, weak)   UIImage *luImg;

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
        _luImg = lookupImg;
        _lookupImageSource = [[GPUImagePicture alloc]initWithImage:_luImg];//[[GPUImagePicture alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@".png" ]]];  //[UIImage imageNamed:@"lookupYKS.png"]];
        _lookFilter = [[GPUImageLookupFilter alloc]init];
    }
    return self;
}

- (void) setFilterImg:(UIImage *)filterImg
{
    _filterImg = filterImg;
    _imgOrientation = _filterImg.imageOrientation;
    if(self.stillImageSource){
        self.stillImageSource = nil;
        _stillImageSource = [[GPUImagePicture alloc]initWithImage:_filterImg];
    }
    else
        _stillImageSource = [[GPUImagePicture alloc]initWithImage:_filterImg];
        
    [_stillImageSource addTarget:_lookFilter];
    [_lookupImageSource addTarget:_lookFilter];
}

- (void) setGetGPUImagePicture:(GPUImagePicture *)getGPUImagePicture
{
    _getGPUImagePicture = getGPUImagePicture;
    [_getGPUImagePicture addTarget:_lookFilter];
    [_lookupImageSource addTarget:_lookFilter];
}

- (UIImage *)getFilterResultBySetValue:(float) value
{
    _lookFilter.intensity = value;
    [_lookFilter useNextFrameForImageCapture];
    //[_stillImageSource processImage];
    [_getGPUImagePicture processImage];
    [_lookupImageSource processImage];
//     UIImage *image =   [_lookFilter imageFromCurrentFramebuffer];
     UIImage *image = [_lookFilter imageFromCurrentFramebufferWithOrientation:_imgOrientation];
    _stillImageSource = nil;
    NSLog(@"%ld",(long)image.imageOrientation);
    return image;
}

- (void)dealloc
{
    //[super dealloc];
    NSLog(@"dealloc CLRGPUImageLookUpFilter ");
}
@end
