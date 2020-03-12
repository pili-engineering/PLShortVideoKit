//
//  TransitionTextEditViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "TransitionTextEditViewController.h"
#import <Masonry/Masonry.h>

typedef enum : NSUInteger {
    PLSTextProperyFont,
    PLSTextProperyColor,
    PLSTextProperySize,
} PLSTextPropery;

@interface TransitionTextEditViewController ()
<
UITextFieldDelegate,
PropertyPickerViewDelegate
>

@property (nonatomic, assign)PLSTextModel model;

@property (nonatomic, strong) UITextField *titleTextFiled;

@property (nonatomic, strong) UITextField *detailTextFiled;

@property (nonatomic, assign) BOOL isTwoTextField;

@property (nonatomic, strong) NSMutableDictionary *dics;

@property (nonatomic, assign) BOOL isSelectTitle;

@property (nonatomic, assign) PLSTextPropery textProperty;

@property (nonatomic, strong) NSMutableArray *fontArray;

@property (nonatomic, strong) NSMutableArray *colorArray;

@property (nonatomic, strong) NSMutableArray *sizeArray;

@end

@implementation TransitionTextEditViewController

- (id)initWithDic:(NSDictionary *)dics model:(PLSTextModel)model {
    
    self = [super initWithStyle:(UITableViewStyleGrouped)];
    if (self) {
        self.isSelectTitle = YES;
        self.dics = [[NSMutableDictionary alloc] initWithDictionary:dics];
        self.model = model;
        self.isTwoTextField = PLSTextModelDetail == model || PLSTextModelTail == model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.separatorColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor blackColor];
}

NSString *fonts[] = {@"zcool-gdh", @"HappyZcool-2016"};
- (NSArray *)fontArray {
    if (nil == _fontArray) {
        _fontArray = [[NSMutableArray alloc] initWithObjects:fonts count:sizeof(fonts)/sizeof(fonts[0])];
        NSArray *familyNames = [UIFont familyNames];
        for (NSString* familyName in familyNames) {
            NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
            if (fontNames.count) {
                [_fontArray addObjectsFromArray:fontNames];
            } else {
                [_fontArray addObject:familyName];
            }
        }
    }
    return _fontArray;
}

NSString *colors[] = {@"#FFFFFF", @"#FF3D49", @"#FFEE00", @"#00C6FF", @"#EACFD4", @"#F8EADA", @"#CEFFC6", @"#C3CADA", @"#000000"};
- (NSMutableArray *)colorArray {
    if (nil == _colorArray) {
        _colorArray = [[NSMutableArray alloc] initWithObjects:colors count:sizeof(colors)/sizeof(colors[0])];
    }
    return _colorArray;
}

- (NSMutableArray *)sizeArray {
    if (nil == _sizeArray) {
        _sizeArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < 20; i ++) {
            [_sizeArray addObject:[NSString stringWithFormat:@"%d", 14 + 2 * i]];
        }
    }
    return _sizeArray;
}

- (UITextField *)titleTextFiled {
    
    if (nil == _titleTextFiled) {
        _titleTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 30, 80)];
        _titleTextFiled.font = [self.dics objectForKey:@"titleFont"];
        _titleTextFiled.textColor = [self.dics objectForKey:@"titleColor"];
        _titleTextFiled.text = [self.dics objectForKey:@"title"];
        _titleTextFiled.delegate = self;
        if (self.isTwoTextField) {
            _titleTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入第一行文字" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        } else {
            _titleTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"在此输入文字" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        }
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:222.0/255 green:63.0/255 blue:98.0/255 alpha:1];
        [_titleTextFiled addSubview:line];
        line.frame = CGRectMake(0, _titleTextFiled.bounds.size.height - 2, _titleTextFiled.bounds.size.width, 2);
    }
    return _titleTextFiled;
}

- (UITextField *)detailTextFiled {
    if (nil == _detailTextFiled) {
        _detailTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width - 30, 80)];
        _detailTextFiled.font = [self.dics objectForKey:@"detailFont"];
        _detailTextFiled.textColor = [self.dics objectForKey:@"detailColor"];
        _detailTextFiled.text = [self.dics objectForKey:@"detailTitle"];
        _detailTextFiled.delegate = self;
        _detailTextFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入第二行文字" attributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor colorWithRed:222.0/255 green:63.0/255 blue:98.0/255 alpha:1];
        [_detailTextFiled addSubview:line];
        line.frame = CGRectMake(0, _detailTextFiled.bounds.size.height - 2, _detailTextFiled.bounds.size.width, 2);
    }
    return _detailTextFiled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.delegate editViewController:self completeWithModel:self.model textInfo:self.dics];
    
    [super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.isTwoTextField ? 5 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *uniqueCellID = [NSString stringWithFormat:@"row%ld", (long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:uniqueCellID];
    if (cell) return cell;
    
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:uniqueCellID];
    cell.backgroundColor = [UIColor blackColor];
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.isTwoTextField) {
        switch (indexPath.row) {
            case 0: {
                cell.accessoryView = self.titleTextFiled;
            } break;
                
            case 1: {
                cell.accessoryView = self.detailTextFiled;
            } break;
                
            case 2: {
                cell.textLabel.text = @"颜色";
            } break;
                
            case 3: {
                cell.textLabel.text = @"字体";
            } break;
                
            case 4: {
                cell.textLabel.text = @"大小";
            } break;
        }
    } else {
        switch (indexPath.row) {
            case 0: {
                cell.accessoryView = self.titleTextFiled;
            } break;
                
            case 1: {
                cell.textLabel.text = @"颜色";
            } break;
                
            case 2: {
                cell.textLabel.text = @"字体";
            } break;
                
            case 3: {
                cell.textLabel.text = @"大小";
            } break;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isTwoTextField) {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                
                break;
            case 2: {
                self.textProperty = PLSTextProperyColor;
                [self selectedProperty:self.colorArray];
            }
                break;
                
            case 3: {
                self.textProperty = PLSTextProperyFont;
                [self selectedProperty:self.fontArray];
            }
                break;
                
            case 4: {
                self.textProperty = PLSTextProperySize;
                [self selectedProperty:self.sizeArray];
            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1: {
                self.textProperty = PLSTextProperyColor;
                [self selectedProperty:self.colorArray];
            }
                break;
                
            case 2: {
                self.textProperty = PLSTextProperyFont;
                [self selectedProperty:self.fontArray];
            }
                break;
                
            case 3: {
                self.textProperty = PLSTextProperySize;
                [self selectedProperty:self.sizeArray];
            }
                break;
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 1) {
        return 44;
    }
    if (0 == indexPath.row) {
        return 90;
    } else {// 1
        return self.isTwoTextField ? 90 : 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_detailTextFiled == textField) {
        self.isSelectTitle = NO;
    } else {
        self.isSelectTitle = YES;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length) {
        if (_titleTextFiled == textField) {
            [self.dics setObject:textField.text forKey:@"title"];
        } else {
            [self.dics setObject:textField.text forKey:@"detailTitle"];
        }
    }
}

- (void) selectedProperty:(NSArray *)array {
    
    if (self.titleTextFiled.isFirstResponder) {
        [self.titleTextFiled resignFirstResponder];
    }
    if (self.detailTextFiled.isFirstResponder) {
        [self.detailTextFiled resignFirstResponder];
    }
    
    PropertyPickerView *pickerView = [[PropertyPickerView alloc] initWithItem:array];
    pickerView.delegate = self;
    [self.view addSubview:pickerView];
    [pickerView show];
}

- (void)pickerView:(PropertyPickerView *)pickerView disSelectedIndex:(NSInteger)index {
    switch (_textProperty) {
        case PLSTextProperyFont: {
            if (self.isSelectTitle) {
                UIFont *oldFont = [self.dics objectForKey:@"titleFont"];
                UIFont *newfont = [UIFont fontWithName:_fontArray[index] size:oldFont.pointSize];
                [self.dics setObject:newfont forKey:@"titleFont"];
            } else {
                UIFont *oldFont = [self.dics objectForKey:@"detailFont"];
                UIFont *newfont = [UIFont fontWithName:_fontArray[index] size:oldFont.pointSize];
                [self.dics setObject:newfont forKey:@"detailFont"];
            }
        }
            break;
            
        case PLSTextProperySize: {
            if (self.isSelectTitle) {
                UIFont *oldFont = [self.dics objectForKey:@"titleFont"];
                UIFont *newfont = [UIFont fontWithName:oldFont.fontName size:[self.sizeArray[index] integerValue]];
                [self.dics setObject:newfont forKey:@"titleFont"];
            } else {
                UIFont *oldFont = [self.dics objectForKey:@"detailFont"];
                UIFont *newfont = [UIFont fontWithName:oldFont.fontName size:[self.sizeArray[index] integerValue]];
                [self.dics setObject:newfont forKey:@"detailFont"];
            }
        }
            break;
            
        case PLSTextProperyColor: {
            UIColor *newcolor = [self colorWithHexString:self.colorArray[index]];
            if (self.isSelectTitle) {
                [self.dics setObject:newcolor forKey:@"titleColor"];
            } else {
                [self.dics setObject:newcolor forKey:@"detailColor"];
            }
        }
            break;
    }
    
    _detailTextFiled.font = [self.dics objectForKey:@"detailFont"];
    _detailTextFiled.textColor = [self.dics objectForKey:@"detailColor"];
    _detailTextFiled.text = [self.dics objectForKey:@"detailTitle"];

    _titleTextFiled.font = [self.dics objectForKey:@"titleFont"];
    _titleTextFiled.textColor = [self.dics objectForKey:@"titleColor"];
    _titleTextFiled.text = [self.dics objectForKey:@"title"];

}

- (UIColor *)colorWithHexString:(NSString *)hexString{
    
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1];
}

@end





@interface PropertyPickerView ()

@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation PropertyPickerView

- (id)initWithItem:(NSArray<NSString *> *)item {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.items = item;

        UIButton *dismissButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [dismissButton addTarget:self action:@selector(hide) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:dismissButton];
        
        UIButton *saveButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [saveButton setTintColor:[UIColor redColor]];
        [saveButton setTitle:@"确定" forState:(UIControlStateNormal)];
        [saveButton sizeToFit];
        [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:(UIControlEventTouchUpInside)];
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor darkGrayColor];
        [self addSubview:self.backgroundView];
        
        [dismissButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.backgroundView.mas_top);
        }];
        
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(@(250));
        }];
        
        [self.backgroundView addSubview:self.pickerView];
        [self.backgroundView addSubview:saveButton];

        [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self.backgroundView);
            make.size.equalTo(@(CGSizeMake(60, 44)));
        }];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.backgroundView);
            make.top.equalTo(saveButton.mas_bottom);
        }];
    }
    return self;
}

- (void)show {
    
    [self layoutIfNeeded];
    
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(250));
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    }];

    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.delegate pickerView:self disSelectedIndex:0];
}

- (void)hide {
    
    [self.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.mas_bottom);
        make.height.equalTo(@(250));
    }];
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) clickSaveButton {
    [self hide];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.items.count;
}

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    if (!view) {
        view = [[UILabel alloc] init];
        [(UILabel*)view setTextAlignment:NSTextAlignmentCenter];
    }
    UILabel *label = (UILabel *)view;
    label.text = self.items[row];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row >= 0 && row < _items.count) {
        [self.delegate pickerView:self disSelectedIndex:row];
    }
}

@end


