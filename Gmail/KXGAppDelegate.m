//
//  KXGAppDelegate.m
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import "KXGAppDelegate.h"

NSString *const GMAIL_URL = @"https://mail.google.com/";
NSString *const FRAME_AUTOSAVE = @"gmail_frame_autosave";

@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setFrameAutosaveName:FRAME_AUTOSAVE];
    [self.window setContentView:self.mainWebView];
    [[self.mainWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GMAIL_URL]]];
}

@end
