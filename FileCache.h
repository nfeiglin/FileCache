//
//  FileCache.h
//  sailr
//
//  Created by Nathan Feiglin on 26/09/2014.
//  Copyright (c) 2014 Sailr. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileWriteable
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag;
@end

@interface FileCache : NSObject

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *documentsPath;

/*
- (void)cacheString:(NSString *)string forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (NSString *)retrieveString:(NSString *)key success:(void (^)(NSString *string))success failure:(void (^)(NSError *error))failure;
*/

- (void)doesCachedFileExistForKey:(NSString *)key success:(void (^)())existsCallback doesntExists:(void (^)())doesntExistCallback;

- (void)cacheArray:(NSArray *)array forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)getArrayForKey:(NSString *)key success:(void (^)(NSArray *array))success failure:(void (^)(NSError *error))failure;

- (void)cacheDictionary:(NSDictionary *)dictionary forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure;
- (void)getDictionaryForKey:(NSString *)key success:(void (^)(NSDictionary *dictionary))success failure:(void (^)(NSError *error))failure;

- (void)cacheObject:(id<FileWriteable>)object forKey:(NSString *)key success:(void (^)())success failure:(void (^)(NSError *error))failure;

@end
