//
//  amFlashDevices.h
//  Shuffle
//
//  Created by Abu Mami on 7/15/14.
//
//

#import <Foundation/Foundation.h>

//@interface amFlashDevices : NSObject
//
//@end


/*
@interface volUSB : NSObject
{
@public
    NSString* bsdName;
    NSString* volName;
}
@end
*/

@interface amFlashDevices : NSObject {
    
    
}

@property (nonatomic,retain) NSMutableArray *vols;

- (NSString*) getBSD:(NSInteger)selected;
- (NSString*) getVol:(NSInteger)selected;

@end
