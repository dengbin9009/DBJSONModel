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
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bool" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    if (textFileContents == nil) {
        DBModelLog(@"Error reading text file. %@", [error localizedFailureReason]);
        return;
    }
    _textView.text = textFileContents;
    
    BoolDataModel *boolSet = [BoolDataModel DB_modelWithJson:textFileContents];
    NSLog(@"boolSet:\n%@",boolSet);
}

@end
