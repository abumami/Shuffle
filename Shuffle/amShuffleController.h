//
//  amShuffleController.h
//  Shuffle
//
//  Created by Abu Mami on 7/12/12.
//  Copyright (c) 2012 Abu Mami. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "amFlashDevices.h"

@interface amShuffleController : NSObject {

    __weak NSButtonCell *shuffle;
    __weak NSButtonCell *close;
    __weak NSMatrix *_randomizeType;

    amFlashDevices *fd;
    NSMutableArray *devices;
    
    long randType;
    NSString *vol;
    NSString *bsd;
}

- (IBAction)shuffle:(id)sender;

@property (weak) IBOutlet NSTableView *vols;
@property (weak) IBOutlet NSButtonCell *shuffle;
@property (weak) IBOutlet NSButtonCell *close;
@property (weak) IBOutlet NSMatrix *randomizeType;

@end
