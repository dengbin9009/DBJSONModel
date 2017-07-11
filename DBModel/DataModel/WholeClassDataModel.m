
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
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        return dateFormatter;
    }
    return nil;
}


@end
