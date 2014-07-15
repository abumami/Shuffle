//
//  amShuffleController.h
//  Shuffle
//
//  Created by Abu Mami on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "amFlashDevices.h"

@interface amShuffleController : NSObject {

    __weak NSButton *clean;
    __weak NSTextField *path;
    __weak NSButtonCell *shuffle;
    
    amFlashDevices *fd;
    
    NSMutableArray *devices;
}

- (IBAction)shuffle:(id)sender;

@property (weak) IBOutlet NSTableView *vols;
@property (weak) IBOutlet NSTextField *path;
@property (weak) IBOutlet NSButtonCell *shuffle;
@property (weak) IBOutlet NSTableView *tableView;
@end
