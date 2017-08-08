//
//  BlackListViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "BlackListViewController.h"
#import "WholeClassDataModel_Black.h"

@interface BlackListViewController ()

@end

@implementation BlackListViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"wholeClass"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WholeClassDataModel_Black *wholeClass = [WholeClassDataModel_Black DB_modelWithJson:textFileContents];
        NSLog(@"wholeClass:\n%@",wholeClass);
    });
}

@end
