//
//  HMMealPlannerViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 20/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "SVService.h"
#import "CommonViewController.h"

@interface HMMealPlannerViewController :CommonViewController <JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@property (nonatomic, strong) NSMutableArray *lunchItemsList;
@property (nonatomic, strong) NSMutableArray *dinnerItemsList;
@property (nonatomic, assign) BOOL isFromComboVC;

@end
