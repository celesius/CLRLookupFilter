//
//  CLRGPUImageVC.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/14.
//  Copyright © 2016年 clover. All rights reserved.
//
#define kFilterImageViewTag 9999
#define kFilterImageViewContainerViewTag 9998
#define kBlueDotImageViewOffset 25.0f
#define kFilterCellHeight 72.0f 
#define kBlueDotAnimationTime 0.2f
#define kFilterTableViewAnimationTime 0.2f
#define kGPUImageViewAnimationOffset 27.0f

#import "CLRGPUImageVC.h"
#import "CLRiOSPlug.h"
#import <GPUImage.h>
//#import "CLRGPUImageLookUpFilter.h"
#import "CLRImageFilter.h"
#import <AssetsLibrary/ALAsset.h>
#import <Photos/Photos.h>

@interface CLRGPUImageVC() <UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    //CLRGPUImageLookUpFilter *filter;
    CLRImageFilter *filter;
    UIImagePickerController *ipc;
    //GPUImagePicture *mPic;
    IFFilterType _filterTypeBuffer;
}

@property (nonatomic, strong) UIImageView *dispView;
@property (nonatomic, strong) GPUImageView *gpuImageView;
@property (nonatomic, strong) UIImage *processedImg;
@property (nonatomic, strong) UIImage *loopUpImg;
@property (nonatomic, strong) UISlider *loopUpSlider;
@property (nonatomic, strong) UILabel *sliderLabel;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic) UITableView *filterSelector;
@property (nonatomic) UIImage *imageBuffer;
@property (nonatomic) UIImage *imageNoLightBuffer;

@end

@implementation CLRGPUImageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    float imgWH = self.getImage.size.width / self.getImage.size.height;
    self.dispView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, CGRectGetWidth([CLRiOSPlug screenInfo]), CGRectGetWidth([CLRiOSPlug screenInfo])/imgWH)];
    self.dispView.image = self.getImage;//[self processImage:self.getImage];//self.getImage;
    self.dispView.center = self.view.center;
    [self.view addSubview:self.dispView];
    
    //self.dispView.image = [self testCode];
    //[self testCode];
    
    
    filter = [[CLRImageFilter alloc]initWithImgViewRect:self.dispView.bounds];
    filter.srcImage = self.getImage;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 10, 100, 40);
    backButton.backgroundColor = [UIColor grayColor];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth([CLRiOSPlug screenInfo]) - 200, 10, 200, 40)];
    self.nameLabel.backgroundColor = [UIColor grayColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.nameLabel];
    
    
    self.loopUpSlider = [[UISlider alloc]initWithFrame:CGRectMake((CGRectGetWidth([CLRiOSPlug screenInfo]) - 250.0)/2.0 - 30, CGRectGetHeight([CLRiOSPlug screenInfo]) - 100, 250, 30)];
    self.loopUpSlider.minimumValue = 0.0;
    self.loopUpSlider.maximumValue = 1.0;
    self.loopUpSlider.value = 1.0;
    [self.loopUpSlider addTarget:self action:@selector(loopUpSliderFoo:) forControlEvents:UIControlEventValueChanged];
    //[self.view addSubview:self.loopUpSlider];
   
    self.sliderLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.loopUpSlider.frame) + 10, CGRectGetMinY(self.loopUpSlider.frame) , 60, 30)];
    self.sliderLabel.textColor = [UIColor whiteColor];
    NSString *labelText = [NSString stringWithFormat:@"%2d", (int)(self.loopUpSlider.value*100) ];
    [self.sliderLabel setText:labelText];
    [self.view addSubview:self.sliderLabel];
    
    
    UIButton *selectLookupButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [selectLookupButton setTitle:@"来个滤镜" forState:UIControlStateNormal];
    selectLookupButton.frame = CGRectMake(0, CGRectGetHeight([CLRiOSPlug screenInfo]) - 50, CGRectGetWidth([CLRiOSPlug screenInfo]), 50);
    selectLookupButton.backgroundColor = [UIColor grayColor];
    [selectLookupButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectLookupButton addTarget:self action:@selector(selectLookupButtonFoo:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:selectLookupButton];
    
    [self initFilterSelectorView];
    
    _filterTypeBuffer = IF_NORMAL_FILTER;
    
}

- (void)testCode
{
    @autoreleasepool {
        
        GPUImageGrayscaleFilter *mFilter = [[GPUImageGrayscaleFilter alloc]init];
        //[mFilter forceProcessingAtSize:CGSizeMake(480, 640)];
        self.gpuImageView = [[GPUImageView alloc]initWithFrame:self.dispView.frame];  //(GPUImageView *)self.dispView;
        [mFilter addTarget:self.gpuImageView];
        //  GPUImagePicture *mPic = [[GPUImagePicture alloc]initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IMG_3773" ofType:@"JPG"]]];  //[[GPUImagePicture alloc]initWithImage:self.getImage];
        GPUImagePicture *mPic = [[GPUImagePicture alloc]initWithImage:self.getImage];
        //[mPic addTarget:self.gpuImageView];
        //[mPic addTarget:self.getImage];
        [mPic addTarget:mFilter];
        [mFilter useNextFrameForImageCapture];
        //[mPic processImage];
        
        BOOL yyy = [mPic processImageWithCompletionHandler:^{
            NSLog(@"processImageWithCompletionHandler");
            [mPic removeAllTargets];
        }];
    }
    [self.view addSubview:self.gpuImageView];
    //UIImage *outImg = [mFilter imageByFilteringImage:self.getImage];
    //return outImg;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)initFilterSelectorView
{
    float screenHeight = CGRectGetHeight( [UIScreen mainScreen].bounds);
    float screenWidth = CGRectGetWidth( [UIScreen mainScreen].bounds );
    
    UIView *filterTableViewContainerView;
    
    filterTableViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - 40 - 72 + 10, screenWidth, 72)];
    filterTableViewContainerView.backgroundColor = [UIColor clearColor];
    
    
    self.filterSelector = [[UITableView alloc] initWithFrame:CGRectMake(124, -124, 72, 320) style:UITableViewStylePlain];
    self.filterSelector.backgroundColor = [UIColor whiteColor];
    self.filterSelector.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.filterSelector.showsVerticalScrollIndicator = NO;
    self.filterSelector.delegate = self;
    self.filterSelector.dataSource = self;
    self.filterSelector.transform	= CGAffineTransformMakeRotation(-M_PI/2);
    
    [filterTableViewContainerView addSubview:self.filterSelector];
    [self.view addSubview:filterTableViewContainerView];
}
/*
- (void)processImage:(UIImage *)srcImg
{
    filter = [[CLRGPUImageLookUpFilter alloc]initWithLookUpImg:self.loopUpImg];
    filter.filterImg = srcImg;
    self.processedImg = [filter getFilterResultBySetValue:self.loopUpSlider.value];
    self.dispView.image = self.processedImg;
}
 */

- (void)backButtonFoo:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    //self.getImage = nil;
    filter = nil;
    //mPic = nil;
}

- (void)selectLookupButtonFoo:(id)sender
{
    ipc = [[UIImagePickerController alloc]init];
    ipc.delegate = self;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)loopUpSliderFoo:(id)sender
{
    if(self.processedImg){
        //self.processedImg = [filter getFilterResultBySetValue:self.loopUpSlider.value];
        self.dispView.image = self.processedImg;
    }
    NSString *labelText = [NSString stringWithFormat:@"%2d", (int)(self.loopUpSlider.value*100) ];
    [self.sliderLabel setText:labelText];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    CLRGPUImageVC* __weak weakself = self;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [picker dismissViewControllerAnimated:YES completion:^{
            
        //[weakself processImage:weakself.getImage];
        
        }];
        //[picker dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIImage *bufferImg =[info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.loopUpImg = bufferImg;//  [UIImage imageWithCGImage:bufferImg.CGImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp] ;
  
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
   
    NSArray *array = [[NSArray alloc]initWithContentsOfURL:url];
    
    PHAsset *asset;
    //asset =   [PHAsset fetchAssetsWithALAssetURLs:array options:nil];  //[PHAsset fetchAssetsWithALAssetURLs:array options:nil];
    asset = [[PHAsset fetchAssetsWithALAssetURLs:@[info[@"UIImagePickerControllerReferenceURL"]] options:nil] lastObject];
    
    NSArray *resources = [PHAssetResource assetResourcesForAsset:asset];
    NSString *orgFilename = ((PHAssetResource*)resources[0]).originalFilename;
    
    [self.nameLabel setText:orgFilename];
    
    //NSString *name = PHAssetResource
    //PHAssetResource *rr = [[PHAssetResource assetResourcesForAsset:asset] lastObject];
    //NSString *name = [rr assetLocalIdentifier];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint touchPoint = [aTouch locationInView:self.dispView];
    
    /*
    if(CGRectContainsPoint(self.dispView.bounds, touchPoint) && _filterTypeBuffer > IF_LORDKELVIN_FILTER) {
        //self.dispView.image = self.getImage;
        if(self.imageNoLightBuffer)
        {
            self.dispView.image = self.imageNoLightBuffer;
        } else {
            self.dispView.image = filter.imageNoLight;
            self.imageNoLightBuffer = filter.imageNoLight;
            //CLRGPUImageVC *__weak weakSelf = self;
            //filter.clrFilterBlockNoLight = ^(UIImage *image){
            //    weakSelf.dispView.image = image;
            //    weakSelf.imageNoLightBuffer = image;
            //};
        }
    }
     */

}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    CGPoint touchPoint = [aTouch locationInView:self.dispView];
    //if(CGRectContainsPoint(self.dispView.bounds, touchPoint)) {
    /*
    if(_filterTypeBuffer > IF_LORDKELVIN_FILTER){
        self.dispView.image = self.imageBuffer;
    }
     */
    
    //if(self.processedImg){
    //    self.dispView.image = self.processedImg;
    //}
    //}
}

- (void) touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
}

#pragma -TabelView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (int)IF_FILTER_TOTAL_NUMBER;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)[indexPath row]);
    CLRGPUImageVC *__weak weakSelf = self;
    filter.clrFilterBlock = ^(UIImage *image) {
        NSLog(@"%@",image);
        weakSelf.dispView.image = image;
        weakSelf.imageBuffer = image;
    };
    [filter switchFilter:(IFFilterType)[indexPath row]];
    /*
    if(_filterTypeBuffer != (IFFilterType)[indexPath row]){
        _filterTypeBuffer = (IFFilterType)[indexPath row];
        self.imageNoLightBuffer = nil;
    }
     */
    self.nameLabel.text = filter.filterName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *filtersTableViewCellIdentifier = @"filtersTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: filtersTableViewCellIdentifier];

    UIImageView *filterImageView;
    UIView *filterImageViewContainerView;
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:filtersTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, -7.5, 57, 72)];
        filterImageView.transform = CGAffineTransformMakeRotation(M_PI/2);
        filterImageView.tag = kFilterImageViewTag;
        
        filterImageViewContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 57, 72)];
        filterImageViewContainerView.tag = kFilterImageViewContainerViewTag;
        [filterImageViewContainerView addSubview:filterImageView];
        
        [cell.contentView addSubview:filterImageViewContainerView];
    } else {
        filterImageView = (UIImageView *)[cell.contentView viewWithTag:kFilterImageViewTag];
    }
    switch ([indexPath row]) {
        case 0: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];

            break;
        }
        case 1: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileAmaro" ofType:@"png"]];
            
            break;
        }
        case 2: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileRise" ofType:@"png"]];
            
            break;
        }
        case 3: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHudson" ofType:@"png"]];
            
            break;
        }
        case 4: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileXpro2" ofType:@"png"]];
            
            break;
        }
        case 5: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSierra" ofType:@"png"]];
            
            break;
        }
        case 6: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLomoFi" ofType:@"png"]];
            
            break;
        }
        case 7: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileEarlybird" ofType:@"png"]];
            
            break;
        }
        case 8: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileSutro" ofType:@"png"]];
            
            break;
        }
        case 9: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileToaster" ofType:@"png"]];
            
            break;
        }
        case 10: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileBrannan" ofType:@"png"]];
            
            break;
        }
        case 11: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileInkwell" ofType:@"png"]];
            
            break;
        }
        case 12: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileWalden" ofType:@"png"]];
            
            break;
        }
        case 13: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileHefe" ofType:@"png"]];
            
            break;
        }
        case 14: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileValencia" ofType:@"png"]];
            
            break;
        }
        case 15: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNashville" ofType:@"png"]];
            
            break;
        }
        case 16: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTile1977" ofType:@"png"]];
            
            break;
        }
        case 17: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileLordKelvin" ofType:@"png"]];
            break;
        }

        case 18: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];
            break;
        }
            
        default: {
            filterImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DSFilterTileNormal" ofType:@"png"]];

            break;
        }
    }
    
    return cell;
}



- (void)dealloc
{
    NSLog(@"dealloc CLRGPUImageVC");
}

@end
