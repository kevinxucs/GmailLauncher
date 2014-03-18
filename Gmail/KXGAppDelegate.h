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
#import "KXGWebDownloadController.h"

@interface KXGAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>
{
    @private
    KXGWebViewNewWindowHandler *windowHanlder;
    KXGWebDownloadController *downloadController;
}

@property (assign) IBOutlet NSWindow *window;

@property (assign) IBOutlet WebView *mainWebView;

- (IBAction)showGmailHelp:(id)sender;

@end
