//
//  KXGWebViewNewWindowHandler.h
//  Gmail
//
//  Created by Kaiwen Xu on 3/17/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "KXGUtility.h"

@interface KXGWebViewNewWindowHandler : NSObject

@property (atomic, strong) WebView *dummyWebView;

- (WebView *)webView;

@end
