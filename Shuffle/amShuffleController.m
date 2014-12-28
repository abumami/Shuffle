//
//  amShuffleController.m
//  Shuffle
//
//  Created by Abu Mami on 7/12/12.
//  Copyright (c) 2012 Abu Mami. All rights reserved.
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
@synthesize vols;
@synthesize close;

@synthesize randomizeType;


- (id)init {
    self = [super init];
    if (self) {
        fd = [[amFlashDevices alloc] init];
    }
    return self;
}

- (IBAction)findSelectedButton:(id)sender { // sender is NSMatrix object
    NSButtonCell *selCell = [sender selectedCell];
    NSLog(@"Selected cell is %ld", (long)[selCell tag]);
    randType = (long)[selCell tag];
    [shuffle setEnabled:YES];
}

- (IBAction)shuffle:(id)sender {
    
    [close setEnabled:NO];
    
    NSInteger sel = [vols selectedRow];

    bsd = [fd getBSD:sel];
    vol = [fd getVol:sel];
    NSLog(@"cell value:%@", bsd);
    
    switch (randType) {
    case 1:
        [self clean];
        [self fatShuffle];
        break;
    case 2:
        [self numberedShuffle];
        break;
    case 3:
       [self numberedShuffle];
       [self fatShuffle];
        break;
    default:
        break;
    }
    
    [close setEnabled:YES];
}

- (void)fatShuffle {
    
	NSTask *tasku = [[NSTask alloc] init];
	[tasku setCurrentDirectoryPath:@"/usr/sbin/"];
	[tasku setLaunchPath:@"/usr/sbin/diskutil"];
    [tasku setArguments:[NSArray arrayWithObjects:@"unmount", vol, nil]];
	[tasku launch];
	[tasku waitUntilExit];
    
    fs((char*)[bsd UTF8String], "/");
    
	NSTask *taskm = [[NSTask alloc] init];
	[taskm setCurrentDirectoryPath:@"/usr/sbin/"];
	[taskm setLaunchPath:@"/usr/sbin/diskutil"];
    [taskm setArguments:[NSArray arrayWithObjects:@"mount", bsd, nil]];
	[taskm launch];
	[taskm waitUntilExit];
    
}

- (void)numberedShuffle {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *directoryURL = [NSURL fileURLWithPath:vol isDirectory:YES];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];
    
    NSString *oldFolder;
    NSString *realFolder;
    
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"Error #1 =====> %@", [url path]);
        }
        else if ([isDirectory boolValue]) {
            [enumerator skipDescendants];
            //            NSLog(@"%@", [url path]);
            
            oldFolder = url.lastPathComponent;
            
            if([oldFolder length] > 4)
            {
                if([oldFolder characterAtIndex:3] == ' ')
                {
                    NSInteger value;
                    BOOL success = [[NSScanner scannerWithString:oldFolder] scanInteger:&value];
                    if(success) {
                        realFolder = [oldFolder substringFromIndex:4];
                    }
                    else {
                        realFolder = oldFolder;
                    }
                }
                else {
                    realFolder = oldFolder;
                }
            }
            else {
                realFolder = oldFolder;
            }
            
            [array addObject:realFolder];
            
            if([oldFolder isEqualToString:realFolder] == false)
            {
                // rename folder to "real" folder name
                NSURL *oldURL = [directoryURL URLByAppendingPathComponent:oldFolder];
                NSString *oldPath = [oldURL path];
                
                NSURL *newURL = [directoryURL URLByAppendingPathComponent:realFolder];
                NSString *newPath = [newURL path];
                
                NSFileManager *filemgr;
                filemgr = [NSFileManager defaultManager];
                NSError * err = NULL;
                [filemgr moveItemAtPath:oldPath toPath:newPath error:&err]; // moveItemAtURL doesn't work (why?)
                
                NSLog(@"%@ -> %@; %@", oldPath, newPath, err.localizedDescription);
            }
        }
        else {
            NSLog(@"Error #2 =====> %@", [url path]);
        }
    }
    
    for(NSString * myStr in array) {
        NSLog(@"%@", myStr);
    }
    
    [array shuffle];
    
    int num = 1;
    for(NSString *realFolder in array) {
        
        NSURL *oldURL = [directoryURL URLByAppendingPathComponent:realFolder];
        NSString *oldPath = [oldURL path];
        
        NSString *newFolder = [NSString stringWithFormat:@"%03i %@", num, realFolder];
        NSURL *newURL = [directoryURL URLByAppendingPathComponent:newFolder];
        NSString *newPath = [newURL path];
        
        NSFileManager *filemgr;
        filemgr = [NSFileManager defaultManager];
        NSError * err = NULL;
        [filemgr moveItemAtPath:oldPath toPath:newPath error:&err]; // moveItemAtURL doesn't work (why?)
        
        NSLog(@"%@ -> %@; %@", oldPath, newPath, err.localizedDescription);
        num++;
    }
}

- (void)clean {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *directoryURL = [NSURL fileURLWithPath:vol isDirectory:YES];
    NSArray *keys = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSDirectoryEnumerator *enumerator = [fileManager
                                         enumeratorAtURL:directoryURL
                                         includingPropertiesForKeys:keys
                                         options:NSDirectoryEnumerationSkipsHiddenFiles
                                         errorHandler:^(NSURL *url, NSError *error) {
                                             // Handle the error.
                                             // Return YES if the enumeration should continue after the error.
                                             return YES;
                                         }];
    
    NSString *oldFolder;
    NSString *realFolder;
    
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirectory = nil;
        if (! [url getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"Error #1 =====> %@", [url path]);
        }
        else if ([isDirectory boolValue]) {
            [enumerator skipDescendants];
            //            NSLog(@"%@", [url path]);
            
            oldFolder = url.lastPathComponent;
            
            if([oldFolder length] > 4)
            {
                if([oldFolder characterAtIndex:3] == ' ')
                {
                    NSInteger value;
                    BOOL success = [[NSScanner scannerWithString:oldFolder] scanInteger:&value];
                    if(success) {
                        realFolder = [oldFolder substringFromIndex:4];
                    }
                    else {
                        realFolder = oldFolder;
                    }
                }
                else {
                    realFolder = oldFolder;
                }
            }
            else {
                realFolder = oldFolder;
            }
            
            [array addObject:realFolder];
            
            if([oldFolder isEqualToString:realFolder] == false)
            {
                // rename folder to "real" folder name
                NSURL *oldURL = [directoryURL URLByAppendingPathComponent:oldFolder];
                NSString *oldPath = [oldURL path];
                
                NSURL *newURL = [directoryURL URLByAppendingPathComponent:realFolder];
                NSString *newPath = [newURL path];
                
                NSFileManager *filemgr;
                filemgr = [NSFileManager defaultManager];
                NSError * err = NULL;
                [filemgr moveItemAtPath:oldPath toPath:newPath error:&err]; // moveItemAtURL doesn't work (why?)
                
                NSLog(@"%@ -> %@; %@", oldPath, newPath, err.localizedDescription);
            }
        }
        else {
            NSLog(@"Error #2 =====> %@", [url path]);
        }
    }
    
    for(NSString * myStr in array) {
        NSLog(@"%@", myStr);
    }
}

@end
