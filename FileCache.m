//
//  FileCache.m
//  sailr
//
//  Created by Nathan Feiglin on 26/09/2014.
//  Copyright (c) 2014 Sailr. All rights reserved.
//

#import "FileCache.h"

@implementation FileCache

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.fileManager = [NSFileManager defaultManager];
        self.documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    }
    
    return self;
    
}

- (BOOL)doesFileExistForKey:(NSString *)key {
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
    BOOL fileExists = [self.fileManager fileExistsAtPath:filePath];
    
    return fileExists;
}

- (NSString *)retrieveString:(NSString *)key success:(void (^)(NSString *string))success failure:(void (^)(NSError *error))failure {
    
    NSError *error = nil;
    if (! [self doesFileExistForKey:key]) {
        error = [[NSError alloc]initWithDomain:@"com.sailr.sailr" code:1 userInfo:@{ @"Desription": @"The file does not exist for the given key in the documents directory so it can not be retrieved"}];
            failure(error);
    }
    
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
    NSString *string = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionExternalRepresentation error:&error];
    if (error) {
        failure(error);
    }
    
    success(string);
    
    return string;


}

- (void)doesCachedFileExistForKey:(NSString *)key success:(void (^)())existsCallback doesntExists:(void (^)())doesntExistCallback {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        BOOL doesFileExist = [self doesFileExistForKey:key];
        
        if (doesFileExist && existsCallback) {
            existsCallback();
        }
        else if (doesntExistCallback) {
            doesntExistCallback();
        }
    });

}
- (void)cacheString:(NSString *)string forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure {
    
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
    NSError *error = nil;
    [string writeToFile:filePath atomically:YES encoding:NSStringEncodingConversionExternalRepresentation error:&error];
}

- (void)cacheDictionary:(NSDictionary *)dictionary forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
        BOOL isWritten = [dictionary writeToFile:filePath atomically:YES];
        
        if (!isWritten) {
            if (failure) {
                NSError *error = [[NSError alloc]initWithDomain:@"com.sailr.sailr" code:2 userInfo:@{ @"Desription": @"File not written"}];
                failure(error);
            }
        }
        
        else {
            
            if (success) {
                success();
            }
        }
    });
}

- (void)cacheArray:(NSArray *)array forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
        BOOL isWritten = [array writeToFile:filePath atomically:YES];
        
        if (!isWritten) {
            if (failure) {
                NSError *error = [[NSError alloc]initWithDomain:@"com.sailr.sailr" code:2 userInfo:@{ @"Desription": @"File not written"}];
                failure(error);
            }
        }
        
        else {
            
            if (success) {
                success();
            }
        }
    });
}

- (void)getArrayForKey:(NSString *)key success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
        NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
        
        if (!array) {
            if (failure) {
                NSError *error = [[NSError alloc]initWithDomain:@"com.sailr.sailr" code:2 userInfo:@{ @"Desription": @"File error or contents of file invalid for array"}];
                failure(error);
            }
        } else{
            success(array);
        }
    });
}

- (void)getDictionaryForKey:(NSString *)key success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSError *error))failure {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        if (!dict) {
            if (failure) {
                NSError *error = [[NSError alloc]initWithDomain:@"com.sailr.sailr" code:2 userInfo:@{ @"Desription": @"File error or contents of file invalid for dictionary"}];
                failure(error);
            }
        } else{
            success(dict);
        }
    });
}

- (void)cacheObject:(id<FileWriteable>)object forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *filePath = [self.documentsPath stringByAppendingPathComponent:key];
        BOOL isWritten = [object writeToFile:filePath atomically:YES];
        
        if (!isWritten) {
            if (failure) {
                NSError *error = [[NSError alloc]initWithDomain:@"com.sailr.sailr" code:2 userInfo:@{ @"Desription": @"File not written"}];
                failure(error);
            }
        }
        
        else {
            
            if (success) {
                success();
            }
        }
    });
}

@end
