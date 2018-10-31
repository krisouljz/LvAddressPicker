//
//  LvViewController.m
//  LvAddressPicker
//
//  Created by krisouljz on 07/19/2018.
//  Copyright (c) 2018 krisouljz. All rights reserved.
//

#import "LvViewController.h"
#import "LvAddressPickerVC.h"

@interface LvViewController ()

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,strong) UILabel *label;

@end

@implementation LvViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.button];
    [self.view addSubview:self.label];
    
//    self.button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - 50, 100, 100, 40);
//    self.label.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 100);
    //测试测试测试
}


#pragma mark - Getter
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeSystem];
        _button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2.0 - 50, 100, 100, 40);
        [_button setTitle:@"地址选择器" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(address:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.frame = CGRectMake(0, 150, [UIScreen mainScreen].bounds.size.width, 100);
        _label.font = [UIFont systemFontOfSize:14.0];
        _label.textColor = [UIColor redColor];
        _label.numberOfLines = 0;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}




#pragma mark - Event
- (void)address:(UIButton *)sender {
    typeof(self) __weak weakSelf = self;
    LvAddressPickerVC *picker = [LvAddressPickerVC new];
    [picker setCommitBlock:^(NSString *address, NSString *zipcode) {
        weakSelf.label.text = [NSString stringWithFormat:@"地区名称:%@ \n 地区编码:%@",address,zipcode];
    }];
    
    [self presentViewController:picker animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
