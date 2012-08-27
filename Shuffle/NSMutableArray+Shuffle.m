//
//  NSMutableArray+Shuffle.m
//  Shuffle
//
//  Created by Abu Mami on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableArray+Shuffle.h"

/*
// Chooses a random integer below n without bias.
// Computes m, a power of two slightly above n, and takes random() modulo m,
// then throws away the random number if it's between n and m.
// (More naive techniques, like taking random() modulo n, introduce a bias 
// towards smaller numbers in the range.)
static NSUInteger random_below(NSUInteger n) {
    
    if (n == 0) { return 0; }
    
    NSUInteger m = 1;
    
    // Compute smallest power of two greater than n.
    // There's probably a faster solution than this loop, but bit-twiddling
    // isn't my specialty.
    do {
        m <<= 1;
    } while(m < n);
    
    NSUInteger ret;
    
    do {
        ret = random() % m;
    } while(ret >= n);
    
    return ret;
}
*/

@implementation NSMutableArray (Shuffle)

- (void)shuffle {
    // http://en.wikipedia.org/wiki/Knuth_shuffle
    
    for(NSUInteger i = [self count]; i > 1; i--) {
        NSUInteger j = arc4random_uniform(i); //random_below(i); // arc4random_uniform(upper_bound)
        [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
    }
}

@end
