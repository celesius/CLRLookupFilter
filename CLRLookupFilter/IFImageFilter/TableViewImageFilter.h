//
//  ImageFilter.h
//  cloverGPUImage
//
//  Created by vk on 15/6/18.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

//#import "GPUImageStillCamera.h"
//#import <GPUImage/GPUImageStillCamera.h>
#import <GPUImage.h>
#import "IFImageFilter.h"
#import "InstaFilters.h"

@protocol TableViewImageFilterDelegate;

@interface TableViewImageFilter : GPUImageView

@property (strong, readonly) GPUImageView *gpuImageView;
@property (nonatomic,copy) void(^tableViewBlock)(NSMutableArray *imageArray);

//-(id)initWithImageSize:(CGRect) imageRect highVideoQuality:(BOOL)isHighQuality;

-(id)initWithImageSize:(CGRect) imageRect highVideoQuality:(BOOL)isHighQuality andImage:(UIImage *)srcImage tableViewBlock:(void (^)(NSMutableArray *imageArray))tableViewBlock ; //test
-(void) makeTableViewImage; //设置生成TableView的原图，并且执行算法

@property(nonatomic,assign) id<TableViewImageFilterDelegate> chdelegate;

//-(void) setI;

@end

@protocol TableViewImageFilterDelegate<GPUImageVideoCameraDelegate>
@optional
//-(void) getFilterImage:(UIImage *)filterImage;
-(void) getTabelViewImageArray:(NSMutableArray *)imageArray;  //在这里返回TableView需要的一系列小图
-(void) getTabelViewImage:(UIImage *)image;
@end