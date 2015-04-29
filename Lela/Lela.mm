//
//  Lela.m
//  Lela
//
//  Created by Brian Nickel on 7/12/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "Lela.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include "LPyramid.h"
#include "RGBAImage.h"
#include "CompareArgs.h"
#include "Metric.h"

@implementation Lela

+ (CGRect)currentScreenBoundsDependOnOrientation
{
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1)
        return screenBounds;

    CGFloat width = CGRectGetWidth(screenBounds);
    CGFloat height = CGRectGetHeight(screenBounds);
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        screenBounds.size = CGSizeMake(width, height);
    else if(UIInterfaceOrientationIsLandscape(interfaceOrientation))
        screenBounds.size = CGSizeMake(height, width);

    return screenBounds;
}

+ (NSString *)imageNameForScreenNamed:(NSString *)screenName
{
    CGSize screenSize = [self.class currentScreenBoundsDependOnOrientation].size;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *idiom;
    
    switch ([UIDevice currentDevice].userInterfaceIdiom) {
        case UIUserInterfaceIdiomPad:   idiom = @"ipad";   break;
        case UIUserInterfaceIdiomPhone: idiom = @"iphone"; break;
    }
    NSString *version = [[UIDevice currentDevice] systemVersion];
    
    return [NSString stringWithFormat:@"%@-%dx%d@%dx-%@,iOS%@", screenName, (int)screenSize.width, (int)screenSize.height, (int)roundf(scale), idiom, version];
}

+ (NSString *)directoryForTestRunNamed:(NSString *)name
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [[path stringByAppendingPathComponent:@"Lela Tests"] stringByAppendingPathComponent:name];
}

+ (NSString *)directoryForExpectedImages
{
    return [[NSBundle bundleForClass:self] resourcePath];
}

+ (NSString *)saveImage:(UIImage *)image type:(LelaResultImageType)type named:(NSString *)name testRun:(NSString *)testRun
{
    NSString *fileName;
    switch (type) {
        case LelaResultImageTypeActual:     fileName = [self imageNameForScreenNamed:name]; break;
        case LelaResultImageTypeExpected:   fileName = @"Expected";   break;
        case LelaResultImageTypeDifference: fileName = @"Difference"; break;
    }
    
    NSString *directoryPath = [[self directoryForTestRunNamed:testRun] stringByAppendingPathComponent:[self imageNameForScreenNamed:name]];
    NSString *filePath = [[directoryPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:@"png"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:NULL];
    
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
    
    return filePath;
}

+ (UIImage *)expectedImageWithName:(NSString *)name
{
    NSString *fileName = [[self imageNameForScreenNamed:name] stringByAppendingPathExtension:@"png"];
    NSString *filePath = [[self directoryForExpectedImages] stringByAppendingPathComponent:fileName];
    return [UIImage imageWithContentsOfFile:filePath];
}

+ (UIImage *)captureScreenshot
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGRect imageRect = [self.class currentScreenBoundsDependOnOrientation];
    CGSize imageSize = imageRect.size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);

    CGContextRef context = UIGraphicsGetCurrentContext();

    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);

            // Render the layer hierarchy to the current context
            UIView* view = [[window subviews] lastObject];
            if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
                [[[window subviews] lastObject] drawViewHierarchyInRect:imageRect afterScreenUpdates:YES];
            else
                [[window layer] renderInContext:context];

            // Restore the context
            CGContextRestoreGState(context);
        }
    }

    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (BOOL)compareExpectedImage:(UIImage *)expected toActual:(UIImage *)actual options:(NSDictionary *)options difference:(UIImage **)difference
{
    CompareArgs args;
    args.ImgA = RGBAImage::ReadFromUIImage(expected);
    args.ImgB = RGBAImage::ReadFromUIImage(actual);
    args.ImgDiff = new RGBAImage(args.ImgA->Get_Width(), args.ImgA->Get_Height(), "Output");
    
    BOOL success = Yee_Compare(args);
    
    if (!success && difference) {
        *difference = args.ImgDiff->Get_UIImage();
    }
    
    return success;
}

@end
