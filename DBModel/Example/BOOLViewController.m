//
//  BOOLViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "BOOLViewController.h"
#import "BoolDataModel.h"

@interface BOOLViewController ()

@end

@implementation BOOLViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"bool"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BoolDataModel *boolSet = [BoolDataModel DB_modelWithJson:textFileContents];
        NSLog(@"boolSet:\n%@",boolSet);
    });
}

@end
