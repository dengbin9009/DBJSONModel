//
//  ViewController.m
//  DBModel
//
//  Created by DaBin on 2017/7/10.
//  Copyright © 2017年 DaBin. All rights reserved.
//

#import "ViewController.h"

static NSArray *_functions;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _functions = @[@{@"简单模型转换"      :@"SimpleViewController"},
                   @{@"继承模型转换"      :@"InheritViewController"},
                   @{@"自定义模型转换"     :@"CustomPropertyViewController"},
                   @{@"数组模型转换"      :@"ArrayViewController"},
                   @{@"CNumber转换"      :@"CNumberViewController"},
                   @{@"BOOL转换"         :@"BOOLViewController"},
                   @{@"时间转换"          :@"DateViewController"},
                   @{@"黑名单处理"        :@"BlackListViewController"},
                   @{@"白名单处理"        :@"WhiteListViewController"},
                   @{@"自定义属性映射"     :@"MapperViewController"}];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _functions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FunctionsCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = ((NSDictionary *)_functions[indexPath.row]).allKeys.firstObject;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *functionName = ((NSDictionary *)_functions[indexPath.row]).allKeys.firstObject;
    NSString *className = ((NSDictionary *)_functions[indexPath.row]).allValues.firstObject;
    Class Cls = NSClassFromString(className);
    UIViewController *aVC = [Cls new];
    aVC.title = functionName;
    [self.navigationController pushViewController:aVC animated:YES];
    
}


@end
