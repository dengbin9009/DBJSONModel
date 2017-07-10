//
//  StudentDataModel.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "PersonDataModel.h"

@protocol StudentDataModel <NSObject>

@end

@interface StudentDataModel : PersonDataModel

/*! 分数 */
@property (nonatomic, copy) NSString *score;

/*! 是否班干 */
@property (nonatomic, assign) BOOL isClassLeader;


@end

