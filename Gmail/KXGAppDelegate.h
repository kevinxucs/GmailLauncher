//
//  KXGAppDelegate.h
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "KXGUtility.h"
#import "KXGWebViewNewWindowHandler.h"

@interface KXGAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (weak) IBOutlet WebView *mainWebView;

@property (strong) KXGWebViewNewWindowHandler *windowHanlder;

- (IBAction)showGmailHelp:(id)sender;

@end
