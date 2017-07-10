//
//  NSObject+DBModel.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBModelProtocol.h"


/*!
 *  目前只实现几种常用的格式
 *  1、NSString 2、BOOL 3、CNumber(float)等 4、NSDate
 *  @since 0.5
 */

@interface NSObject (DBModel)<DBModelProtocol>

+ (instancetype)DB_modelWithJson:(id)json;

+ (instancetype)DB_modelWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)DB_arrayModelWithJson:(id)json;

+ (NSArray *)DB_arrayModelWithArray:(NSArray *)array;

@end
