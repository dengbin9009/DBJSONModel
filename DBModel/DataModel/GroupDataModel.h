//
//  GroupDataModel.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentDataModel.h"

@class StudentDataModel;

@protocol GroupDataModel <NSObject>

@end

@interface GroupDataModel : NSObject

@property (nonatomic, strong) StudentDataModel *groupLeader;

@property (nonatomic, strong) NSArray<StudentDataModel> *groupMembers;

@end

