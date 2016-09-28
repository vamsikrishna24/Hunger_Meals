//
//  HMMealPlannerViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 20/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface HMMealPlannerViewController : UIViewController<JTCalendarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;
@property (weak, nonatomic) IBOutlet JTCalendarWeekDayView *weekDayView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;

@end
