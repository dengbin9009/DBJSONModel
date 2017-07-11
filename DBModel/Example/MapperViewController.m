//
//  MapperViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "MapperViewController.h"
#import "TeacherDataModel.h"

@interface MapperViewController ()

@end

@implementation MapperViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"teacher"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        TeacherDataModel *teacher = [TeacherDataModel DB_modelWithJson:textFileContents];
        NSLog(@"teacher:\n%@",teacher);

    });
}

@end
