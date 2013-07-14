//
//  Lela.h
//  Lela
//
//  Created by Brian Nickel on 7/12/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KIFUITestActor+Lela.h"

@class UIImage;

typedef NS_ENUM(NSUInteger, LelaResultImageType) {
    LelaResultImageTypeActual,
    LelaResultImageTypeExpected,
    LelaResultImageTypeDifference
};

@interface Lela : NSObject

+ (NSString *)saveImage:(UIImage *)image type:(LelaResultImageType)type named:(NSString *)name testRun:(NSString *)testRun;
+ (UIImage *)expectedImageWithName:(NSString *)name;
+ (UIImage *)captureScreenshot;
+ (BOOL)compareExpectedImage:(UIImage *)expected toActual:(UIImage *)actual options:(NSDictionary *)options difference:(UIImage **)difference;

@end
