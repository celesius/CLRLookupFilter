//
//  ImageFilter.m
//  cloverGPUImage
//
//  Created by vk on 15/6/18.
//  Copyright (c) 2015年 quxiu8. All rights reserved.
//

#import "TableViewImageFilter.h"
#import "UIImage+IF.h"
#import "IFImageFilter.h"
//#import "IFVideoCamera.h"
#import "IFSutroFilter.h"
//#import "IFRotationFilter.h"
#import "IFAmaroFilter.h"
#import "IFNormalFilter.h"
#import "IFRiseFilter.h"
#import "IFHudsonFilter.h"
#import "IFXproIIFilter.h"
#import "IFSierraFilter.h"
#import "IFLomofiFilter.h"
#import "IFEarlybirdFilter.h"
#import "IFToasterFilter.h"
#import "IFBrannanFilter.h"
#import "IFInkwellFilter.h"
#import "IFWaldenFilter.h"
#import "IFHefeFilter.h"
#import "IFValenciaFilter.h"
#import "IFNashvilleFilter.h"
#import "IF1977Filter.h"
#import "IFLordKelvinFilter.h"


@interface TableViewImageFilter()

@property(nonatomic,strong)UIImage *rawImage;
@property (nonatomic, strong) GPUImageFilter *rotationFilter;
@property (nonatomic, strong) IFImageFilter *filter;
//@property (nonatomic, strong) GPUImageFilter *filter;
@property (nonatomic, strong) IFImageFilter *internalFilter;

@property (strong, readwrite) GPUImageView *gpuImageView;
@property (strong, readwrite) GPUImageView *gpuImageView_HD;

@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *sourcePicture3;
@property (nonatomic, strong) GPUImagePicture *sourcePicture4;
@property (nonatomic, strong) GPUImagePicture *sourcePicture5;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture3;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture4;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture5;

@property (nonatomic, strong) GPUImagePicture *stillImageSource;

@property (nonatomic, unsafe_unretained) IFFilterType currentFilterType;

@property (nonatomic, strong) dispatch_queue_t prepareFilterQueue;

@property (nonatomic, strong) NSMutableArray *tableImageArray;

@end

@implementation TableViewImageFilter


-(id)initWithImageSize:(CGRect) imageRect highVideoQuality:(BOOL)isHighQuality andImage:(UIImage *)srcImage tableViewBlock:(void (^)(NSMutableArray *imageArray))tableViewBlock
{
    if(self = [super init])
    {
        //self.outputImageOrientation = UIInterfaceOrientationPortrait;
        self.prepareFilterQueue = dispatch_queue_create("com.diwublog.prepareTableViewFilterQueue", NULL); //queue初始化
        self.rotationFilter = [[GPUImageFilter alloc]init];
        //[self addTarget:self.rotationFilter];
        
        self.filter = [[IFNormalFilter alloc] init];
        self.internalFilter = self.filter;
        
        [self.rotationFilter addTarget:self.filter];
        //[self addTarget:self.filter atTextureLocation:0];
        [self.filter disableSecondFrameCheck];
        [self.filter disableThirdFrameCheck];
        [self.filter disableFourthFrameCheck];
        [self.filter disableFifthFrameCheck];
        [self.filter disableSixthFrameCheck];
        
        CGSize imgSize = imageRect.size;
        
        //UIImage *interImg = [srcImage resizedImage:imgSize interpolationQuality:kCGInterpolationHigh];
        
        //self.rawImage = interImg;
        self.rawImage = [srcImage resizedImage:imgSize interpolationQuality:kCGInterpolationHigh];
        
        //        GPUImagePicture *gpuPic = [[GPUImagePicture alloc]initWithImage:srcImage];
        //
        //        [gpuPic addTarget:self.filter];
        //        [gpuPic processImage];
        //
        self.gpuImageView = [[GPUImageView alloc] initWithFrame:imageRect];
        
        [self.filter addTarget:self.gpuImageView];
        
        if (isHighQuality == YES) {
            self.gpuImageView.layer.contentsScale = 2.0f;
        } else {
            self.gpuImageView.layer.contentsScale = 2.0f; //让显示变得细腻，也会影响最终的存储 filter size   1 FBO = 375*375 2 FBO = 750*750 3 FBO = 750*1000
        }
        [self.filter addTarget:self.gpuImageView];  //这里填充的数据滤波之后的数据，用于显示
        
        self.gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[self.gpuImageView bounds]];
        self.gpuImageView_HD.backgroundColor = [UIColor grayColor];
        self.gpuImageView_HD.hidden = YES;
        [self.gpuImageView addSubview:self.gpuImageView_HD];
        self.tableImageArray = [[NSMutableArray alloc]init];
        self.tableViewBlock = tableViewBlock;
        // [self makeTableViewImage];
    }
    return self;
    
}

-(void) makeTableViewImage
{
    
    [self switchFilter:0];
    
}


//-(id)initWithImageSize:(CGRect) imageRect highVideoQuality:(BOOL)isHighQuality{
//    if(self = [super init])
//    {
//       // self.outputImageOrientation = UIInterfaceOrientationPortrait;
//        self.prepareFilterQueue = dispatch_queue_create("com.diwublog.prepareFilterQueue", NULL); //queue初始化
//        self.rotationFilter = [[GPUImageFilter alloc]init];
//       // [self addTarget:self.rotationFilter];
//
//        self.filter = [[IFNormalFilter alloc] init];
//        self.internalFilter = self.filter;
//
//        [self.rotationFilter addTarget:self.filter];
//        //[self addTarget:self.filter atTextureLocation:0];
//        [self.filter disableSecondFrameCheck];
//        [self.filter disableThirdFrameCheck];
//        [self.filter disableFourthFrameCheck];
//        [self.filter disableFifthFrameCheck];
//        [self.filter disableSixthFrameCheck];
//
//        self.gpuImageView = [[GPUImageView alloc] initWithFrame:imageRect];
//
//        [self.filter addTarget:self.gpuImageView];
//
//        if (isHighQuality == YES) {
//            self.gpuImageView.layer.contentsScale = 2.0f;
//        } else {
//            self.gpuImageView.layer.contentsScale = 2.0f; //让显示变得细腻，也会影响最终的存储 filter size   1 FBO = 375*375 2 FBO = 750*750 3 FBO = 750*1000
//        }
//        [self.filter addTarget:self.gpuImageView];  //这里填充的数据滤波之后的数据，用于显示
//
//        self.gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[self.gpuImageView bounds]];
//        self.gpuImageView_HD.backgroundColor = [UIColor grayColor];
//        self.gpuImageView_HD.hidden = YES;
//        [self.gpuImageView addSubview:self.gpuImageView_HD];
//
//    }
//    return self;
//}

-(void) SetFilter:(IFFilterType)type andSrcImage:(UIImage *)srcImage{
    self.rawImage = srcImage; //setRawImage
    [self switchFilter:type]; //切换滤镜
}

- (void)switchToNewFilter {
    
    if (self.stillImageSource == nil) {
        [self.rotationFilter removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.rotationFilter addTarget:self.filter];
    } else {
        [self.stillImageSource removeTarget:self.filter];
        self.filter = self.internalFilter;
        [self.stillImageSource addTarget:self.filter atTextureLocation:0];
    }
    
    switch (self.currentFilterType) {
        case IF_AMARO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_RISE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_HUDSON_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_XPROII_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter atTextureLocation:1];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter atTextureLocation:2];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_SIERRA_FILTER: {
            NSLog(@"IF_SIERRA_FILTER 1");
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter atTextureLocation:1];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter atTextureLocation:2];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter atTextureLocation:3];
            
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            
            //
            //            [self.sourcePicture1 processImage]; //jiangbo
            //            [self.sourcePicture1 addTarget:self.filter atTextureLocation:1];
            //            [self.sourcePicture2 processImage];
            //            [self.sourcePicture2 addTarget:self.filter atTextureLocation:2];
            //            [self.filter disableFourthFrameCheck];
            
            
            break;
        }
            
        case IF_LOMOFI_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_EARLYBIRD_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture1 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture4 processImage];
            [self.sourcePicture5 addTarget:self.filter];
            [self.sourcePicture5 processImage];
            
            break;
        }
            
        case IF_SUTRO_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 processImage];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 processImage];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_TOASTER_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 processImage];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 processImage];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_BRANNAN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 processImage];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 processImage];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_INKWELL_FILTER: {
            
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            [self.sourcePicture1 processImage]; //jiangbo
            [self.sourcePicture1 addTarget:self.filter atTextureLocation:1];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter atTextureLocation:2];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            
            break;
        }
            
        case IF_WALDEN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_HEFE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            self.sourcePicture3 = self.internalSourcePicture3;
            self.sourcePicture4 = self.internalSourcePicture4;
            self.sourcePicture5 = self.internalSourcePicture5;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.sourcePicture3 processImage];
            [self.sourcePicture3 addTarget:self.filter];
            [self.sourcePicture4 processImage];
            [self.sourcePicture4 addTarget:self.filter];
            [self.sourcePicture5 processImage];
            [self.sourcePicture5 addTarget:self.filter];
            
            break;
        }
            
        case IF_VALENCIA_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            break;
        }
            
        case IF_NASHVILLE_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            
            [self.filter disableThirdFrameCheck];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_1977_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            self.sourcePicture2 = self.internalSourcePicture2;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.sourcePicture2 processImage];
            [self.sourcePicture2 addTarget:self.filter];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_LORDKELVIN_FILTER: {
            self.sourcePicture1 = self.internalSourcePicture1;
            
            [self.sourcePicture1 processImage];
            [self.sourcePicture1 addTarget:self.filter];
            [self.filter disableThirdFrameCheck];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            
            break;
        }
            
        case IF_NORMAL_FILTER: {
            [self.filter disableSecondFrameCheck];
            [self.filter disableThirdFrameCheck];
            [self.filter disableFourthFrameCheck];
            [self.filter disableFifthFrameCheck];
            [self.filter disableSixthFrameCheck];
            break;
        }
            
        case CLR_LOOKUP_BAIXI_FILTER:{
            
            break;
        }
            
        default: {
            break;
        }
    }
    
    if (self.stillImageSource != nil) {
        self.gpuImageView_HD.hidden = NO;
        [self.filter addTarget:self.gpuImageView_HD];
        [self.filter useNextFrameForImageCapture];
        [self.stillImageSource processImage];
        UIImage *delegateImage = [self.filter imageFromCurrentFramebuffer];   //要这个完成后才能开始后一帧的处理，这个是静态Image的要求
        
        [self.tableImageArray addObject:delegateImage];
        
        if(self.chdelegate&& [self.chdelegate respondsToSelector:@selector(getTabelViewImage:)]){
            [self.chdelegate getTabelViewImage:delegateImage];
        }
        
        NSLog(@" tableImageArray Count = %lu",(unsigned long)[self.tableImageArray count]);
        if([self.tableImageArray count] !=  18 )
            [self switchFilter:(IFFilterType)[self.tableImageArray count]];
        else
        {
         
            if(self.tableViewBlock)
            {
                self.tableViewBlock(self.tableImageArray);
            }
            
            
            if(self.chdelegate && [self.chdelegate respondsToSelector:@selector(getTabelViewImageArray:)])
            {
                [self.chdelegate getTabelViewImageArray:self.tableImageArray];
            }
            
        }
        
        //        if(self.chdelegate && [self.chdelegate respondsToSelector:@selector(getFilterImage:)])
        //        {
        //            [self.chdelegate getFilterImage:delegateImage];
        //        }
        //    [self.stillImageSource removeAllTargets];
    } else {
        [self.filter addTarget:self.gpuImageView];
        
    }
}

- (void)forceSwitchToNewFilter:(IFFilterType)type {
    
    self.currentFilterType = type;
    
    dispatch_async(self.prepareFilterQueue, ^{
        switch (type) {
            case IF_AMARO_FILTER: {
                self.internalFilter = [[IFAmaroFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blackboard1024" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"amaroMap" ofType:@"png"]]];
                break;
            }
                
            case IF_NORMAL_FILTER: {
                self.internalFilter = [[IFNormalFilter alloc] init];
                break;
            }
                
            case IF_RISE_FILTER: {
                self.internalFilter = [[IFRiseFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"blackboard1024" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"riseMap" ofType:@"png"]]];
                
                break;
            }
                
            case IF_HUDSON_FILTER: {
                self.internalFilter = [[IFHudsonFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hudsonBackground" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hudsonMap" ofType:@"png"]]];
                
                break;
            }
                
            case IF_XPROII_FILTER: {
                NSLog(@"IF_XPROII_FILTER 2");
                self.internalFilter = [[IFXproIIFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"xproMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                
                break;
            }
                
            case IF_SIERRA_FILTER: {
                self.internalFilter = [[IFSierraFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sierraVignette" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"overlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sierraMap" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_LOMOFI_FILTER: {
                self.internalFilter = [[IFLomofiFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lomoMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_EARLYBIRD_FILTER: {
                self.internalFilter = [[IFEarlybirdFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlyBirdCurves" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlybirdOverlayMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlybirdBlowout" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"earlybirdMap" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_SUTRO_FILTER: {
                self.internalFilter = [[IFSutroFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sutroMetal" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"softLight" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sutroEdgeBurn" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"sutroCurves" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_TOASTER_FILTER: {
                self.internalFilter = [[IFToasterFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterMetal" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterSoftLight" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterCurves" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterOverlayMapWarm" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toasterColorShift" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_BRANNAN_FILTER: {
                self.internalFilter = [[IFBrannanFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanProcess" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanBlowout" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanContrast" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanLuma" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"brannanScreen" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_INKWELL_FILTER: {
                self.internalFilter = [[IFInkwellFilter alloc] init];
                // self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"inkwellMap" ofType:@"png"]]];
                self.internalSourcePicture1 = [[GPUImagePicture alloc]initWithImage:[UIImage imageNamed:@"inkwellMap.png"]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc]initWithImage:[UIImage imageNamed:@"vignetteMap.png"]];
                break;
            }
                
            case IF_WALDEN_FILTER: {
                self.internalFilter = [[IFWaldenFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"waldenMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"vignetteMap" ofType:@"png"]]];
                
                break;
            }
                
            case IF_HEFE_FILTER: {
                self.internalFilter = [[IFHefeFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edgeBurn" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeMap" ofType:@"png"]]];
                self.internalSourcePicture3 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeGradientMap" ofType:@"png"]]];
                self.internalSourcePicture4 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeSoftLight" ofType:@"png"]]];
                self.internalSourcePicture5 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hefeMetal" ofType:@"png"]]];
                
                
                break;
            }
                
            case IF_VALENCIA_FILTER: {
                self.internalFilter = [[IFValenciaFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"valenciaMap" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"valenciaGradientMap" ofType:@"png"]]];
                
                break;
            }
                
            case IF_NASHVILLE_FILTER: {
                self.internalFilter = [[IFNashvilleFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"nashvilleMap" ofType:@"png"]]];
                
                break;
            }
                
            case IF_1977_FILTER: {
                self.internalFilter = [[IF1977Filter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1977map" ofType:@"png"]]];
                self.internalSourcePicture2 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1977blowout" ofType:@"png"]]];
                
                break;
            }
                
            case IF_LORDKELVIN_FILTER: {
                self.internalFilter = [[IFLordKelvinFilter alloc] init];
                self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"kelvinMap" ofType:@"png"]]];
                
                break;
            }
                
            default:
                break;
        }
        
        [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
        
    });
}

- (void)switchFilter:(IFFilterType)type {
    
    if ((self.rawImage != nil) && (self.stillImageSource == nil)) {
        
        // This is the state when we just switched from live view to album photo view
        [self.rotationFilter removeTarget:self.filter];
        //UIImage *tempDispImg = self.rawImage;
        NSLog(@"rawImage w = %f, rawImage h = %f",self.rawImage.size.width,self.rawImage.size.height);
        self.stillImageSource = [[GPUImagePicture alloc] initWithImage:self.rawImage];
        [self.stillImageSource addTarget:self.filter atTextureLocation:0];
    } else {
        [self.stillImageSource removeAllTargets]; //jiangbo add
        if (self.currentFilterType == type) {
            return;
        }
    }
    
    [self forceSwitchToNewFilter:type];
}

-(void) saveImage
{
    //
    //    [self capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error){
    //        NSData *dataForJPEGFile = UIImageJPEGRepresentation(processedImage, 0.8);
    //
    //        // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //        // NSString *documentsDirectory = [paths objectAtIndex:0];
    //        //NSError *error2 = nil;
    //        //if (![dataForJPEGFile writeToFile:[documentsDirectory stringByAppendingPathComponent:@"FilteredPhoto.jpg"] options:NSAtomicWrite error:&error2])
    //        //{
    //        //return;
    //        //}
    //
    //        UIImage *imageWillSave = [UIImage imageWithData:dataForJPEGFile];
    //        UIImageWriteToSavedPhotosAlbum(imageWillSave, nil, nil, nil);
    //    }];
}

-(void) resetGPUViewRect:(CGRect) setRect
{
    self.gpuImageView.frame = setRect;
    self.gpuImageView_HD.frame = self.gpuImageView.bounds;
}

//-(void) makeTableViewImage:(UIImage *)srcImage
//{
//    UIImage *tempImg =  [[UIImage alloc]initWithCGImage:[self.rawImage CGImage]]; //self.rawImage;
//    self.rawImage = srcImage;
//
//    for(int i = 0;i<18;i++)
//    {
//        [self switchFilter:i];
//    }
//    self.rawImage = tempImg;
//
//}


//- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality screenSize:(CGRect)screenSize{
//    if (!(self = [super initWithSessionPreset:sessionPreset cameraPosition:cameraPosition]))  //git 上标准的GPUImageVideoCamera初始化方法
//    {
//        return nil;
//    }
//
//    self.outputImageOrientation = UIInterfaceOrientationPortrait;
//
//    //    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
//    //    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
//    //    [self.stillImageOutput setOutputSettings:outputSettings];
//    //    [self.captureSession addOutput:stillImageOutput];
//
//    prepareFilterQueue = dispatch_queue_create("com.diwublog.prepareFilterQueue", NULL); //queue初始化
//
//    //rotationFilter = [[GPUImageFilter alloc] initWithRotation:kGPUImageRotateRight];
//    rotationFilter = [[GPUImageFilter alloc]init];
//    [self addTarget:rotationFilter];
//
//    self.filter = [[IFNormalFilter alloc] init];
//    self.internalFilter = self.filter;
//
//    [rotationFilter addTarget:filter];
//    //[self addTarget:self.filter atTextureLocation:0];
//    [self.filter disableSecondFrameCheck];
//    [self.filter disableThirdFrameCheck];
//    [self.filter disableFourthFrameCheck];
//    [self.filter disableFifthFrameCheck];
//    [self.filter disableSixthFrameCheck];
//
//
//
//    // gpuImageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 45, 320, 320)];
//    gpuImageView = [[GPUImageView alloc] initWithFrame:screenSize];  //这个窗口用于显示，同样也会影响存储，存储的图像是这个设置的2倍。这个设置应该是在设置buffer的大小 buffer是可以设置为很大的，这样可以提高图像分辨率🐰
//    gpuImageView.backgroundColor = [UIColor redColor];
//    if (isHighQuality == YES) {
//        gpuImageView.layer.contentsScale = 2.0f;
//    } else {
//        gpuImageView.layer.contentsScale = 2.0f; //让显示变得细腻，也会影响最终的存储 filter size   1 FBO = 375*375 2 FBO = 750*750 3 FBO = 750*1000
//    }
//    [filter addTarget:gpuImageView];  //这里填充的数据滤波之后的数据，用于显示
//
//    gpuImageView_HD = [[GPUImageView alloc] initWithFrame:[gpuImageView bounds]];
//    gpuImageView_HD.backgroundColor = [UIColor grayColor];
//    gpuImageView_HD.hidden = YES;
//    [gpuImageView addSubview:gpuImageView_HD];
//    
//    return self;
//}


@end
