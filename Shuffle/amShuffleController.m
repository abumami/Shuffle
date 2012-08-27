//
//  amShuffleController.m
//  Shuffle
//
//  Created by Abu Mami on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "amShuffleController.h"
#import "NSMutableArray+Shuffle.h"

@implementation amShuffleController
@synthesize clean;
@synthesize shuffle;
@synthesize path;

- (IBAction)shuffle:(id)sender {
    
    [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *urlAddress = [path stringValue];
    
    NSURL *directoryURL = [NSURL URLWithString:urlAddress];    
    
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

- (IBAction)clean:(id)sender {
    
    [[NSWorkspace sharedWorkspace] mountedLocalVolumePaths];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSString *urlAddress = [path stringValue];
    
    NSURL *directoryURL = [NSURL URLWithString:urlAddress];
    
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

- (IBAction)browse:(id)sender{
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:FALSE];
    
    if ( [openDlg runModal] == NSOKButton ) {
        // Get an array containing one URL, the one we selected
        NSArray* urls = [openDlg URLs];
        if([urls count] == 1) {
            NSURL *url = [urls objectAtIndex:0];
            [path setStringValue:url.absoluteString];
            NSNumber *type;
            [url getResourceValue:&type forKey:NSURLVolumeIsRemovableKey error:NULL];
            if(type.integerValue == 1) {    // only shuffle disk on key
                [shuffle setEnabled:TRUE];
                [clean setEnabled:TRUE];
            }
            else {
                [shuffle setEnabled:FALSE];
                [clean setEnabled:FALSE];
            }
        }
    }
}

@end
