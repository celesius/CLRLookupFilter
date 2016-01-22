//
//  CLRGPUImageLookUpFilter.m
//  gpuBEEPS
//
//  Created by vk on 15/12/29.
//  Copyright © 2015年 clover. All rights reserved.
//

#import "CLRGPUImageLookUpFilter.h"
#import <GPUImage.h>
#import "CLRBackgroundImageFilter.h"

@interface CLRGPUImageLookUpFilter ()
{
    UIImageOrientation _imgOrientation;
}

@property (nonatomic, strong) GPUImagePicture *stillImageSource;
@property (nonatomic, strong) GPUImageLookupFilter *lookFilter;
//@property (nonatomic, strong) GPUImagePicture *lookupImageSource;
@property (nonatomic, weak)   UIImage *luImg;
@property (nonatomic, strong) CLRBackgroundImageFilter *clrBackgroundImageFilter;
@property (nonatomic, strong) GPUImagePicture *bgS1;
@property (nonatomic, strong) GPUImagePicture *bgS2;
@property (nonatomic, strong) GPUImageFilterGroup *mFilterGroup;

@end

@implementation CLRGPUImageLookUpFilter

- (id)initWithLookUpName:(NSString *)name
{
    if(self = [super init]) {
        //_lookupImageSource = [[GPUImagePicture alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@".png" ]]];  //[UIImage imageNamed:@"lookupYKS.png"]];
        _lookFilter = [[GPUImageLookupFilter alloc]init];
    }
    return self;
}

- (id)initWithLookUpImg:(UIImage *)lookupImg;
{
    if(self = [super init]) {
        _luImg = lookupImg;
        //_lookupImageSource = [[GPUImagePicture alloc]initWithImage:_luImg];//[[GPUImagePicture alloc] initWithImage: [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:name ofType:@".png" ]]];  //[UIImage imageNamed:@"lookupYKS.png"]];
        _lookFilter = [[GPUImageLookupFilter alloc]init];
        [self initBG];
    }
    return self;
}

- (id)init{
    if(self = [super init]) {
        _lookFilter = [[GPUImageLookupFilter alloc]init];
        [self initBG];
    }
    return self;
}

- (void)initBG
{
    self.clrBackgroundImageFilter = [[CLRBackgroundImageFilter alloc]init];
    //self.bgS1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blackboard1024" ofType:@"png"]]];
    self.bgS1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"黑色蒙板" ofType:@"png"]]];
    //self.bgS1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hudsonBackground" ofType:@"png"]]];
    
    
    self.bgS2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"softLight" ofType:@"png"]]];
    //self.bgS2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
    
    //NSArray
    //self.mFilterGroup = [[GPUImageFilterGroup alloc]init];
    //[self.mFilterGroup addTarget:self.clrBackgroundImageFilter atTextureLocation:1];
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
    [_getGPUImagePicture removeAllTargets];
    [_getGPUImagePicture addTarget:_lookFilter];
    [_lookupImageSource addTarget:_lookFilter];
}

- (UIImage *)getFilterResultBySetValue:(float) value
{
    _lookFilter.intensity = value;
    //[_lookFilter useNextFrameForImageCapture];  //jiangbo
    //[_stillImageSource processImage];
    /*
    GPUImageGrayscaleFilter *tf = [[GPUImageGrayscaleFilter alloc]init];
    [tf useNextFrameForImageCapture];
    [_lookFilter addTarget:tf];
     */
    NSLog(@"1111");
    [self.clrBackgroundImageFilter useNextFrameForImageCapture];
    [_lookFilter addTarget:self.clrBackgroundImageFilter];
    [_getGPUImagePicture processImage];
    [_lookupImageSource processImage];
    [self.bgS1 addTarget:self.clrBackgroundImageFilter atTextureLocation:1];
    [self.bgS2 addTarget:self.clrBackgroundImageFilter atTextureLocation:2];
    [self.bgS1 processImage];
    [self.bgS2 processImage];
    NSLog(@"%@",NSStringFromCGSize([_getGPUImagePicture outputImageSize]));
    NSLog(@"%@",NSStringFromCGSize([self.bgS1 outputImageSize]));
    NSLog(@"%@",NSStringFromCGSize([self.bgS2 outputImageSize]));
    //[self.clrBackgroundImageFilter useNextFrameForImageCapture];
    //UIImage *image =   [_lookFilter imageFromCurrentFramebuffer];
    UIImage *image = [self.clrBackgroundImageFilter imageFromCurrentFramebufferWithOrientation:_imgOrientation];
    //UIImage *image = [self.clrBackgroundImageFilter imageFromCurrentFramebufferWithOrientation:_imgOrientation];
    NSLog(@"%ld",(long)image.imageOrientation);
    [_lookFilter removeAllTargets];
    [self.bgS1 removeAllTargets];
    [self.bgS2 removeAllTargets];
    
    return image;
}

- (UIImage *)getFilterResultWithoutLightBySetValue:(float)value
{
    _lookFilter.intensity = value;
    [_lookFilter useNextFrameForImageCapture];  //jiangbo
    [_getGPUImagePicture processImage];
    [_lookupImageSource processImage];
    UIImage *image = [_lookFilter  imageFromCurrentFramebufferWithOrientation:_imgOrientation];
    return image;
}

- (void)removeFrameBuffer
{
    [self.bgS1 removeOutputFramebuffer];
    [self.bgS2 removeOutputFramebuffer];
}

- (void)dealloc
{
    //[super dealloc];
    NSLog(@"dealloc CLRGPUImageLookUpFilter ");
}
@end
