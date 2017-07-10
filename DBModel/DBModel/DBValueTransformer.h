//
//  DBValueTransformer.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! 是否是一个有效的值 */
extern BOOL DB_isNull(id value);
/*! 可以直接赋值的对象 */
extern BOOL DB_isSimpleClass(Class cls);
/*! 是个数组 */
extern BOOL DB_isArrayClass(Class cls);
/*! 是否是个NSDate */
extern BOOL DB_isDateClass(Class cls);
/*! 对一些常用的BOOL处理*/
extern BOOL DB_boolSetWithObject(id objc);
/*! 对Date转换的处理 */
extern NSDate *DB_dateSetWithObject(id objc, NSDateFormatter *formatter);


@interface DBValueTransformer : NSObject
@end
