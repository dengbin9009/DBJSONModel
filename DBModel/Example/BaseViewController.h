//
//  BaseViewController.h
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{
    UITextView *_textView;
}

- (NSString *)getJsonFormFileName:(NSString *)fileName;

@end
