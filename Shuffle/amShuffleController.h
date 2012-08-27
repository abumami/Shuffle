//
//  amShuffleController.h
//  Shuffle
//
//  Created by Abu Mami on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface amShuffleController : NSObject {

    __weak NSButton *clean;
    __weak NSTextField *path;
    __weak NSButtonCell *shuffle;
}

- (IBAction)browse:(id)sender;
- (IBAction)shuffle:(id)sender;
- (IBAction)clean:(id)sender;

@property (weak) IBOutlet NSTextField *path;
@property (weak) IBOutlet NSButtonCell *shuffle;
@property (weak) IBOutlet NSButton *clean;
@end
