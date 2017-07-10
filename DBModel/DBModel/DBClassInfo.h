//
//  DBClassInfo.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

// 带有DBModelLog标记的Log输出，使用方法同NSLog
FOUNDATION_EXPORT void DBModelLog(NSString *format, ...);

@class DBClassPropertyInfo;

@interface DBClassInfo : NSObject

/*! 是否元类 */
@property (nonatomic, assign, readonly) BOOL isMeta;
/*! 类名 */
@property (nonatomic, copy) NSString *name;
/*! 类本身 */
@property (nonatomic, assign, readonly) Class cls;
/*! 元类 */
@property (nonatomic, assign, readonly) Class metaCls;
/*! 父类 */
@property (nullable, nonatomic, assign, readonly) Class superCls;
/*! 父类归档后的信息 */
@property (nullable, nonatomic, strong, readonly) DBClassInfo *superClsInfo;

/*! 属性 */
@property (nonatomic, strong) NSDictionary<NSString *,DBClassPropertyInfo *> *propetryInfos;

/*!
 *  初始化，保存这个类的所有属性，方法和ivar信息，这个方法线程安全
 *  @param cls Class
 *  @return DBClassInfo
 *  @since 0.5
 */
+ (instancetype)classInfoWithClass:(Class)cls;


@end

@interface DBClassPropertyInfo : NSObject

/*! Runtime中的property */
@property (nonatomic, assign, readonly) objc_property_t property;
/*! 属性的类<如：NSString *age中name是NSString> */
@property (nonatomic, assign, readonly) Class cls;
/*! 属性的name<如：NSString *age中name是name> */
@property (nonatomic, copy,   readonly) NSString *name;
/*! ivar的name<如：NSString *age中name是_name> */
@property (nonatomic, copy  , readonly) NSString *ivarName;
/*! type */
/*! 参考：http://blog.csdn.net/dengbin9009/article/details/72920882 */
/*! 或者在<objc/runtime.h>中1560~1589中查看，如 _C_INT  */
@property (nonatomic, copy  , readonly) NSString *type;
/*! Getter */
@property (nonatomic, assign, readonly) SEL getterSel;
/*! Setter */
@property (nonatomic, assign, readonly) SEL setterSel;
/*! 是否是可变类型 */
@property (nonatomic, assign, readonly) BOOL isMutable;
/*! 是否是自定义的属性 */
@property (nonatomic, assign, readonly) BOOL isCustomPropetry;
/*! 准守的协议，可为空 */
@property (nullable, nonatomic, strong, readonly) NSArray<NSString *> *protocols;

/*! 父类归档后的信息 */
@property (nullable, nonatomic, strong, readonly) DBClassInfo *superClsInfo;


/*!
 *  初始化
 *  @param property objc_property_t
 *  @return DBClassPropertyInfo或者nil
 *  @since 0.5
 */
- (instancetype)initWithProperty:(objc_property_t)property;

@end

NS_ASSUME_NONNULL_END
