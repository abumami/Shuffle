//
//  amFlashDevices.h
//  Shuffle
//
//  Created by Abu Mami on 7/15/14.
//  Copyright (c) 2012 Abu Mami. All rights reserved.
//
//

#import <Foundation/Foundation.h>


@interface amFlashDevices : NSObject {
    
    
}

@property (nonatomic,retain) NSMutableArray *vols;

- (NSString*) getBSD:(NSInteger)selected;
- (NSString*) getVol:(NSInteger)selected;

@end
