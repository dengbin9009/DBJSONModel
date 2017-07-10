//
//  ClassDataModel.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupDataModel.h"
#import "TeacherDataModel.h"

@interface ClassDataModel : NSObject

@property (nonatomic, strong) TeacherDataModel *teacher;

@property (nonatomic, assign) NSInteger groupCount;

@property (nonatomic, strong) NSArray<GroupDataModel> *groupArray;

@property (nonatomic, assign) BOOL isWonderfulClass;

@end


