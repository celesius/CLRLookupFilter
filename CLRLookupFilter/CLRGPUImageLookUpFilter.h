//
//  CLRGPUImageLookUpFilter.h
//  gpuBEEPS
//
//  Created by vk on 15/12/29.
//  Copyright © 2015年 clover. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLRGPUImageLookUpFilter : NSObject

@property (nonatomic, weak) UIImage *filterImg;

- (id)initWithLookUpName:(NSString *)name;
- (id)initWithLookUpImg:(UIImage *)lookupImg;
- (UIImage *)getFilterResultBySetValue:(float) value;

@end
