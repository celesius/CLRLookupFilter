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

@end

@implementation CLRImageFilter

- (id)initWithImgViewRect:(CGRect)imgViewRect
{
    if(self = [super init]) {
        self.iFImageFilter = [[ImageFilter alloc]initWithImageSize:imgViewRect highVideoQuality:YES];
        self.iFImageFilter.chdelegate = self;
    }
    return self;
}

- (void)setSrcImage:(UIImage *)srcImage
{
    _srcImage = srcImage;
    [self.iFImageFilter resetRawImage:srcImage];
}

- (void)getFilterImage:(UIImage *)filterImage
{
        if(self.clrFilterBlock){
            self.clrFilterBlock(filterImage);
        }
}

- (void)switchFilter:(IFFilterType)type
{
    GPUImagePicture *gpuImagePicture = [[GPUImagePicture alloc]initWithImage:self.srcImage];
    UIImageOrientation imageOrientation = self.srcImage.imageOrientation;
    
    if(type < CLR_LOOKUP_BAIXI_FILTER){
        [self.iFImageFilter switchFilter:type];
    }else{
        float rang;
        switch (type) {
            case CLR_LOOKUP_BAIXI_FILTER:
                self.lookupImageFilter = [[CLRGPUImageLookUpFilter alloc]initWithLookUpImg:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"白皙" ofType:@"png"]]];
                //self.lookupImageFilter.filterImg = self.srcImage;
                self.lookupImageFilter.getGPUImagePicture = gpuImagePicture;
                self.lookupImageFilter.imgOrientation = imageOrientation;
                rang = 0.5;
                break;
             case CLR_LOOKUP_LENGYAN_FILTER:
                self.lookupImageFilter = [[CLRGPUImageLookUpFilter alloc]initWithLookUpImg:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"冷艳" ofType:@"png"]]];
                //self.lookupImageFilter.filterImg = self.srcImage;
                self.lookupImageFilter.getGPUImagePicture = gpuImagePicture;
                self.lookupImageFilter.imgOrientation = imageOrientation;
                rang = 0.5;
                break;   
                
            default:
                break;
        }
        
        if(self.clrFilterBlock){
            self.clrFilterBlock( [self.lookupImageFilter getFilterResultBySetValue:0.5] );
        }
        
    }
}

- (void)dealloc
{
    NSLog(@"dealloc CLRImageFilter");
}

@end
