
### 前言

做iOS开发以来，从最开始没有数据模型，所有数据都靠```NSString```，```NSDictionary```，```NSArrray```等系统基础的对象存储，到后来自己开始手动撸数据模型，再然后就开始接触```JSONModel```，彻底脱离了枯燥的重复的动作，后来一些国产的一些优秀的数据模型库也开始崭露头角，如```MJExtension```,如```YYModel```等。但别人的轮子始终是别人的，要是中途爆了胎还得去人家的店里(Github)提出问题，等待修复，可是现实中大多数的时候时间都不允许我们这样慢慢的等待，所以就有了这篇文章。

在这篇文章中，你可以了解到一些实用的```Runtime```技巧，一些面向对象的思想，最重要的是可以自己做出一个可以供自己扩展的数据模型轮子。轮子虽小但优点在于方便理解，扩展性强。

废话不多说，直接进入正题。

### 想一想别人的轮子

要将数据模型的实现原理，先回想一下我们平时是怎么用别人的数据模型的。

1、首先我们需要根据服务端返回数据格式在我们一个对应的DataModel里面将所有的参数名称定义好，并且定义好对应的类型，如：

```
@interface Person : NSObject

@property (nonatomic ,assign) NSUInteger age;
@property (nonatomic ,copy  ) NSString *name;
@property (nonatomic ,copy  ) NSString *sex;

@end
```

然后我们传入一个```NSString```或者```NSData```之类的东西，总之最后我们将它转化为```NSDictionary```，然后就有了我们需要的一个完整的数据模型。如JSONModel的使用方法：
```
Person *person = [[Person alloc]initWithString:jsonString error:NULL];
```

所以就有了我们的设计思路


### 设计思路

* 首先我们利用```Runtime```将Person中所有的有用信息记录到```ClassPropertyInfo```（在下面Lists中会讲出有哪些需要记录的信息）。
* 区分需要转化的对象是```NSDictionary```还是```NSArray```。
* 将```NSDictionary```中的```Key```与我们刚才记录在```ClassPropertyInfo```中的```name```进行对比。
* 将对比上的Key进行差异化赋值。
	
下面我们就来实现具体的步骤
	
### Lists
	
* 一条比较丰富的属性长这样：
 ```
	@property (nonatomic, strong ,setter=setGroup: ,getter=group) NSArray<Student> * group;
 ```
 
 可以看出这个地方对我们有用的有```setter```，```getter```，```NSArray```，```Student```和```group```，当然其中的```nonatomic```和```strong```也是一些有用的信息，但我们目前姑且不谈。
 
 关于property苹果在```<objc/runtime.h>```中给了我们这些Api，如图
 ![Runtime_Property] (https://github.com/dengbin9009/MyFiles/blob/master/Runtime_Property.png?raw=true)
 
 其中group就可以通过
 
 ```
 /** 
 * Returns the name of a property.
 * 
 * @param property The property you want to inquire about.
 * 
 * @return A C string containing the property's name.
 */
OBJC_EXPORT const char *property_getName(objc_property_t property) 
    OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0);
 ```
 得到。
 
 其他的都可以在苹果给我们的另外一个Api中全部获取到
 
 	```
	/** 
	 * Returns an array of property attributes for a property. 
	 * 
	 * @param property The property whose attributes you want copied.
	 * @param outCount The number of attributes returned in the array.
	 * 
	 * @return An array of property attributes; must be free'd() by the caller. 
	 */
	OBJC_EXPORT objc_property_attribute_t *property_copyAttributeList(objc_property_t property, unsigned int *outCount)
	    OBJC_AVAILABLE(10.7, 4.3, 9.0, 1.0);
	```
 
 而这个函数取出来的是一个关于```objc_property_attribute_t ```的数组，而```objc_property_attribute_t```是一个这样的结构题：

		/// Defines a property attribute
		typedef struct {
	    	const char *name;           /**< The name of the attribute */
	    	const char *value;          /**< The value of the attribute (usually empty) */
		} objc_property_attribute_t;	

 这里的这里```name ```和```value ```的定义可以参考：[关于objc_property_attribute_t的value和name](http://blog.csdn.net/dengbin9009/article/details/72920882).```name ```包括```N```，```&```，``````，``````，``````，``````，``````，``````，``````
 
 这里面的```G ```，```S ```正好对应```getter```，```setter```，这两个比较好理解，都是对应SEL的name，不过这个这个时候通过value取出来的是一个char型字符串，这个要注意一下。比如```getter```就是```"group"```，```setter```就是```"setGroup:"```。
 
 ```T ```就稍稍复杂一点一些，这里的```T ```就是```@\"NSArray<Student>"\```（如果有两个protocol则是@\"NSArray<Student><Student2>），其中```NSArray```是这个属性的```Class```，```Student ```是对应的```protocols```，因为```protocols```可能有多个，所以他是个数组。同样的他们也都是```char```型字符串。最关键的是前面的```@```它代表这个```property```是个对象，具体这个```char```所对应的含义可以参考[iOS方法返回值和参数对应的Type Encodings](http://blog.csdn.net/dengbin9009/article/details/72922244)，其实在```objc/runtime.h```第1560行至1589行中也有对应的描述。
 
 这里有个Tip可以有效的将```@\"NSArray<Student><Student2>```分成```NSArray```，```Student ```，```Student2 ```这样的数组。
 
 ```
 NSMutableArray *values = [_type componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\"<>,"]].mutableCopy;
 [values removeObject:@""];
 ```

	
	

