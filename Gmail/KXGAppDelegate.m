//
//  KXGAppDelegate.m
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import "KXGAppDelegate.h"

NSString *const GMAIL_URL = @"https://mail.google.com/";

@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    [self.window setContentView:self.mainWebView];
    [[self.mainWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GMAIL_URL]]];
}

@end
