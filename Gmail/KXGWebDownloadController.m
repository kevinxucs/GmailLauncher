//
//  KXGWebDownloadController.m
//  Gmail
//
//  Created by Kaiwen Xu on 3/17/14.
//  Copyright (c) 2014 Kaiwen Xu. All rights reserved.
//

#import "KXGWebDownloadController.h"

//
// Code borrowed from
// http://worldwind31.arc.nasa.gov/svn/trunk/WorldWind/lib-external/webview/macosx/WebDownloadController.m
//

@implementation KXGWebDownloadController

// WebDownload Delegate

- (id)initWithWindow:(NSWindow *)window
{
    self = [super init];
    if (self) {
        mainWindow = window;
    }
    return self;
}

- (void)downloadDidBegin:(NSURLDownload *)download
{
    NSLog(@"downloadDidBegin: %@", [[[download request] URL] absoluteString]);
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSLog(@"decideDestinationWithSuggestedFilename: %@", filename);
    // Creates a standard Mac OS X save panel initialized with the default
    // values. The panel returned by savePanel is autoreleased. We do not
    // retain it here because we do not own it; we let the current autorelease
    // pool reclaim it.
    NSSavePanel *savePanel = [NSSavePanel savePanel];

    // If this is the first time we've displayed the save panel, set the
    // current directory URL to the user's downloads directory.
    static BOOL didSetDefaultDirectory = NO;
    if (!didSetDefaultDirectory) {
        NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask];
        if (urls != nil && [urls count] >= 1) {
            [savePanel setDirectoryURL:[urls firstObject]];
        }

        didSetDefaultDirectory = YES;
    }

    // If the suggested filename is not nil, use it as the save panel's default
    // filename. Otherwise the save panel displays with an empty filename and
    // requires the user to enter a name.
    if (filename != nil) {
        [savePanel setNameFieldStringValue:filename];
    }

    // Hack for making beginSheetModalForWindow wait,
    // otherwise downlaod:decideDestinationWithSuggestedFilename: will return
    // without setting a destination.
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    [savePanel beginSheetModalForWindow:mainWindow completionHandler:^(NSInteger result)
     {
         if (result == NSFileHandlingPanelOKButton) {
             NSString *destinationPath = [[savePanel URL] path];
             NSLog(@"Download destination: %@", destinationPath);

             // The user has chosen to download the file. We specify the download
             // file's location on disk according to the user's selected save
             // location.
             [download setDestination:destinationPath allowOverwrite:YES];
         } else if (result == NSFileHandlingPanelCancelButton) {
             NSLog(@"Download cancelled");

             // The user has chosen to cancel the download while choosing a file
             // location. We cancel the download and clean up the WebDownloadView
             // we allocated to display its progress.
             [download cancel];
             // [self endDownload:download];
         }

         dispatch_semaphore_signal(sema);
     }];
#warning FIXME: potential unwanted blocking
    while (dispatch_semaphore_wait(sema, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    }
}

@end
