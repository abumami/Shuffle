//
//  amFlashDevices.m
//  Shuffle
//
//  Created by Abu Mami on 7/15/14.
//
//

#import "amFlashDevices.h"


#include <sys/param.h>
#include <sys/mount.h>

@implementation amFlashDevices

@synthesize vols;

- (id)init {
    self = [super init];
    if (self == nil)
        return nil;
    [self listFlash];
    return self;
}

- (NSString*) getBSD:(NSInteger)selected {
    NSDictionary *d = [vols objectAtIndex:selected];
    return [d objectForKey:@"bsd"];
}

- (NSString*) getVol:(NSInteger)selected {
    NSDictionary *d = [vols objectAtIndex:selected];
    return [d objectForKey:@"vol"];
}

- (void) listFlash
{
    vols = [NSMutableArray array];
    
    //Fetch the NSArray of strings of mounted media from the shared workspace
	NSArray * volumes = [[NSWorkspace sharedWorkspace] mountedRemovableMedia];
	
	//Setup target variables for the data to be put into
	BOOL isRemovable, isWritable, isUnmountable;
	NSString * description, * volumeType;
	
	//Iterate through the array using fast enumeration
	for (NSString *volumePath in volumes) {
		//Get filesystem info about each of the mounted volumes
		if ([[NSWorkspace sharedWorkspace] getFileSystemInfoForPath:volumePath isRemovable:&isRemovable isWritable:&isWritable isUnmountable:&isUnmountable description:&description type:&volumeType]) {
            
			// save in array of flash devices
            struct statfs tStats;
            statfs([volumePath UTF8String], &tStats);
            NSString *bsd = [NSString stringWithUTF8String:tStats.f_mntfromname];
            printf("%s\n", [[NSString stringWithFormat:@"%@	%@ %@	%@	%d	%d	%d", volumePath, bsd, description, volumeType, isRemovable, isWritable, isUnmountable] UTF8String]);
            //[vols addObject:bsd];
            
            NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys:
                                   volumePath, @"vol",
                                   bsd, @"bsd",
                                   nil];
            [vols addObject:entry];
		}
	}
}


@end
