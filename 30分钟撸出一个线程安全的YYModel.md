
### 首图震帖

![震帖图](http://i1.17173cdn.com/2fhnvk/YWxqaGBf/cms3/JJlpeKblbjlfEsj.jpg)

### 前言

做iOS开发以来，从最开始没有数据模型，所有数据都靠```NSString```，```NSDictionary```，```NSArrray```等系统基础的对象存储，到后来自己开始手动撸数据模型，再然后就开始接触```JSONModel```，彻底脱离了枯燥的重复的动作，后来一些国产的一些优秀的数据模型库也开始崭露头角，如```MJExtension```,如```YYModel```等。但别人的轮子始终是别人的，要是中途爆了胎还得去人家的店里(Github)提出问题，等待修复，可是现实中大多数的时候时间都不允许我们这样慢慢的等待，所以就有了这篇文章。

在这篇文章中，你可以了解到一些实用的```Runtime```技巧，一些面向对象的思想，最重要的是可以自己做出一个可以供自己扩展的数据模型轮子。轮子虽小但优点在于方便理解，扩展性强。

废话不多说，直接进入正题。

### 一张图说目标功能

<center>![功能图解](https://github.com/dengbin9009/MyFiles/blob/master/DBModel功能图.png?raw=true)</center>

### 想一想别人的轮子

要将数据模型的实现原理，先回想一下我们平时是怎么用别人的数据模型的。

* 首先我们需要根据服务端返回数据格式在我们一个对应的DataModel里面将所有的参数名称定义好，并且定义好对应的类型，如：

	```objectivec
	@interface PersonDataModel : NSObject
	
	@property (nonatomic ,assign) NSUInteger age;
	@property (nonatomic ,copy  ) NSString *name;
	@property (nonatomic ,copy  ) NSString *sex;
	
	@end
	```

* 然后我们传入一个```NSString```或者```NSData```之类的东西，总之最后我们将它转化为```NSDictionary```，然后就有了我们需要的一个完整的数据模型。如JSONModel的使用方法：

	```objectivec
	PersonDataModel *person = [[PersonDataModel alloc]initWithString:jsonString error:NULL];
	```

所以就有了我们的设计思路


### 得出设计思路

* 首先我们利用```Runtime```将```PersonDataModel```中所有的有用信息记录到最重要的```ClassPropertyInfo```（在下面Lists中会讲出有哪些需要记录的信息）。
* 从而得到```ClassInfo```（这里暂时用不到```MethodInfo```和```IvarInfo```）。
* 区分需要转化的对象是```NSDictionary```还是```NSArray```。
* 将```NSDictionary```中的```Key```与我们刚才记录在```ClassPropertyInfo```中的```name```进行对比。

	>  ```NSArray```拆分成多个```NSDictionary```(或者```String```)做。
	
	>	暂时不支持```NSArray```中又是```NSArray```对象。
* 将对比上的Key进行差异化赋值。
	

![](https://github.com/dengbin9009/MyFiles/blob/master/DBModel思维导图.png?raw=true)	

下面我们就来实现具体的步骤
	
### Step
	
* ####获取关键的```ClassPropertyInfo```信息

	一条比较丰富的属性长这样：
	
 ```objectivec
	@property (nonatomic, strong ,setter=setGroup: ,getter=group) NSArray<Student> * group;
 ```
 
 可以看出这个地方对我们有用的有```setter```，```getter```，```NSArray```，```Student```和```group```，当然其中的```nonatomic```和```strong```也是一些有用的信息，但我们目前姑且不谈。
 
 关于property苹果在*```<objc/runtime.h>```*中给了我们这些Api，如图
 ![Runtime_Property] (https://github.com/dengbin9009/MyFiles/blob/master/Runtime_Property.png?raw=true)
 
 其中```name```就可以通过下面这个Api得到是```group```
 
 ```objectivec
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
 
 其它的都可以在苹果给我们的另外一个Api中全部获取到
 
 	```objectivec
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

	```objectivec
	/// Defines a property attribute
	typedef struct {
    	const char *name;           /**< The name of the attribute */
    	const char *value;          /**< The value of the attribute (usually empty) */
	} objc_property_attribute_t;	
	```

 这里的这里```name ```和```value ```的定义可以参考：
 
 * *[关于objc_property_attribute_t的value和name](http://blog.csdn.net/dengbin9009/article/details/72920882)*.
 
 ```name ```包括*```N```*，*```&```*，*```W ```*，*```R```*，*```G```*，*```S```*，*```V```*，*```T```*。
 
 这里面的```G ```，```S ```正好对应```getter```，```setter```，这两个比较好理解，都是对应SEL的name，不过这个这个时候通过value取出来的是一个char型字符串，这个要注意一下。比如```getter```就是```"group"```，```setter```就是```"setGroup:"```。
 
 ```T ```就稍稍复杂一点一些，这里的```T ```就是```@\"NSArray<Student>"\```（如果有两个```protocol```则是```@\"NSArray<Student><Student2>```），我们可以将它分为三部分```@```，```NSArray```和```Student ```。其中```NSArray```是这个属性的```Class```，```Student ```是对应的```protocols```，因为```protocols```可能有多个，所以它是个数组。同样的它们也都是```char```型字符串。
 
 #####最关键的是前面的```@```它代表这个```property```是个对象，具体这个```char```所对应的含义可以参考：#####
 	* *[iOS方法返回值和参数对应的Type Encodings](http://blog.csdn.net/dengbin9009/article/details/72922244)*
 
 #####其实在*```objc/runtime.h```*第1560行至1589行中也有对应的描述。我们将```@```这样的字符串单独存入一个新定义的属性```type```中#####
 
 ---
 这里有个*```Tip```*可以有效的将```@\"NSArray<Student><Student2>```分成```NSArray```，```Student ```，```Student2 ```这样的数组。
 
 ```objectivec
 NSString *type = @"@\"NSArray<Student><Student2>";
 NSMutableArray *values = [type componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@\"<>,"]].mutableCopy;
 [values removeObject:@""];
 // 最终values = @[@"NSArray",@"Student",@"Student2"];
 ```
 ---
 
 到这里关于一条```Property```最重要的一些信息我们都得到了：
 
 	* ```cls ```：```NSArray```
	* ```name ```：```group ```
	* ```type ```：```@```
	* ```getterSel ```：```@selector(group)```
	* ```setterSel ```：```@selector(setGroup:) ```
	* ```protocols ```：```Student```
 	
 
 然后在补上一些能够让我们更方便使用的属性，比如：
 
 	* ```property```：通过*runtime*取出的的*property*本身
 	* ```isCustomPropetry```：是否是系统类
 	* ```isMutable```：是否是系统类里面的可变类型
 	* ```superClsInfo```：父类*ClassInfo*，如果父类为*nil*，则它也是*nil*

 
 
* ####获取关键的```ClassInfo```信息
 
 ```ClassInfo```中对于本文的有用信息不多，目前我们只取：
 
 * ```name```：类名，如这里的```person```
 * ```cls```：类本身，如这里的```PersonDataModel```
 * ```propetryInfos```：参考第一步
 
 		> *获取关键的```ClassPropertyInfo```信息*
 * ```superClsInfo ```：父类的```ClassInfo```，可用一个递归方法实现。
 
			 
			+ (instancetype)classInfoWithClass:(Class)cls{
			    if ( !cls ) return nil;
			    ...
			    if ( !classInfo ) {
			        classInfo = [[DBClassInfo alloc] initWithClass:cls];
			    }
			    return classInfo;
			}
				
			- (instancetype)initWithClass:(Class)cls{
			    if ( !cls ) return nil;
			    self = [super init];
			    if ( self ) {
					...
					_superCls = class_getSuperclass(cls);
					_superClsInfo = [DBClassInfo classInfoWithClass:_superCls];
					...
			    }
			    return self;
			}
			
      由于classInfoWithClass是个类方法，所以这一步一定要确保线程安全，具体方式可以见 *[Demo](https://github.com/dengbin9009/DBModel.git)*
			
* ####区分需要转化的对象是```NSDictionary```还是```NSArray```。

 * 一般入参有四种
	 
	   1. ```NSDate```
	   2. ```NSString```
	   3. ```NSArray ```
	   4. ```NSDictionary ```
 * 这里只详细介绍```NSDictionary ```的处理方式,因为无论是```NSDate```还是```NSString ```我们最终都要转化为```NSDictionary ```或者```NSArray ```，而```NSArray```通常情况下也是将起转化为一个个```NSDictionary ```的来进行相应的处理的。
 
 		> *如果NSArray中是都是NSString那么就不需要用到数据模型，如果NSArray中也是NSArray，本类暂不支持这样的JSON格式。在本文也就不做讲述*

* ####将```NSDictionary```中的```Key```与我们刚才记录在```ClassPropertyInfo```中的```name```进行对比。对比方式嘛就是轮询。

  在这一步我们的目的是得到在我们```DataModel```中的每个```ClassPropertyInfo```对应的在```NSDictionary```中```object```。
  
  这句话读起来可能比较绕口：所以我们举个🌰：
  
  还是上文定义的```PersonDataModel```
	
  这个时候传入的NSDictionary是
	> { "name": "小明","age": 18,"sex": "男"}
	
  那么这个时候我们要找到的就是```PersonDataModel```中```name```为```sex```的```ClassPropertyInfo```和它对应的```Value``````男```
  
  而在这个地方我们就可以做一些比较有意思的事情了，比如白名单黑名单过滤，比如属性名称的映射，而这些有意思的方法可以将它都归为一个```Option```的协议，并将所有协议单独归类出一个文件```DBModelProtocol```，这样方便阅读，也方便维护。
	> 白名单黑名单比较好理解，就是在对应的Model里面接受对应的名单实现是否对这个属性进行赋值或者不赋值。具体使用类似实现以下两个协议即可
	
	```
	+ (NSArray *)modelPropertyBlackList{
	    return @[@"teacher",@"groupCount",@"groupArray"];
	}

	+ (NSArray *)modelPropertyWhiteList{
	    return @[@"teacher",@"groupCount",@"groupArray"];
	}
	```
	
	> 属性名称的映射其实就我常用的重命名，比如服务器返回了我们一个```key```为```id```,但```id```是一个隐藏的系统关键字,我们一个会将它重命名为```personId```或者```teacherId```等更容易理解的属性名称

	
	我们重新在```PersonDataModel```的基础上定义一个```TeacherDataModel ```的数据模型
	
	```
	@interface TeacherDataModel : PersonDataModel
	@property (nonatomic, assign) NSUInteger teacherId;
	@end

	```
	
	而服务端返回给我们数据模型却是
	> { "id": "110", "name": "黄卫民", "age": 38, "sex": "男"}
	
	这个时候我们就可以在这一步进行一些差异化的对比了：
	
	首先我们先实现协议：
	
	```
	+ (NSDictionary *)customKeyMapper{
	    return @{@"id":@"teacherId"};
	}

	```
	
	当我们轮询到```TeacherDataModel```的```name```为```teacherId```的```ClassPropertyInfo```时取出的```NSDictionary```中对应```key```为```id```的```object```。
	
	
* ####将对比上的```name```的```DBClassPropertyInfo```的和```object```进行差异化赋值。

 这一步是逻辑最简单，但也是实现起来最繁琐的一步。
 
  * ```DBClassPropertyInfo```中的```type```可以让我们知道这个```property```是什么类型，上文有讲述。
  * 将```object```转化为对应的```property```的类型
  	> 这一步我们新建一个新的文件```DBValueTransformer```来帮我们做这些数据的处理，并且在这一步我们也可以插入我们的一个协议(```NSString```->```NSDate```)
  	
  * 再利用```objc_msgSend```进行赋值

  
 进行到这已经完成对一个```NSDictionary```->```DataModel```的全过程。
 
### 小结

 虽然本文只是讲述了```NSDictionary```->```DataModel```的过程，没有其他的Model功能那么完善，如：
 
 * ```Model->Json```
 * ```Model```比较
 * 深拷贝
 
但我相信如果能看到这里的同学对其他功能应该是已经可以手到擒来了。
 
做事之前先理清楚思路，功能点全部归好类才能更好帮助我们完成它！

本文所有代码可以在这里找到:*[Demo](https://github.com/dengbin9009/DBModel.git)*

 
### 参考

* [YYModel](https://github.com/ibireme/YYModel.git)
* [JSONModel](https://github.com/jsonmodel/jsonmodel.git)



	

 

 
  
  
	

