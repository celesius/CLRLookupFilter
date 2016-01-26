//
//  CLRSwitchFilterTestView.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/22.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRSwitchFilterTestView.h"

@interface CLRSwitchFilterTestView ()

@property (nonatomic) GPUImageView *gpuImageView;

@end

@implementation CLRSwitchFilterTestView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        GPUImageGrayscaleFilter *grayFilter = [[GPUImageGrayscaleFilter alloc]init];
        self.gpuImageView = [[GPUImageView alloc]initWithFrame:self.bounds];
        
        
        [self addSubview:self.gpuImageView];
    }
    return self;
}

@end
