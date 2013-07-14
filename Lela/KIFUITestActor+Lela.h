//
//  KIFTester+Lela.h
//  Lela
//
//  Created by Brian Nickel on 7/13/13.
//  Copyright (c) 2013 Brian Nickel. All rights reserved.
//

#import <KIFUITestActor.h>

@interface KIFUITestActor (Lela)

- (void)expectScreenToMatchImageNamed:(NSString *)name;
- (void)expectScreenToMatchImageNamed:(NSString *)name options:(NSDictionary *)options;
@end
