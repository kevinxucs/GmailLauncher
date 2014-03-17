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

@interface KXGAppDelegate()

- (void)openURL:(NSURL *)URL;

- (void)openURLString:(NSString *)URLString;

@end

@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.windowHanlder = [[KXGWebViewNewWindowHandler alloc] init];
}

- (void)awakeFromNib
{
    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorMoveToActiveSpace];
    [self.window setDelegate:self];
    [self.window setFrameAutosaveName:FRAME_AUTOSAVE];
    [self.window setContentView:self.mainWebView];
    
    [self.mainWebView setFrameLoadDelegate:self];
    [self.mainWebView setPolicyDelegate:self];
    [self.mainWebView setUIDelegate:self];
    [[self.mainWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GMAIL_URL]]];
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    [self.window makeKeyAndOrderFront:self];
    return NO;
}

- (IBAction)showGmailHelp:(id)sender
{
    [self openURLString:GMAIL_HELP_URL];
}

- (void)openURL:(NSURL *)URL
{
    [[NSWorkspace sharedWorkspace]openURL:URL];
}

- (void)openURLString:(NSString *)URLString
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:URLString]];
}

// NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    [self.window orderOut:self];
    return NO;
}

// WebFrameLoadDelegate

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [self.mainWebView mainFrame]) {
        [self.window setTitle:title];
    }
}

// WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    int actionKey = [[actionInformation objectForKey:WebActionNavigationTypeKey] intValue];
    if (actionKey == WebNavigationTypeLinkClicked) {
        NSLog(@"decidePolicyForNavigationAction (clicked): %@", [[request URL] absoluteString]);
    } else if (actionKey == WebNavigationTypeOther) {
//        NSLog(@"decidePolicyForNavigationAction (other): %@", [[request URL] absoluteString]);
    } else {
        NSLog(@"decidePolicyForNavigationAction: %@", [[request URL] absoluteString]);
    }
    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"decidePolicyForNewWindowAction: %@", [[request URL] absoluteString]);
    [self openURL:[request URL]];
    [listener ignore];
}

// WebUIDelegate

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    NSLog(@"createWebViewWithRequest");

    return [self.windowHanlder webView];
}

@end
