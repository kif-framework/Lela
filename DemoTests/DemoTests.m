//
//  DemoTests.m
//  DemoTests
//
//  Created by Brian Nickel on 7/13/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import "KIF.h"
#import "Lela.h"

@interface KIFUITestActor (Deletion)
- (void)deleteFirstItem;
@end

@implementation KIFUITestActor (Deletion)

- (void)deleteFirstItem
{
    // This code is not amazing.  You should never do anything like it.
    [self tapViewWithAccessibilityLabel:@"Edit"];
    [self tapScreenAtPoint:CGPointMake(20, 80)];
    [self waitForTimeInterval:0.5];
    [self tapScreenAtPoint:CGPointMake(300, 80)];
    [self tapViewWithAccessibilityLabel:@"Done"];
}

@end

@interface DemoTests : KIFTestCase
@end


@implementation DemoTests

- (void)testHomeScreen
{
    [tester expectScreenToMatchImageNamed:@"Home screen"];
}

- (void)testNonMatchingImages
{
    [tester tapViewWithAccessibilityLabel:@"Add"];
    [tester expectScreenToMatchImageNamed:@"Entry added"];
    
    // Notice that this line gets called.
    [tester deleteFirstItem];
    
    // Here we have a good old fashioned KIF failure.
    [[tester usingTimeout:1] waitForViewWithAccessibilityLabel:@"Some view that doesn't exist"];
    [tester waitForViewWithAccessibilityLabel:@"This won't get called"];
}

- (void)testMissingImage
{
    [tester tapViewWithAccessibilityLabel:@"Edit"];
    [tester expectScreenToMatchImageNamed:@"Edit screen"];
    [tester tapViewWithAccessibilityLabel:@"Done"];
}

@end