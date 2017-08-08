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

/*!
 *  JSON->数据模型
 *  @param json 可以是NSDate，NSString，或者一个NSDictionary
 *  @return 对应的一个数据模型
 *  @since 0.5
 */
+ (instancetype)DB_modelWithJson:(id)json;

/*!
 *  NSDictionary->Model
 *  @param dictionary 一个NSDictionary
 *  @return 对应的一个数据模型
 *  @since 0.5
 */
+ (instancetype)DB_modelWithDictionary:(NSDictionary *)dictionary;

/*!
 *  JSON->包含数据模型的数组
 *  @param json 可以是NSDate，NSString，或者一个NSArray
 *  @return 包含数据模型的数组
 *  @since 0.5
 */
+ (NSArray *)DB_arrayModelWithJson:(id)json;

/*!
 *  NSArray->包含数据模型的数组
 *  @param array NSArray
 *  @return 包含数据模型的数组
 *  @since 0.5
 */
+ (NSArray *)DB_arrayModelWithArray:(NSArray *)array;

@end
