//
//  HMComboSelectionViewController.m
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 19/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMComboSelectionViewController.h"
#import "HMMealPlannerViewController.h"

@interface HMComboSelectionViewController () {
    NSString *selectedKindOfFood;
    NSMutableArray *lunchArray;
    NSMutableArray *dinnerArray;
    
}

@end

@implementation HMComboSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lunchArray = [[NSMutableArray alloc] init];
    dinnerArray = [[NSMutableArray alloc] init];

    for (int i=0; i<31; i++) {
        [lunchArray addObject:@""];
        [dinnerArray addObject:@""];
    }
    
    self.title = @"Combo Selection";
    selectedKindOfFood = @"NorthIndian";
    //[_northIndianBtn setBackgroundColor:[UIColor colorWithRed:0/255.0 green:128.0/255.0 blue:0/255.0 alpha:1.0f]];
    [[_northIndianBtn layer] setBorderWidth:2.0f];
    [[_southIndianBtn layer] setBorderWidth:2.0f];

    [[_northIndianBtn layer] setBorderColor:(__bridge CGColorRef _Nullable)(APPLICATION_COLOR)];
    [_northIndianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)foodPreferenceClicked:(id)sender{
    UIButton *senderBtn = (UIButton *)sender;
    if (senderBtn.tag == 0) {
        selectedKindOfFood = @"NorthIndian";
        [[_northIndianBtn layer] setBorderColor:(__bridge CGColorRef _Nullable)(APPLICATION_COLOR)];

        [_northIndianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [[_southIndianBtn layer] setBorderColor:(__bridge CGColorRef _Nullable)(APPLICATION_SUBTITLE_COLOR)];
        [_southIndianBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else {
        selectedKindOfFood = @"SouthIndian";
        [[_southIndianBtn layer] setBorderColor:(__bridge CGColorRef _Nullable)(APPLICATION_COLOR)];

        [_southIndianBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [[_northIndianBtn layer] setBorderColor:(__bridge CGColorRef _Nullable)(APPLICATION_SUBTITLE_COLOR)];
        [_northIndianBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}

- (IBAction)lunchCheckBoxClicked:(id)sender{
    if ([_lunchCheckBox isSelected]) {
        [_lunchCheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        [_lunchCheckBox setSelected:NO];
    }
    else {
        [_lunchCheckBox setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
        [_lunchCheckBox setSelected:YES];
    }
}

- (IBAction)dinnerCheckBoxClicked:(id)sender{
    if ([_dinnerCheckBox isSelected]) {
        [_dinnerCheckBox setImage:[UIImage imageNamed:@"checkbox_not_ticked.png"] forState:UIControlStateNormal];
        [_dinnerCheckBox setSelected:NO];
    }
    else {
        [_dinnerCheckBox setImage:[UIImage imageNamed:@"checkbox_ticked.png"] forState:UIControlStateNormal];
        [_dinnerCheckBox setSelected:YES];
    }
}

-(IBAction)viewMealPlannerClicked:(id)sender{
    if (_lunchCheckBox.isSelected || _dinnerCheckBox.isSelected) {
        [self performSegueWithIdentifier:@"ToMonthlyMealFromCombo" sender:self];
    }
    else {
        [self showAlertWithTitle:@"Oops!" andMessage:@"Please choose your time"];
    }
}

- (NSString *)getProductIdFromCombo{
    if ([_selectedCombo isEqualToString:@"VEG_MEAL"] && [selectedKindOfFood isEqualToString:@"NorthIndian"]) {
        return @"North Indian Veg Meal";
    }
    else if ([_selectedCombo isEqualToString:@"VEG_MEAL"] && [selectedKindOfFood isEqualToString:@"SouthIndian"]) {
        return @"South Indian Veg Meal";
    }
    else if ([_selectedCombo isEqualToString:@"EGG_MEAL"] && [selectedKindOfFood isEqualToString:@"NorthIndian"]) {
        return @"North Indian Egg Meal";
    }
    else if ([_selectedCombo isEqualToString:@"EGG_MEAL"] && [selectedKindOfFood isEqualToString:@"SouthIndian"]) {
        return @"South Indian Egg Meal";
    }
    else if ([_selectedCombo isEqualToString:@"CHICKEN_MEAL"] && [selectedKindOfFood isEqualToString:@"NorthIndian"]) {
        return @"North Indian Chicken Meal";
    }
    else if ([_selectedCombo isEqualToString:@"CHICKEN_MEAL"] && [selectedKindOfFood isEqualToString:@"SouthIndian"]) {
        return @"South Indian Chicken Meal";
    }
    
    return @"";
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToMonthlyMealFromCombo"]){
        HMMealPlannerViewController *mealsVC = (HMMealPlannerViewController *)segue.destinationViewController;
        mealsVC.isFromComboVC = YES;
        NSString *productID = [self getProductIdFromCombo];
        
        //preparing lunch list
        if (![productID isEqualToString:@""] && _lunchCheckBox.isSelected) {
            [lunchArray removeAllObjects];
            for (int i=0; i<31; i++) {
                [lunchArray addObject:productID];
            }
            mealsVC.lunchItemsList = lunchArray;
        }
        else {
            mealsVC.lunchItemsList = lunchArray;
        }
        
        //Preparing dinner list
        if (![productID isEqualToString:@""] && _dinnerCheckBox.isSelected) {
            [dinnerArray removeAllObjects];
            for (int i=0; i<31; i++) {
                [dinnerArray addObject:productID];
            }
            mealsVC.dinnerItemsList = dinnerArray;
        }
        else {
            mealsVC.dinnerItemsList = dinnerArray;
        }
        
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}

@end
