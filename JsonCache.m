//
//  JsonCache.m
//  sailr
//
//  Created by Nathan Feiglin on 26/09/2014.
//  Copyright (c) 2014 Sailr. All rights reserved.
//

#import "JsonCache.h"

@implementation JsonCache
- (void)getObjectFromJson:(NSString *)key success:(void (^)(id object))success failure:(void (^)(NSError *error))failure {

    NSError *error = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *data = [FileCache retrieveString:key success:^(NSString *string) {
            id object = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSStringEncodingConversionExternalRepresentation] options:NSJSONReadingAllowFragments error:&error];
            
        } failure:^(NSError *error) {
            failure(error);
        }];
    });

    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        
        NSError *error = nil;

        if (error) {
            failure(error);
        }
        
        else {
            success(object);
        }
    });
    
}
@end
