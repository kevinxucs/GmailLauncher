//
//  KXGAppDelegate.h
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

NSString *const GMAIL_URL;
NSString *const FRAME_AUTOSAVE;
NSString *const WEBVIEW_GROUP;

@interface KXGAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain) IBOutlet WebView *mainWebView;

@end
