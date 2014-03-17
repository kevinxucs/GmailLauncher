//
//  KXGWebViewNewWindowHandler.m
//  Gmail
//
//  Created by Kaiwen Xu on 3/17/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import "KXGWebViewNewWindowHandler.h"

@implementation KXGWebViewNewWindowHandler

- (id)init
{
    self = [super init];
    if (self != nil) {
        self.dummyWebView = [[WebView alloc] init];
        [self.dummyWebView setPolicyDelegate:self];
    }
    return self;
}

- (WebView *)webView
{
    return self.dummyWebView;
}

- (void)webView:(WebView *)webView decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"<KXGWebViewNewWindowHandler> decidePolicyForNavigationAction");

    if ([[[request URL] host] isEqualTo:@"mail.google.com"]) {
        // Handling internal popup
        NSLog(@"Internal");

#warning TODO: Handle internal Gmail popup windows
    } else {
        // Handling external link
        NSLog(@"External");

        [KXGUtility openURL:[request URL]];
    }

    [listener ignore];
}

- (void)webView:(WebView *)webView decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id < WebPolicyDecisionListener >)listener
{
    NSLog(@"<KXGWebViewNewWindowHandler> decidePolicyForNewWindowAction");

    if ([[[request URL] host] isEqualTo:@"mail.google.com"]) {
        // Handling internal popup, process request to decidePolicyForNavigationAction
        [listener use];
    } else {
        // Handling external link
        [KXGUtility openURL:[request URL]];
        [listener ignore];
    }
}

@end
