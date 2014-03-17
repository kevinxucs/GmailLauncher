//
//  KXGUtility.m
//  Gmail
//
//  Created by Kaiwen Xu on 3/17/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import "KXGUtility.h"

@implementation KXGUtility

+ (void)openURL:(NSURL *)URL
{
    [[NSWorkspace sharedWorkspace] openURL:URL];
}

+ (void)openURLString:(NSString *)URLString
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:URLString]];
}


@end
