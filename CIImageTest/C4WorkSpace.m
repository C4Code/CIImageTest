//
//  C4WorkSpace.m
//  CIImageTest
//
//  Created by moi on 13-01-31.
//  Copyright (c) 2013 moi. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    
}

-(void)setup {
    [self test1];
    //    [self test2];
    //    [self test3];
    //    [self test4];
    //    [self test5];
    //    [self test6];
}

-(void)test1 {
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 1, nil, nil);
    CFDictionaryAddValue(dict, &kCIImageColorSpace, (const void *)kCGColorSpaceModelRGB);
    //HAVE TRIED ALL VARIATIONS OF kCGColorSpaceModel...
    
    UIImage *img = [UIImage imageNamed:@"C4Sky.png"];
    CIImage *c = [CIImage imageWithCGImage:img.CGImage
                                   options:(__bridge NSDictionary*)dict];
    UIImage *i = [UIImage imageWithCIImage:c];
    UIImageView *uiiv = [[UIImageView alloc] initWithImage:i];
    [self.canvas addSubview:uiiv];
    //via http://stackoverflow.com/a/14622510/1218605
    //fail
}

-(void)test2 {
    //Grab the CIImage directly from the UIImage
    UIImage *img = [UIImage imageNamed:@"C4Sky.png"];
    CIImage *c = img.CIImage;
    UIImage *i = [UIImage imageWithCIImage:c];
    UIImageView *uiiv = [[UIImageView alloc] initWithImage:i];
    [self.canvas addSubview:uiiv];
    //via http://stackoverflow.com/a/14622510/1218605
    //blank, no image
}

-(void)test3 {
    CIImage *image = [[CIImage alloc] initWithImage:[UIImage imageNamed:@"mushroom.jpg"]];
    CIContext *context = [CIContext contextWithOptions:nil];
    UIImage *ui = [UIImage imageWithCGImage:[context createCGImage:image fromRect:image.extent]];
    UIImageView *uiiv = [[UIImageView alloc] initWithImage:ui];
    [self.canvas addSubview:uiiv];
    //via http://stackoverflow.com/a/7788510/1218605
    //blank, no image
}

-(void)test4 {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"C4Sky" withExtension:@"png"];
    CIImage *beginImage = [CIImage imageWithContentsOfURL:url];
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"
                                  keysAndValues: kCIInputImageKey, beginImage,
                        @"inputIntensity", @0.8, nil];
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    UIImageView *uiiv = [[UIImageView alloc] initWithImage:newImage];
    [self.canvas addSubview:uiiv];
    CGImageRelease(cgimg);
    //via http://www.raywenderlich.com/22167/beginning-core-image-in-ios-6
    //via http://stackoverflow.com/a/14619171/1218605
    //creates a filtered image, but with the same grainy kind of image
    //fail
}

-(void)test5 {
    UIImage *img = [UIImage imageNamed:@"C4Sky"];
    CIImage *cii = [CIImage imageWithData:UIImagePNGRepresentation(img)];
    UIImage *uii = [UIImage imageWithCIImage:cii];
    UIImageView *uiiv = [[UIImageView alloc] initWithImage:uii];
    [self.canvas addSubview:uiiv];
    //fail
}

-(void)test6 {
    UIImage *img = [UIImage imageNamed:@"C4Sky"];
    
    CGContextRef    bitmapContext = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    CGSize          size = img.size;
    bitmapBytesPerRow   = (size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * size.height);
    bitmapData = malloc( bitmapByteCount );
    bitmapContext = CGBitmapContextCreate(bitmapData, size.width, size.height,8,bitmapBytesPerRow,
                                          CGColorSpaceCreateDeviceRGB(),kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(bitmapContext, (CGRect){CGPointZero,size}, img.CGImage);
    CGImageRef imgRef = CGBitmapContextCreateImage(bitmapContext);
    
    CIImage *cii = [CIImage imageWithCGImage:imgRef];
    UIImage *finalImage = [UIImage imageWithCIImage:cii];
    
    UIImageView *uiiv = [[UIImageView alloc] initWithImage:finalImage];
    [self.canvas addSubview:uiiv];
    //works but it's dirrrrrrrty
}
@end
