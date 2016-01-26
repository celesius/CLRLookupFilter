//
//  IFImageFilterClover.h
//  InstaFilters
//
//  Created by vk on 15/6/15.
//  Copyright (c) 2015年 clover. All rights reserved.
//

#import <GPUImage.h>
//#import <GPUImage/GPUImageFramework.h>


@interface IFImageFilter : GPUImageThreeInputFilter

{
    GPUImageFramebuffer *fourthInputFramebuffer;
    GPUImageFramebuffer *fifthInputFramebuffer;
    GPUImageFramebuffer *sixthInputFramebuffer;
    
    GLint filterFourthTextureCoordinateAttribute,filterFifthTextureCoordinateAttribute,filterSixthTextureCoordinateAttribute;
    GLint filterInputTextureUniform4,filterInputTextureUniform5,filterInputTextureUniform6; //jiangbo
    GPUImageRotationMode inputRotation4,inputRotation5,inputRotation6; //jiangbo
    GLuint filterSourceTexture4,filterSourceTexture5,filterSourceTexture6; //jiangbo
    CMTime fourthFrameTime,fifthFrameTime,sixthFrameTime;
    
    BOOL hasSetThirdTexture, hasReceivedFourthFrame, fourthFrameWasVideo;  //4
    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;   //5
    BOOL hasSetFifthTexture, hasReceivedSixthFrame, sixthFrameWasVideo;    //6
    //BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    
    
    BOOL fourthFrameCheckDisabled;
    BOOL fifthFrameCheckDisabled;
    BOOL sixthFrameCheckDisabled;
}
@property(readwrite, nonatomic) CGFloat intensity;

- (void)disableFourthFrameCheck;
- (void)disableFifthFrameCheck;
- (void)disableSixthFrameCheck;

@end
