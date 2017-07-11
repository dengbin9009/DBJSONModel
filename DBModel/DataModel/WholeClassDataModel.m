
//
//  WholeClassDataModel.m
//  DBModel
//
//  Created by DaBin on 2017/7/11.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "WholeClassDataModel.h"

@implementation WholeClassDataModel

+ (NSDateFormatter *)dateFormatterMapperForKey:(NSString *)key{
    if ( [key isEqualToString:@"closeDate"] ) {
        static dispatch_once_t oneToken;
        static NSDateFormatter *closeDateFormatter = nil;
        dispatch_once(&oneToken, ^{
            closeDateFormatter = [[NSDateFormatter alloc] init];
            closeDateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
            closeDateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            [closeDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        });
        return closeDateFormatter;

    }
    return nil;
}


@end
