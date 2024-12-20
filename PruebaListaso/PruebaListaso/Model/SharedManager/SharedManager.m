//
//  SharedManager.m
//  PruebaListaso
//
//  Created by Rene B on 12/20/24.
//

#import "SharedManager.h"

@implementation SharedManager + (instancetype)sharedInstance {
    static SharedManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedInstance = [[self alloc] init]; });
    return sharedInstance;
    
}
@end

