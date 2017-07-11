//
//  WholeClassDataModel.h
//  DBModel
//
//  Created by DaBin on 2017/7/11.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupDataModel.h"
#import "TeacherDataModel.h"

@interface WholeClassDataModel : NSObject

@property (nonatomic, strong) TeacherDataModel *teacher;

@property (nonatomic, assign) NSInteger groupCount;

@property (nonatomic, strong) NSArray<GroupDataModel> *groupArray;

@property (nonatomic, assign) BOOL isWonderfulClass;

// 开学时间
@property (nonatomic, strong) NSDate *openDate;
// 放学时间
@property (nonatomic, strong) NSDate *closeDate;
// 郊游时间
@property (nonatomic, strong) NSString *outingDate;

@end
