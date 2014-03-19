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

- (void)augmentUserAgentForWebView:(WebView *)webView;

@end

@implementation KXGAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"collectionBehavior: %lu", (unsigned long)[self.window collectionBehavior]);

    windowHanlder = [[KXGWebViewNewWindowHandler alloc] init];
    downloadController = [[KXGWebDownloadController alloc] initWithWindow:self.window];

    [[self.window windowController] setShouldCascadeWindows:NO];
    //[self.window setCollectionBehavior:NSWindowCollectionBehaviorMoveToActiveSpace|NSWindowCollectionBehaviorFullScreenPrimary];
    [self.window setDelegate:self];
    [self.window setFrameAutosaveName:FRAME_AUTOSAVE];
    [self.window setContentView:self.mainWebView];

    // Augment UserAgent to workaround drag and drop in Gamil
    [self augmentUserAgentForWebView:self.mainWebView];

    [self.mainWebView setDownloadDelegate:downloadController];
    [self.mainWebView setFrameLoadDelegate:self];
    [self.mainWebView setPolicyDelegate:self];
    [self.mainWebView setUIDelegate:self];
    [[self.mainWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:GMAIL_URL]]];

}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    NSLog(@"applicationShouldHandleReopen");

    // orderFront must called before setCollectionBehavior
    [self.window makeKeyAndOrderFront:self];

    NSWindowCollectionBehavior windowCollectionBehavior = [self.window collectionBehavior];
    // Unset NSWindowCollectionBehaviorMoveToActiveSpace if set
    if (windowCollectionBehavior&NSWindowCollectionBehaviorMoveToActiveSpace) {
        [self.window setCollectionBehavior:windowCollectionBehavior^NSWindowCollectionBehaviorMoveToActiveSpace];
    }

    return YES;
}

- (IBAction)showGmailHelp:(id)sender
{
    [KXGUtility openURLString:GMAIL_HELP_URL];
}

- (void)augmentUserAgentForWebView:(WebView *)webView
{
    // For original user agent:
    // Mozilla/x.x (Macintosh; Intel Mac OS X 10_x_x) AppleWebKit/xxx.xx.x (KHTML, like Gecko)
    // augment following string at the end
    // Safari/xxx.xx.x

    NSString *userAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSMutableString *userAgentAugmented = [userAgent mutableCopy];

    NSRange versionRange = [userAgent rangeOfString:@"AppleWebKit/"];

    if (versionRange.length > 0) {
        NSUInteger versionNumberStartIndex = versionRange.location + versionRange.length;
        NSRange versionNumberSearchRange = NSMakeRange(versionNumberStartIndex, [userAgent length] - versionNumberStartIndex);
        NSRange versionNumberRange = [userAgent rangeOfString:@" " options:0 range:versionNumberSearchRange];
        NSUInteger versionNumberEndIndex = versionNumberRange.location;

        NSString *versionNumberString = [userAgent substringWithRange:NSMakeRange(versionNumberStartIndex, versionNumberEndIndex - versionNumberStartIndex + 1)];
        [userAgentAugmented appendString:@" Safari/"];
        [userAgentAugmented appendString:versionNumberString];

        [webView setCustomUserAgent:userAgentAugmented];
    }
}

// NSWindowDelegate

- (BOOL)windowShouldClose:(id)sender
{
    NSLog(@"windowShouldClose");

    [sender setCollectionBehavior:[sender collectionBehavior]|NSWindowCollectionBehaviorMoveToActiveSpace];

    // orderOut must be called after setCollectionBahavior
    [sender orderOut:self];

    return YES;
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
    BOOL canShow = [WebView canShowMIMEType:type];

    NSLog(@"decidePolicyForMIMEType (%@): %@", type, [[request URL] absoluteString]);
    NSLog(@"WebView canShowMIMEType: %@", canShow ? @"YES" : @"NO");

#warning TODO: MIME type code needs further testing
    if (!canShow || ![type isEqualTo:@"text/html"]) {
        [listener download];
    } else {
        [listener use];
    }
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
