//
//  SimpleViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "SimpleViewController.h"
#import "PersonDataModel.h"

@interface SimpleViewController ()

@end

@implementation SimpleViewController


- (void)valeTransformer:(id)sender{
    NSLog(@"%s",__func__);
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"person" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    if (textFileContents == nil) {
        DBModelLog(@"Error reading text file. %@", [error localizedFailureReason]);
        return;
    }
    _textView.text = textFileContents;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PersonDataModel *person = [PersonDataModel DB_modelWithJson:textFileContents];
        NSLog(@"person:\n%@",person);
    });

}

@end
