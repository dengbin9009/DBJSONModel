//
//  BaseViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/message.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addATextView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    SEL sel = NSSelectorFromString(@"valeTransformer:");
    if ( [self respondsToSelector:sel] ) {
        objc_msgSend(self, sel);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addATextView{
    CGSize size = [UIScreen mainScreen].bounds.size;
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    _textView.text = self.title;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.editable = NO;
    [self.view addSubview:_textView];
}

- (NSString *)getJsonFormFileName:(NSString *)fileName{
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    if (textFileContents == nil) {
        DBModelLog(@"Error reading text file. %@", [error localizedFailureReason]);
        return nil;
    }
    return textFileContents;
}



@end
