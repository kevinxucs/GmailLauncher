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
NSString *const WEBVIEW_GROUP = @"gmail_webview_group";

@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)awakeFromNib
{
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setFrameAutosaveName:FRAME_AUTOSAVE];
    [self.window setContentView:self.mainWebView];
    
    [self.mainWebView setGroupName:WEBVIEW_GROUP];
    [self.mainWebView setUIDelegate:self];
    [self.mainWebView setFrameLoadDelegate:self];
    [[self.mainWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GMAIL_URL]]];
}

// WebUIDelegate

//- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
//{
//    id aDocument = [[NSDocumentController sharedDocumentController] openUntitledDocumentAndDisplay:YES error:nil];
//    [[[aDocument webView] mainFrame] loadRequest:request];
//    return [aDocument webView];
//}
//
//- (void)webViewShow:(WebView *)sender
//{
//    id aDocument = [[NSDocumentController sharedDocumentController] documentForWindow:[sender window]];
//    
//    [aDocument showWindows];
//}

// WebFrameLoadDelegate

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [self.mainWebView mainFrame]) {
        [self.window setTitle:title];
    }
}

@end
