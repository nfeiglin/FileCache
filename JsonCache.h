//
//  JsonCache.h
//  sailr
//
//  Created by Nathan Feiglin on 26/09/2014.
//  Copyright (c) 2014 Sailr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileCache.h"
@interface JsonCache : NSObject
- (void)getObjectFromJson:(NSString *)key success:(void (^)(id object))success failure:(void (^)(NSError *error))failure;

@end
