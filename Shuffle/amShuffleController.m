//
//  amShuffleController.m
//  Shuffle
//
//  Created by Abu Mami on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "amShuffleController.h"
#import "NSMutableArray+Shuffle.h"

#include <CoreFoundation/CoreFoundation.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <IOKit/usb/IOUSBLib.h>
#include <IOKit/usb/USBSpec.h>

#include "amFlashDevices.h"

#import "errors.h"

int fs(char *filename, char *incl);

@implementation amShuffleController

@synthesize shuffle;
@synthesize path;
@synthesize vols;

- (id)init {
    self = [super init];
    if (self) {
        fd = [[amFlashDevices alloc] init];
    }
    return self;
}

- (IBAction)shuffle:(id)sender {

    NSInteger sel = [vols selectedRow];
    NSString *bsd = [fd getBSD:sel];
    NSString *vol = [fd getVol:sel];
    NSLog(@"cell value:%@", bsd);
    
	NSTask *tasku = [[NSTask alloc] init];
	[tasku setCurrentDirectoryPath:@"/usr/sbin/"];
	[tasku setLaunchPath:@"/usr/sbin/diskutil"];
    [tasku setArguments:[NSArray arrayWithObjects:@"unmount", vol, nil]];
	[tasku launch];
	[tasku waitUntilExit];
    
    fs([bsd UTF8String], "/");
    
	NSTask *taskm = [[NSTask alloc] init];
	[taskm setCurrentDirectoryPath:@"/usr/sbin/"];
	[taskm setLaunchPath:@"/usr/sbin/diskutil"];
    [taskm setArguments:[NSArray arrayWithObjects:@"mount", bsd, nil]];
	[taskm launch];
	[taskm waitUntilExit];
}

@end
