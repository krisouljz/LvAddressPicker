//
//  LvAddressPickerVC.m
//  AddressPicker
//
//  Created by krisouljz on 07/19/2018.
//  Copyright (c) 2018 krisouljz. All rights reserved.
//

#import "LvAddressPickerVC.h"
#import "AddressFletModel.h"

@interface LvAddressPickerVC ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *startPickerView;

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,assign) NSInteger selectedIndex_province;

@property (nonatomic,assign) NSInteger selectedIndex_city;

@property (nonatomic,assign) NSInteger selectedIndex_district;



@end

@implementation LvAddressPickerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDataSource];
    [self layoutUI];
}


- (void)initDataSource {
    _numberOfComponents = 3;
    _modelArray = [NSMutableArray new];
    
    
    
    
    
    NSBundle *systemBundle = [NSBundle bundleForClass:[self class]];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:[systemBundle URLForResource:@"LvAddressPicker" withExtension:@"bundle"]];
    
    NSString *path = [resourceBundle pathForResource:@"address_data" ofType:@"json"];

    NSString *jsonStr = [NSString stringWithContentsOfFile:path usedEncoding:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    NSMutableArray *provinceNameArray = [NSMutableArray new];
    NSMutableArray *cityNameArray = [NSMutableArray new];
    NSMutableArray *districtNameArray = [NSMutableArray new];
    
    
    
    for (NSDictionary *province in array) {
        AddressFletModel *provinceModel = [[AddressFletModel alloc]init];
        provinceModel.citycode = province[@"citycode"];
        provinceModel.adcode = province[@"adcode"];
        provinceModel.name = province[@"name"];
        provinceModel.center = province[@"center"];
        provinceModel.level = province[@"level"];
        [provinceNameArray addObject:provinceModel.name];
        NSMutableArray *cityArray = [NSMutableArray new];
        for (NSDictionary *city in province[@"districts"]) {
            AddressFletModel *cityModel = [[AddressFletModel alloc]init];
            cityModel.citycode = city[@"citycode"];
            cityModel.adcode = city[@"adcode"];
            cityModel.name = city[@"name"];
            cityModel.center = city[@"center"];
            cityModel.level = city[@"level"];
            [cityNameArray addObject:cityModel.name];
            
            NSMutableArray *districtArray = [NSMutableArray new];
            for (NSDictionary *district in city[@"districts"]) {
                AddressFletModel *districtModel = [[AddressFletModel alloc]init];
                districtModel.citycode = district[@"citycode"];
                districtModel.adcode = district[@"adcode"];
                districtModel.name = district[@"name"];
                districtModel.center = district[@"center"];
                districtModel.level = district[@"level"];
                [districtNameArray addObject:districtModel.name];
                [districtArray addObject:districtModel];
            }
            cityModel.districts = districtArray;
            [cityArray addObject:cityModel];
        }
        provinceModel.districts = cityArray;
        [_modelArray addObject:provinceModel];
    }
}



- (void)layoutUI{
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.startPickerView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.sureBtn];
}

#pragma mark - pickerVie delagete

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    AddressFletModel *province;
    if (self.modelArray.count > 0) {
        province = self.modelArray[self.selectedIndex_province];
    }
    
    AddressFletModel *city;
    if (province && province.districts.count > 0) {
        city = province.districts[self.selectedIndex_city];
    }
    if (self.modelArray.count != 0) {
        if (component == 0) {
            return self.modelArray.count;
        } else if (component == 1) {
            return province == nil ? 0 : province.districts.count;
        } else if (component == 2) {
            return city == nil ? 0 : city.districts.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
    
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view) {
        view = [[UIView alloc]init];
    }
    NSString *title = nil;
    if (component == 0) {
        
        AddressFletModel *model = _modelArray[row];
        title = model.name;
        
    }
    if (component == 1) {
        
        AddressFletModel *model = _modelArray[_selectedIndex_province];
        AddressFletModel *cityModel = model.districts[row];
        title = cityModel.name;
        
    }
    if (component == 2) {
        
        AddressFletModel *model = _modelArray[_selectedIndex_province];
        AddressFletModel *cityModel = model.districts[_selectedIndex_city];
        AddressFletModel *districtModel = cityModel.districts[row];
        title = districtModel.name;
        
    }
    
    
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.startPickerView.bounds.size.width/self.numberOfComponents, 40)];
    lab.text = title;
    lab.font = [UIFont systemFontOfSize:16];
    lab.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lab];
    return view;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.selectedIndex_province = row;
            self.selectedIndex_city = 0;
            self.selectedIndex_district = 0;
            
            if (self.numberOfComponents > 1) {
                [self.startPickerView reloadComponent:1];
                [self.startPickerView selectRow:0 inComponent:1 animated:YES];
            }
            
            if (self.numberOfComponents > 2) {
                [self.startPickerView reloadComponent:2];
                [self.startPickerView selectRow:0 inComponent:2 animated:YES];
            }
            
            
            break;
        case 1:
            self.selectedIndex_city = row;
            self.selectedIndex_district = 0;
            if (self.numberOfComponents > 2) {
                [self.startPickerView reloadComponent:2];
                [self.startPickerView selectRow:0 inComponent:2 animated:YES];
            }
            break;
        case 2:
            self.selectedIndex_district = row;
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    dispatch_after(0.3, dispatch_get_main_queue(), ^{
        [self cancelBtnTap];
    });
}
- (void)cancelBtnTap {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)sureBtnTap {
    
    __weak typeof(self) weakSelf = self;
    
    if (self.commitBlock) {
        if (weakSelf.modelArray.count > 0) {
            AddressFletModel *addressModel = weakSelf.modelArray[weakSelf.selectedIndex_province];
            AddressFletModel *cityModel;
            AddressFletModel *districtModel;
            if (addressModel.districts.count > 0) {
                cityModel = addressModel.districts[weakSelf.selectedIndex_city];
            }
            if (cityModel && cityModel.districts.count > 0) {
                districtModel = cityModel.districts[weakSelf.selectedIndex_district];
            }
            
            NSString *address;
            NSString *zipcode;
            if (!cityModel || weakSelf.numberOfComponents == 1) {
                address = [NSString stringWithFormat:@"%@",addressModel.name];
                zipcode = [NSString stringWithFormat:@"%@",addressModel.adcode];
            } else {
                if (!districtModel || weakSelf.numberOfComponents == 2) {
                    address = [NSString stringWithFormat:@"%@-%@",addressModel.name,cityModel.name];
                    zipcode = [NSString stringWithFormat:@"%@-%@",addressModel.adcode,cityModel.adcode];
                } else {
                    address = [NSString stringWithFormat:@"%@-%@-%@",addressModel.name,cityModel.name,districtModel.name];
                    zipcode = [NSString stringWithFormat:@"%@-%@-%@",addressModel.adcode,cityModel.adcode,districtModel.adcode];
                }
            }
            self.commitBlock(address, zipcode);
        }
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setNumberOfComponents:(NSInteger)numberOfComponents {
    if (numberOfComponents <= 0 || numberOfComponents > 3) {
        _numberOfComponents = 3;
    } else {
        _numberOfComponents = numberOfComponents;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.startPickerView reloadAllComponents];
    });
}

#pragma mark - Getter

- (UIPickerView *)startPickerView {
    if (!_startPickerView) {
        _startPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 275, ([UIScreen mainScreen].bounds.size.width - 30), 200)];
        _startPickerView.delegate = self;
        _startPickerView.dataSource = self;
        _startPickerView.backgroundColor = [UIColor whiteColor];
        _startPickerView.layer.masksToBounds = YES;
        _startPickerView.layer.cornerRadius = 4;
    }
    return _startPickerView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 65, ([UIScreen mainScreen].bounds.size.width - 35) / 2, 50)];
        [_cancelBtn addTarget:self action:@selector(cancelBtnTap) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:self.cancelButtonTitle forState:0];
        [_cancelBtn setTitleColor:self.cancelButtonTitleColor forState:0];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _cancelBtn.backgroundColor = self.cancelButtonBackgroundColor;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.layer.cornerRadius = 4;
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 35) / 2 +20, [UIScreen mainScreen].bounds.size.height - 65, ([UIScreen mainScreen].bounds.size.width - 35) / 2, 50)];
        [_sureBtn addTarget:self action:@selector(sureBtnTap) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setTitle:self.sureButtonTitle forState:0];
        
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn setTitleColor:self.sureButtonTitleColor forState:0];
        _sureBtn.backgroundColor = self.sureButtonBackgroundColor;
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 4;
    }
    return _sureBtn;
}

- (NSString *)cancelButtonTitle {
    if (!_cancelButtonTitle) {
        _cancelButtonTitle = @"取消";
    }
    return _cancelButtonTitle;
}

- (NSString *)sureButtonTitle {
    if (!_sureButtonTitle) {
        _sureButtonTitle = @"确定";
    }
    return _sureButtonTitle;
}

- (UIColor *)cancelButtonTitleColor {
    if (!_cancelButtonTitleColor) {
        _cancelButtonTitleColor =  [UIColor colorWithRed:52/255.0 green:53/255.0 blue:59/255.0 alpha:1/1.0];
    }
    return _cancelButtonTitleColor;
}

- (UIColor *)sureButtonTitleColor {
    if (!_sureButtonTitleColor) {
        _sureButtonTitleColor = [UIColor whiteColor];
    }
    return _sureButtonTitleColor;
}

- (UIColor *)sureButtonBackgroundColor {
    if (!_sureButtonBackgroundColor) {
        _sureButtonBackgroundColor = [UIColor colorWithRed:42/255.0 green:169/255.0 blue:247/255.0 alpha:1/1.0];
    }
    return _sureButtonBackgroundColor;
}

- (UIColor *)cancelButtonBackgroundColor {
    if (!_cancelButtonBackgroundColor) {
        _cancelButtonBackgroundColor = [UIColor whiteColor];
    }
    return _cancelButtonBackgroundColor;
}






@end
