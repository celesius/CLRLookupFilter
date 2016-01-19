//
//  IFInkwellFilter.m
//  InstaFilters
//
//  Created by Di Wu on 2/28/12.
//  Copyright (c) 2012 twitter:@diwup. All rights reserved.
//

#import "IFInkwellFilter.h"

NSString *const kIFInkWellShaderString = SHADER_STRING
(
 precision lowp float;
 
 varying highp vec2 textureCoordinate;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 uniform sampler2D inputImageTexture3;
 
 void main()
 {
//     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
//     vec3 bbtex = texture2D(inputImageTexture3, textureCoordinate).rgb;
//     vec3 map =   texture2D(inputImageTexture2, textureCoordinate).rgb;
//    // texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel)); //点×   0.3*texel.r  0.6*texel.g 0.1*texel.b
//    // texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel)); //点×   0.3*texel.r  0.6*texel.g 0.1*texel.b
//
//     //texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,texture2D(inputImageTexture2, vec2(texel.r, .16666)).r,texture2D(inputImageTexture2, vec2(texel.r, .16666)).r); //查找表，查出inputImageTexture2中的某个地址的值
//     //texel = vec3(texture2D(inputImageTexture, vec2(map.r, 0.16666)).r,0,0  ); //这个与上一句相同，这个应该是隐式写法默认三通道相同
//     
//     vec3 maped;
//     maped.r = texture2D(inputImageTexture2,  vec2(bbtex.r, texel.r )).r;
//     maped.g = texture2D(inputImageTexture2,  vec2(bbtex.g, texel.g )).g;
//     maped.b = texture2D(inputImageTexture2,  vec2(bbtex.b, texel.b )).b;
////          texel.r = texture2D(inputImageTexture2,  vec2(texel.r , 0.1666 )).r;
////          texel.g = texture2D(inputImageTexture2,  vec2(texel.g , 0.5    )).g;
////          texel.b = texture2D(inputImageTexture2,  vec2(texel.b , 0.83333)).b;
//     
//     
////     vec2 tc = (2.0 * textureCoordinate) - 1.0;
////     float d = dot(tc, tc);
////     vec2 lookup = vec2(d, texel.r);
////     texel.r = texture2D(inputImageTexture3, lookup).r;
////     lookup.y = texel.g;
////     texel.g = texture2D(inputImageTexture3, lookup).g;
////     lookup.y = texel.b;
////     texel.b	= texture2D(inputImageTexture3, lookup).b;
//
//     
//     //printf("hello %d ",texel.r);
//     
//     gl_FragColor = vec4(maped, 1.0);
     vec3 texel = texture2D(inputImageTexture, textureCoordinate).rgb;
     texel = vec3(dot(vec3(0.3, 0.6, 0.1), texel));
     texel = vec3(texture2D(inputImageTexture2, vec2(texel.r, .16666)).r);
     gl_FragColor = vec4(texel, 1.0);
 }
);

@implementation IFInkwellFilter

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kIFInkWellShaderString]))
    {
		return nil;
    }
    
    return self;
}

@end
