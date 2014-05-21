//
//  KIFTester+Lela.m
//  Lela
//
//  Created by Brian Nickel on 7/13/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "KIFUITestActor+Lela.h"
#import <NSError-KIFAdditions.h>
#import "Lela.h"
#import <XCTest/XCTest.h>

@implementation KIFUITestActor (Lela)

+ (NSString *)lelaTestRunName
{
    static NSString *name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        name = [dateFormatter stringFromDate:[NSDate date]];
    });
    return name;
}

- (void)expectScreenToMatchImageNamed:(NSString *)name
{
    [self expectScreenToMatchImageNamed:name options:nil];
}

- (void)expectScreenToMatchImageNamed:(NSString *)name options:(NSDictionary *)options
{
    UIImage *screenshot = [Lela captureScreenshot];
    UIImage *expectedImage = [Lela expectedImageWithName:name];
    UIImage *difference = nil;

    NSString *runName = [[self class] lelaTestRunName];
    
    if (!expectedImage) {
        NSString *result = [Lela saveImage:screenshot type:LelaResultImageTypeActual named:name testRun:runName];
        
        [self failWithError:[NSError KIFErrorWithFormat:@"Could not find expected image for %@.\nActual result: %@", name, result] stopTest:NO];
    } else if (![Lela compareExpectedImage:expectedImage toActual:screenshot options:options difference:&difference]) {
        NSString *actualOutput = [Lela saveImage:screenshot type:LelaResultImageTypeActual named:name testRun:runName];
        NSString *expectedOutput = [Lela saveImage:expectedImage type:LelaResultImageTypeExpected named:name testRun:runName];
        NSString *differenceOutput = [Lela saveImage:difference type:LelaResultImageTypeDifference named:name testRun:runName];
        
        [self failWithError:[NSError KIFErrorWithFormat:@"Screen does not match expected image for %@.\nExpected result: %@\nActual result:   %@\nDifference:      %@", name, expectedOutput, actualOutput, differenceOutput] stopTest:NO];
    }
}

@end
