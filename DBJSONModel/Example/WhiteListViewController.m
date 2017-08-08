//
//  WhiteListViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "WhiteListViewController.h"
#import "WholeClassDataModel_White.h"

@interface WhiteListViewController ()

@end

@implementation WhiteListViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSString *textFileContents = [self getJsonFormFileName:@"wholeClass"];
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        WholeClassDataModel_White *wholeClass = [WholeClassDataModel_White DB_modelWithJson:textFileContents];
        NSLog(@"wholeClass:\n%@",wholeClass);
    });
}

@end
