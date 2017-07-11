//
//  CNumberViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "CNumberViewController.h"
#import "CNumberDataModel.h"

@interface CNumberViewController ()

@end

@implementation CNumberViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"CNumber"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CNumberDataModel *CNumber = [CNumberDataModel DB_modelWithJson:textFileContents];
        NSLog(@"CNumber:\n%@",CNumber);
    });
}

@end
