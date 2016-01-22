//
//  CLRImageFilter.h
//  CLRLookupFilter
//
//  Created by vk on 16/1/19.
//  Copyright © 2016年 clover. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IFImageFilter/InstaFilters.h"

@interface CLRImageFilter : NSObject

@property (nonatomic, weak) UIImage *srcImage;
@property (nonatomic) UIImage *imageNoLight;

@property (nonatomic, copy) void (^clrFilterBlock)(UIImage *outImg);
@property (nonatomic) NSString *filterName;
//@property (nonatomic, copy) void (^clrFilterBlockNoLight)(UIImage *outImg);

- (id)initWithImgViewRect:(CGRect)imgViewRect;

- (void) switchFilter:(IFFilterType)type;

@end
