//
//  KXGAppDelegate.h
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface KXGAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, retain) IBOutlet WebView *mainWebView;

- (IBAction)showGmailHelp:(id)sender;

@end
