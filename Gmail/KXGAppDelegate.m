//
//  KXGAppDelegate.m
//  Gmail
//
//  Created by Kaiwen Xu on 3/10/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import "KXGAppDelegate.h"

NSString *const GMAIL_URL = @"https://mail.google.com/";
NSString *const GMAIL_HELP_URL = @"https://support.google.com/mail/";
NSString *const FRAME_AUTOSAVE = @"gmail_frame_autosave";
NSString *const WEBVIEW_GROUP = @"gmail_webview_group";

@interface KXGAppDelegate()

- (void)openURL:(NSString *)URLString;

@end

@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (void)awakeFromNib
{
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorMoveToActiveSpace];
    [self.window setDelegate:self];
    [self.window setFrameAutosaveName:FRAME_AUTOSAVE];
    [self.window setContentView:self.mainWebView];
    
    [self.mainWebView setGroupName:WEBVIEW_GROUP];
    [self.mainWebView setUIDelegate:self];
    [self.mainWebView setPolicyDelegate:self];
    [self.mainWebView setFrameLoadDelegate:self];
    [[self.mainWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GMAIL_URL]]];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

- (IBAction)showGmailHelp:(id)sender
{
    [self openURL:GMAIL_HELP_URL];
}

- (void)openURL:(NSString *)URLString
{
    NSLog(@"Opening URL: %@", URLString);
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:URLString]];
}

// NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    [self.window orderOut:self];
    return NO;
}

// WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"decidePolicyForNavigationAction: %@", [[request URL] absoluteString]);
    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"decidePolicyForNewWindowAction");
}

// WebFrameLoadDelegate

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [self.mainWebView mainFrame]) {
        [self.window setTitle:title];
    }
}

@end
