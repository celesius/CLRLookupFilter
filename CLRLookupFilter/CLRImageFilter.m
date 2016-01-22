//
//  CLRImageFilter.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/19.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRImageFilter.h"
#import "ImageFilter.h"
#import "CLRGPUImageLookUpFilter.h"

@interface CLRImageFilter () <ImageFilterDelegate>

@property (nonatomic) ImageFilter *iFImageFilter;
@property (nonatomic) CLRGPUImageLookUpFilter *lookupImageFilter;
@property (nonatomic) GPUImagePicture *gpuImagePicture;
@property (nonatomic) UIImageOrientation imageOrientation;
@property (nonatomic) GPUImagePicture *lookupPic;


@end

@implementation CLRImageFilter

- (id)initWithImgViewRect:(CGRect)imgViewRect
{
    if(self = [super init]) {
        self.iFImageFilter = [[ImageFilter alloc]initWithImageSize:imgViewRect highVideoQuality:YES];
        self.lookupImageFilter = [[CLRGPUImageLookUpFilter alloc]init];
        self.iFImageFilter.chdelegate = self;
        self.filterName = @"";
    }
    return self;
}

- (void)setSrcImage:(UIImage *)srcImage
{
    _srcImage = srcImage;
    //[self.iFImageFilter resetRawImage:srcImage];
    self.gpuImagePicture = [[GPUImagePicture alloc]initWithImage:self.srcImage];
    NSLog(@"gg%@",NSStringFromCGSize([self.gpuImagePicture outputImageSize]));
    self.imageOrientation = self.srcImage.imageOrientation;
}

- (void)getFilterImage:(UIImage *)filterImage
{
        if(self.clrFilterBlock){
            self.clrFilterBlock(filterImage);
        }
}

- (void)switchFilter:(IFFilterType)type
{
    if(type < CLR_LOOKUP_BAIXI_FILTER){
        self.iFImageFilter.stillImageSource = self.gpuImagePicture;
        self.iFImageFilter.imgOrientation = self.imageOrientation;
        [self.iFImageFilter switchFilter:type];
        self.filterName = @"";
    }else{
        float rang = 0.0;
        switch (type) {
            case CLR_LOOKUP_BAIXI_FILTER:
                self.filterName = @"白皙";
                rang = 0.5;
                break;
             case CLR_LOOKUP_LENGYAN_FILTER:
                self.filterName = @"冷艳";
                rang = 0.5;
                break;
            case CLR_LOOKUP_WEIMEI_FILTER:
                self.filterName = @"唯美";
                rang = 0.5;
                break;
            case CLR_LOOKUP_FUGU_FILTER:
                self.filterName = @"复古";
                rang = 0.5;
                break;
            case CLR_LOOKUP_MENGHUAN_FILTER:
                self.filterName = @"梦幻";
                rang = 0.5;
                break;
            case CLR_LOOKUP_LUOKEKE_FILTER:
                self.filterName = @"洛可可";
                rang = 0.7;
                break;
            case CLR_LOOKUP_QINGXI_FILTER:
                self.filterName = @"清晰";
                rang = 0.5;
                break;
            case CLR_LOOKUP_HONGRUN_FILTER:
                self.filterName = @"红润";
                rang = 0.5;
                break;
            case CLR_LOOKUP_HUAYAN_FILTER:
                self.filterName = @"花颜";
                rang = 0.5;
                break;
            case CLR_LOOKUP_YINGCAI_FILTER:
                self.filterName = @"萤彩";
                rang = 0.7;
                break;
            case CLR_LOOKUP_FEIYAN_FILTER:
                self.filterName = @"霏颜";
                rang = 0.5;
                break;
            default:
                break;
        }
        
        //self.lookupImageFilter = [[CLRGPUImageLookUpFilter alloc]initWithLookUpImg:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.filterName ofType:@"png"]]];
        self.lookupPic = [[GPUImagePicture alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.filterName ofType:@"png"]]];
        self.lookupImageFilter.lookupImageSource = self.lookupPic;
        self.lookupImageFilter.getGPUImagePicture = self.gpuImagePicture;
        self.lookupImageFilter.imgOrientation = self.imageOrientation;
        
        if(self.clrFilterBlock){
            self.clrFilterBlock( [self.lookupImageFilter getFilterResultBySetValue:rang] );
            self.imageNoLight = [self.lookupImageFilter getFilterResultWithoutLightBySetValue:rang];
        }
        
    }
}

- (void)dealloc
{
    NSLog(@"dealloc CLRImageFilter");
    //[self.gpuImagePicture removeAllTargets];
    [self.gpuImagePicture removeOutputFramebuffer];
}

@end
