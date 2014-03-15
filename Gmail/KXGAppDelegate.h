//
//  KXGAppDelegate.h
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

extern NSString *const GMAIL_URL;

@interface KXGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet WebView *mainWebView;

@end
