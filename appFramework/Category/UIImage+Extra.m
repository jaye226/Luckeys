//
//  UIImage+Extra.m
//  KaiKaiBa
//
//  Created by lishaowei on 15/8/2.
//  Copyright (c) 2015年 battery. All rights reserved.
//

#import "UIImage+Extra.h"
#import <Accelerate/Accelerate.h>

#define IMAGE_DATASIZE 300*1024

@implementation UIImage (Extra)

+ (UIImage *)imageWithName:(NSString *)imageName {
    if (imageName == nil || [imageName isEqualToString:@""]) {
        //解决友盟上 -[__NSCFString stringByAppendingString:]: nil argument Crash bug
        return nil;
    }
    UIImage *image = nil;
    
    //  (1)从本地Bundle加载
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    image = [UIImage imageWithContentsOfFile:imagePath];
    
    //防止8.0以下系统图片名没有后缀取空，加后缀
    if (!image) {
        imagePath = [imagePath stringByAppendingString:@".png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    //  (2)从本地根据图片名加载
    if (!image) {
        NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], imageName];
        image = [[UIImage alloc] initWithContentsOfFile:imageFile];
        if (!image) {
            image = [UIImage imageNamed:imageName];
        }
    }
    
    //  (3)从下载到Document路径加载
    if (!image) {
        imagePath = [imagePath stringByAppendingPathComponent:imageName];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    return image;
    
}


+ (UIImage *)imageScaleNamed:(NSString *)name{
    UIImage *img = [UIImage imageNamed:name];
    NSArray *arr1 = [name componentsSeparatedByString:@"#"];
    float version = CURR_IOS_DEVICE_VERSION;
    if (arr1 && [arr1 count]==3) {
        NSString *tmpStr = [arr1 objectAtIndex:1];
        NSArray *arr2 = [tmpStr componentsSeparatedByString:@"_"];
        if ([arr2 count]==4) {
            if (version >= 5.0)
            {
                UIEdgeInsets edgeInsets = UIEdgeInsetsMake([[arr2 objectAtIndex:0] doubleValue], [[arr2 objectAtIndex:1] doubleValue], [[arr2 objectAtIndex:2] doubleValue], [[arr2 objectAtIndex:3] doubleValue]);
                img = [img resizableImageWithCapInsets:edgeInsets];
            }else{
                double leftCapWidth = MAX([[arr2 objectAtIndex:1] doubleValue], [[arr2 objectAtIndex:3] doubleValue]);
                double topCapHeight = MAX([[arr2 objectAtIndex:0] doubleValue], [[arr2 objectAtIndex:2] doubleValue]);
                img = [img stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
                
            }
        }
    }
    return img;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)scaleImageToScale:(float)scaleSize

{
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(self.size.width * scaleSize, self.size.height * scaleSize);
    rect = CGRectIntegral(rect);
    UIGraphicsBeginImageContext(rect.size);
    [self drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


+ (NSData *)UIImageExchangeToNSData:(UIImage *)aImage
{
    
    double quality = 1.0;
    NSData *imageData=UIImageJPEGRepresentation(aImage, quality);
    while ([imageData length]>IMAGE_DATASIZE) {
        if(quality>0.1){
            quality-=0.1;
            imageData=UIImageJPEGRepresentation(aImage, quality);
        }else{
            imageData=UIImageJPEGRepresentation(aImage, 0);
            break;
        }
    }
    return  imageData;
}


-(UIImage *)boxblurImageWithBlur:(CGFloat)blur {
    
    return [self boxblurImageWithBlur:blur tintColor:nil];
}

-(UIImage *)boxblurImageWithBlur:(CGFloat)blur tintColor:(UIColor*)tintColor{
    
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage* destImage = [UIImage imageWithData:imageData];
    
    
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    
    //create vImage_Buffer with data from CGImageRef
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    if (tintColor) {
        CGRect imageRect = {CGPointZero, self.size};
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, tintColor.CGColor);
        CGContextFillRect(ctx, imageRect);
        CGContextRestoreGState(ctx);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}


@end
