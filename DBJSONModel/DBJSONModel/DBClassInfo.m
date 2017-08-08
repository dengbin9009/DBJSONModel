//
//  DBClassInfo.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "DBClassInfo.h"

void DBModelLog(NSString *format, ...) {
    va_list args;
    NSString *logString = [NSString stringWithFormat:@"DBModelLog:\n%@",format];
    va_start(args, format);
    NSLogv(logString, args);
    va_end(args);
}

@interface DBClassInfo ()

@end

@implementation DBClassInfo

+ (instancetype)classInfoWithClass:(Class)cls{
    if ( !cls ) return nil;
    static CFMutableDictionaryRef metaCache;
    static CFMutableDictionaryRef classCache;
    static dispatch_once_t oneToken;
    static dispatch_semaphore_t lock;
    dispatch_once(&oneToken, ^{
        metaCache = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                              0,
                                              &kCFTypeDictionaryKeyCallBacks,
                                              &kCFTypeDictionaryValueCallBacks);
        classCache = CFDictionaryCreateMutable(kCFAllocatorDefault,
                                               0,
                                               &kCFTypeDictionaryKeyCallBacks,
                                               &kCFTypeDictionaryValueCallBacks);
        lock = dispatch_semaphore_create(1);
    });
    DBClassInfo *classInfo;
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    CFMutableDictionaryRef cache = class_isMetaClass(cls)?metaCache:classCache;
    classInfo = CFDictionaryGetValue(cache, (__bridge const void *)cls);
    dispatch_semaphore_signal(lock);
    
    if ( !classInfo ) {
        classInfo = [[DBClassInfo alloc] initWithClass:cls];
        if ( classInfo ) {
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            CFDictionarySetValue(cache, (__bridge const void *)cls, (__bridge const void *)classInfo);
            dispatch_semaphore_signal(lock);
        }
    }
    return classInfo;
}

+ (instancetype)classInfoWithClassName:(NSString *)clsName{
    Class cls = NSClassFromString(clsName);
    return  [self classInfoWithClass:cls];
}

- (instancetype)initWithClass:(Class)cls{
    if ( !cls ) return nil;
    self = [super init];
    if ( self ) {
        _cls = cls;
        const char *name = class_getName(cls);
        if ( name ) {
            _name = [NSString stringWithUTF8String:name];
        }
        _isMeta = class_isMetaClass(cls);
        if ( _isMeta ) {
            _metaCls = objc_getMetaClass(name);
        }
        _superCls = class_getSuperclass(cls);
        
        [self _update];
        _superClsInfo = [DBClassInfo classInfoWithClass:_superCls];
    }
    return self;
}

// 给ivar，属性，方法复制
- (void)_update{
    // 置空所有的属性
    _propertyInfos = nil;
    Class cls = _cls;
    
    // 属性
    unsigned int propertyCount = 0;
    objc_property_t *properties = class_copyPropertyList(cls, &propertyCount);
    NSMutableDictionary *propertyInfos = [NSMutableDictionary new];
    for (unsigned int index=0; index<propertyCount; index++) {
        objc_property_t aProperty = properties[index];
        DBClassPropertyInfo *aPropertyInfo = [[DBClassPropertyInfo alloc]initWithProperty:aProperty];
        if ( aPropertyInfo.name.length>0 ) {
            propertyInfos[aPropertyInfo.name] = aPropertyInfo;
        }
    }
    free(properties);
    
    _propertyInfos = propertyInfos;
}

@end


@interface DBClassPropertyInfo ()

@end

@implementation DBClassPropertyInfo

- (instancetype)initWithProperty:(objc_property_t)property{
    if ( !property ) return nil;
    self = [super init];
    if (self) {
        _property = property;
        const char *name = property_getName(property);
        if ( name ) {
            _name = [NSString stringWithUTF8String:name];
            _cls = objc_getClass(name);
        }
        unsigned int outCount=0;
        objc_property_attribute_t *attr = property_copyAttributeList(property, &outCount);
        for (unsigned int index=0; index<outCount; index++) {
            objc_property_attribute_t aAttr = attr[index];
            const char name = aAttr.name[0];
            switch (name) {
                    // 属性的类型
                case 'T':{
                    const char *type = aAttr.value;
                    _type = [NSString stringWithUTF8String:type];
                    // 例如："@\"NSDictionary<DBAlbumDelegate><DBAlbumDelegate2>\""
                    // 要输出结果NSDictionary,DBAlbumDelegate,DBAlbumDelegate2
                    NSMutableArray *values = [_type componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\"<>,"]].mutableCopy;
                    [values removeObject:@""];
                    if ( values.count <=0 ) continue;
                    NSString *clsName = values.firstObject;
                    if ( clsName.length>1 ) {
                        _cls = objc_getClass(clsName.UTF8String);
                        if ( [self isSystemClass:_cls] ) {
                            _isMutable = ([clsName rangeOfString:@"Mutable"].location != NSNotFound);
                            _isCustomProperty = NO;
                        }
                        else{
                            _isMutable = NO;
                            _isCustomProperty = YES;
                        }
                    }
                    [values removeObjectAtIndex:0];
                    _protocols = values;
                    break;
                }
                case 'V':
                    if (aAttr.value) {
                        _ivarName = [NSString stringWithUTF8String:aAttr.value];
                    }
                    break;
                case 'G':
                    if (aAttr.value) {
                        NSString *getter = [NSString stringWithUTF8String:aAttr.value];
                        _getterSel = NSSelectorFromString(getter);
                    }
                    break;
                case 'S':
                    if (aAttr.value) {
                        NSString *setter = [NSString stringWithUTF8String:aAttr.value];
                        _setterSel = NSSelectorFromString(setter);
                    }
                    break;
                default:
                    break;
            }
        }
        
    }
    
    if ( !_getterSel ) {
        _getterSel = NSSelectorFromString(_name);
    }
    if ( !_setterSel ) {
        NSString *setter = [NSString stringWithFormat:@"set%@%@:",[_name substringToIndex:1].capitalizedString,[_name substringFromIndex:1]];
        _setterSel = NSSelectorFromString(setter);
    }
    return self;
}

// 判断是不是系统类
- (BOOL)isSystemClass:(Class)Cls{
    NSBundle *mainB = [NSBundle bundleForClass:Cls];
    if (mainB == [NSBundle mainBundle]) {
        return NO;
    }
    else {
        return YES;
    }
}

@end
