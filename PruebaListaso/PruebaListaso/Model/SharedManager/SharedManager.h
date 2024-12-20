//
//  SharedManager.h
//  PruebaListaso
//
//  Created by Rene B on 12/20/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedManager : NSObject
@property (nonatomic, strong) NSString *sharedData;
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
