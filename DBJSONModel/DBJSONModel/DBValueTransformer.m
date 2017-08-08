//
//  DBValueTransformer.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "DBValueTransformer.h"

extern BOOL DB_isNull(id value)
{
    if (!value) return YES;
    if ([value isKindOfClass:[NSNull class]]) return YES;
    
    return NO;
}

// 可以直接赋值的对象
extern BOOL DB_isSimpleClass(Class cls)
{
    if ([cls isSubclassOfClass:[NSSet class]] ||
        [cls isSubclassOfClass:[NSString class]] ||
        [cls isSubclassOfClass:[NSNumber class]] ||
        [cls isSubclassOfClass:[NSDictionary class]] ||
        [cls isSubclassOfClass:[NSMutableSet class]] ||
        [cls isSubclassOfClass:[NSMutableString class]] ||
        [cls isSubclassOfClass:[NSDecimalNumber class]] ||
        [cls isSubclassOfClass:[NSMutableDictionary class]] ) {
        return YES;
    }
    return NO;
}

// 是个数组
extern BOOL DB_isArrayClass(Class cls){
    if ([cls isSubclassOfClass:[NSArray class]] ||
        [cls isSubclassOfClass:[NSMutableArray class]] ) {
        return YES;
    }
    return NO;
}


// 是个Date
extern BOOL DB_isDateClass(Class cls){
    if ([cls isSubclassOfClass:[NSDate class]] ) {
        return YES;
    }
    return NO;
}

// 对一些常用的BOOL处理
extern BOOL DB_boolSetWithObject(id objc){
    if ( DB_isNull(objc) ) return NO;
    if ( [objc isKindOfClass:[NSString class]] ) {
        NSString *objcStr = ((NSString *)objc).lowercaseString;
        if ( [objcStr isEqualToString:@"true"] ||
             [objcStr isEqualToString:@"yes"] ) return YES;
        else if ( objcStr.floatValue>0 ) return YES;
        else return NO;
    }
    else if ( [objc isKindOfClass:[NSNumber class]] ) {
        NSNumber *objcNumber = (NSNumber *)objc;
        if ( objcNumber.floatValue>0 ) return YES;
        else return NO;
    }
    else {
        return NO;
    }
}

// 对Date转换的处理
extern NSDate *DB_dateSetWithObject(id objc, NSDateFormatter *formatter){
    if ( DB_isNull(objc)) return nil;
    NSDate *date;
    if ( [objc isKindOfClass:[NSDate class]] ) {
        date = objc;
    }
    else if ( [objc isKindOfClass:[NSString class]] ) {
        if ( formatter && [formatter isKindOfClass:[NSDateFormatter class]] ) {
            date = [formatter dateFromString:objc];
        }
        else {
            static dispatch_once_t oneToken;
            static NSDateFormatter *dateFormatter;
            dispatch_once(&oneToken, ^{
                dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
                [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            });
            date = [dateFormatter dateFromString:objc];
        }
        // 如果转换失败，在尝试是不是时间戳
        if ( !date ) {
            date = [NSDate dateWithTimeIntervalSince1970:((NSString *)objc).integerValue];
        }
    }
    else if ( [objc isKindOfClass:[NSNumber class]] ) {
        date = [NSDate dateWithTimeIntervalSince1970:((NSNumber *)objc).unsignedIntegerValue];
    }
    return date;
}


@implementation DBValueTransformer
@end
