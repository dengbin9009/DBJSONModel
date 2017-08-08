//
//  ArrayViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "ArrayViewController.h"
#import "GroupDataModel.h"

@interface ArrayViewController ()

@end

@implementation ArrayViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"class"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *class = [GroupDataModel DB_arrayModelWithJson:textFileContents];
        NSLog(@"class:\n%@",class);
    });
}

@end
