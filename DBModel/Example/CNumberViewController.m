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
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CNumber" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    if (textFileContents == nil) {
        DBModelLog(@"Error reading text file. %@", [error localizedFailureReason]);
        return;
    }
    _textView.text = textFileContents;
    
    CNumberDataModel *CNumber = [CNumberDataModel DB_modelWithJson:textFileContents];
    NSLog(@"CNumber:\n%@",CNumber);
}

@end
