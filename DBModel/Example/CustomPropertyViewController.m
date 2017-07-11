//
//  CustomPropertyViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "CustomPropertyViewController.h"
#import "GroupDataModel.h"

@interface CustomPropertyViewController ()

@end

@implementation CustomPropertyViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"group"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        GroupDataModel *group = [GroupDataModel DB_modelWithJson:textFileContents];
        NSLog(@"group:\n%@",group);
    });
}

@end
