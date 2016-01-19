//
//  ImageFilter.h
//  ImageFilter
//
//  Created by vk on 15/6/18.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IFImageFilter.h"
#import "InstaFilters.h"

//! Project version number for ImageFilter.
FOUNDATION_EXPORT double ImageFilterVersionNumber;

//! Project version string for ImageFilter.
FOUNDATION_EXPORT const unsigned char ImageFilterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ImageFilter/PublicHeader.h>


@protocol ImageFilterDelegate;

@interface ImageFilter : GPUImageView

@property (strong, readonly) GPUImageView *gpuImageView;

-(id)initWithImageSize:(CGRect) imageRect highVideoQuality:(BOOL)isHighQuality;

-(id)initWithImageSize:(CGRect) imageRect highVideoQuality:(BOOL)isHighQuality andImage:(UIImage *)srcImage; //test
-(void) resetRawImage:(UIImage *)srcImage;
-(void) SetFilter:(IFFilterType)type andSrcImage:(UIImage *)srcImage;
-(void) switchFilter:(IFFilterType)type;
-(void) saveImage;
-(void) resetGPUViewRect:(CGRect) setRect;

@property(nonatomic,assign) id<ImageFilterDelegate> chdelegate;

//-(void) setI;

@end

@protocol ImageFilterDelegate<GPUImageVideoCameraDelegate>
@optional
-(void) getFilterImage:(UIImage *)filterImage;
@end
