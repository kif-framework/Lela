//
//  KIFTester+Lela.m
//  Lela
//
//  Created by Brian Nickel on 7/13/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "KIFUITestActor+Lela.h"
#import "Lela.h"
#import <SenTestingKit/SenTestingKit.h>

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
    NSString *failureMessage = nil;
    
    if (!expectedImage) {
        NSString *result = [Lela saveImage:screenshot type:LelaResultImageTypeActual named:name testRun:runName];
        
        failureMessage = [NSString stringWithFormat:@"Could not find expected image for %@.\nActual result: %@", name, result];
    } else if (![Lela compareExpectedImage:expectedImage toActual:screenshot options:options difference:&difference]) {
        NSString *actualOutput = [Lela saveImage:screenshot type:LelaResultImageTypeActual named:name testRun:runName];
        NSString *expectedOutput = [Lela saveImage:expectedImage type:LelaResultImageTypeExpected named:name testRun:runName];
        NSString *differenceOutput = [Lela saveImage:difference type:LelaResultImageTypeDifference named:name testRun:runName];
        
        failureMessage = [NSString stringWithFormat:@"Screen does not match expected image for %@.\nExpected result: %@\nActual result:   %@\nDifference:      %@", name, expectedOutput, actualOutput, differenceOutput];
    } else {
        // Success!
        return;
    }
    
    [self.delegate failWithException:[NSException failureInFile:self.file atLine:self.line withDescription:@"%@", failureMessage] stopTest:NO];
}

@end
