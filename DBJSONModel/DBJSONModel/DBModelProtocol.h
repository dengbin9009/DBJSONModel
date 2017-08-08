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

/*!
 *  自定义属性的映射关系
 *  实现了这个方法但返回的是nil或者空字典等同于不实现这个方法
 *  实现了这个方法但是非字典类型,会导致映射失败
 *  @return NSDictionary
 *  @since 0.5
 */
+ (NSDictionary *)customKeyMapper;

/*!
 *  在对应的key上返回对应格式的NSDate类型
 *  @param key 一个属性的name
 *  @return NSDateFormatter
 *  @since 0.5
 */
+ (NSDateFormatter *)dateFormatterMapperForKey:(NSString *)key;

/*!
 *  白名单
 *  实现了这个方法但返回的是nil或者空数组等同于不实现这个方法
 *  实现了这个方法但是非数组类型,等效于没有白名单
 *  @return NSArray
 *  @since 0.5
 */
+ (NSArray *)modelPropertyWhiteList;

/*!
 *  黑名单
 *  实现了这个方法但返回的是nil或者空数组等同于不实现这个方法
 *  实现了这个方法但是非数组类型,等效于没有黑名单
 *  @return NSArray
 *  @since 0.5
 */
+ (NSArray *)modelPropertyBlackList;


@end

/*!
 *  允许忽略某个属性
 *  如：@property (nonatomic, strong) NSDate <Ignore>*openDate;
 *  @since 0.5
 */
@protocol Ignore
@end


#endif /* DBModelProtocol_h */
