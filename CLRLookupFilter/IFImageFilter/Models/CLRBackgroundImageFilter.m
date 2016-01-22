//
//  CLRBackgroundImageFilter.m
//  CLRLookupFilter
//
//  Created by vk on 16/1/21.
//  Copyright © 2016年 clover. All rights reserved.
//

#import "CLRBackgroundImageFilter.h"

NSString *const kCLRBGShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2; //blowout;  //1024*1024
 uniform sampler2D inputImageTexture3; //overlay;  //256*256
 
 void main()
 {
     
     vec4 texel = texture2D(inputImageTexture, textureCoordinate);
     vec4 bbTexel = texture2D(inputImageTexture2, textureCoordinate).rgba;
     
     
     texel.r = texture2D(inputImageTexture3, vec2(1.0 - (2.0*(bbTexel.a+0.1)), texel.r)).r;
     texel.g = texture2D(inputImageTexture3, vec2(1.0 - (2.0*(bbTexel.a+0.1)), texel.g)).g;
     texel.b = texture2D(inputImageTexture3, vec2(1.0 - (2.0*(bbTexel.a+0.1)), texel.b)).b;
     //texel.r = texture2D(inputImageTexture3, vec2(bbTexel.r, texel.r)).r;
     //texel.g = texture2D(inputImageTexture3, vec2(bbTexel.g, texel.g)).g;
     //texel.b = texture2D(inputImageTexture3, vec2(bbTexel.b, texel.b)).b;
     //texel.r = bbTexel.r;// + texel.r;
     //texel.g = bbTexel.g;// + texel.g;
     //texel.b = bbTexel.b;// + texel.b;
               
     vec4 mapped;
     mapped.r = texel.r;
     mapped.g = texel.g;
     mapped.b = texel.b;
     mapped.a = 1.0;
     
     gl_FragColor = mapped;
 }
);

@implementation CLRBackgroundImageFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kCLRBGShaderString]))
    {
		return nil;
    }
    
    return self;
}



@end
