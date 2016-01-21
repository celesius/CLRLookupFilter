//
//  CLRGPUImageLookUpFilter.h
//  gpuBEEPS
//
//  Created by vk on 15/12/29.
//  Copyright © 2015年 clover. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GPUImagePicture;

@interface CLRGPUImageLookUpFilter : NSObject

@property (nonatomic, weak) UIImage *filterImg;
@property (nonatomic, weak) GPUImagePicture *getGPUImagePicture;
@property (nonatomic) UIImageOrientation imgOrientation;
/**
 *  用lookup Image图片的名字初始化
 *
 *  @param name lookup image的名称
 *
 *  @return self
 */
- (id)initWithLookUpName:(NSString *)name;
/**
 *  用传入的lookup Image 图片初始化
 *
 *  @param lookupImg 传入的lookup Image
 *
 *  @return self
 */
- (id)initWithLookUpImg:(UIImage *)lookupImg;

/**
 *  切换lookup Image
 *
 *  @param lookupImg 输入的lookup Image
 */
- (void)switchLookupImg:(UIImage *)lookupImg;
- (UIImage *)getFilterResultBySetValue:(float) value;

@end
