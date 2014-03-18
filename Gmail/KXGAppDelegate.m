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


@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    windowHanlder = [[KXGWebViewNewWindowHandler alloc] init];
    downloadController = [[KXGWebDownloadController alloc] initWithWindow:self.window];

    [[self.window windowController] setShouldCascadeWindows:NO];
    [self.window setCollectionBehavior:NSWindowCollectionBehaviorMoveToActiveSpace];
    [self.window setDelegate:self];
    [self.window setFrameAutosaveName:FRAME_AUTOSAVE];
    [self.window setContentView:self.mainWebView];

    [self.mainWebView setDownloadDelegate:downloadController];
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
    [KXGUtility openURLString:GMAIL_HELP_URL];
}

// NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    [sender orderOut:self];
    return NO;
}

// WebFrameLoadDelegate

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame
{
    if (frame == [sender mainFrame]) {
        [[sender window] setTitle:title];
    }
}

// WebPolicyDelegate

- (void)webView:(WebView *)webView decidePolicyForMIMEType:(NSString *)type request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"decidePolicyForMIMEType (%@): %@", type, [[request URL] absoluteString]);

#warning TODO: Implement method to determine which MIME types should be downloaded
    if ([type isEqualToString:@"application/pdf"]) {
        [listener download];
        return;
    }

    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    int actionKey = [[actionInformation objectForKey:WebActionNavigationTypeKey] intValue];
    if (actionKey == WebNavigationTypeLinkClicked) {
        NSLog(@"decidePolicyForNavigationAction (clicked): %@", [[request URL] absoluteString]);
    } else if (actionKey == WebNavigationTypeOther) {
        NSLog(@"decidePolicyForNavigationAction (other): %@", [[request URL] absoluteString]);
    } else {
        NSLog(@"decidePolicyForNavigationAction: %@", [[request URL] absoluteString]);
    }
    [listener use];
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"decidePolicyForNewWindowAction: %@", [[request URL] absoluteString]);
    [KXGUtility openURL:[request URL]];
    [listener ignore];
}

// WebUIDelegate

- (WebView *)webView:(WebView *)sender createWebViewWithRequest:(NSURLRequest *)request
{
    NSLog(@"createWebViewWithRequest");

    return [windowHanlder webView];
}

- (void)webView:(WebView *)sender runOpenPanelForFileButtonWithResultListener:(id < WebOpenPanelResultListener >)resultListener allowMultipleFiles:(BOOL)allowMultipleFiles
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];

    [openPanel setCanChooseFiles:YES];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setAllowsMultipleSelection:allowMultipleFiles];

    [openPanel beginSheetModalForWindow:[sender window] completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton) {
             NSArray *files = [openPanel URLs];
             NSMutableArray *fileURLStrings = [NSMutableArray arrayWithCapacity:[files count]];

             for (id fileURL in files) {
                 NSString *fileURLString = [fileURL path];
                 NSLog(@"Uploading file: %@", fileURLString);

                 [fileURLStrings addObject:fileURLString];
             }
             [resultListener chooseFilenames:fileURLStrings];
         } else if (result == NSFileHandlingPanelCancelButton) {
             [resultListener cancel];
         }
     }];
}

@end
