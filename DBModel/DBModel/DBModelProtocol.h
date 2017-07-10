//
//  DBModelProtocol.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#ifndef DBModelProtocol_h
#define DBModelProtocol_h

@protocol DBModelProtocol <NSObject>
@optional

+ (NSDictionary *)customKeyMapper;

+ (NSDateFormatter *)dateFormatterMapperForKey:(NSString *)key;

+ (NSArray *)modelPropertyWhiteList;

+ (NSArray *)modelPropertyBlackList;


@end

@protocol Ignore
@end


#endif /* DBModelProtocol_h */
