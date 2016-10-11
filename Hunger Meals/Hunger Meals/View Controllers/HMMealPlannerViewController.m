//
//  HMMealPlannerViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 20/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMMealPlannerViewController.h"
#import "HMItemListTableViewCell.h"
#import "HMItemList.h"
#import "ItemTableViewCell.h"

@interface HMMealPlannerViewController (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
    NSMutableArray *itemsListArray;
    HMItemList *itemListView;
    MTGenericAlertView *MTGenericAlertViewtainer;

}
@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;
@property (strong, nonatomic) IBOutlet UIView *instanceView;
@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;

@end

@implementation HMMealPlannerViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    self.title = @"Vertical";
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Monthly meal Planner";
    
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    _calendarManager.settings.pageViewHaveWeekDaysView = NO;
    _calendarManager.settings.pageViewNumberOfWeeks = 0; // Automatic
    
    _weekDayView.manager = _calendarManager;
    [_weekDayView reload];
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:[NSDate date]];
    _calendarManager.settings.weekModeEnabled = YES;
    [_calendarManager reload];
    _calendarMenuView.scrollView.scrollEnabled = NO; // Scroll not supported with JTVerticalCalendarView
    
    itemsListArray = [[NSMutableArray alloc]init];
    
    itemListView = [[HMItemList alloc]init];
    
    [self fetchAndLoadData];
    [self.itemListTableView reloadData];
    [MTGenericAlertViewtainer close];
    
   
    
    }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
  //  self.instanceView.center = CGPointMake(self.view.frame.size.width  / 2,
                                          // (self.view.frame.size.height / 2)+50);

   // self.instanceView.frame = CGRectMake(16, self.view.frame.size.height / 2 - 30, self.view.frame.size.width - 32, 7*40);
    [self.instanceView setBackgroundColor: [UIColor clearColor]];

   // [self.view addSubview: self.instanceView];
    

    
}
#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    dayView.hidden = NO;
    
    // Hide if from another month
    if([dayView isFromAnotherMonth]){
        dayView.hidden = YES;
    }
    // Today
    else if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Don't change page in week mode because block the selection of days in first and last weeks of the month
    if(_calendarManager.settings.weekModeEnabled){
        return;
    }
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - Fake data

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     if (tableView == self.calendarTableView) {
         NSCalendar *calendar = [NSCalendar currentCalendar];
         NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
         NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
     }else{
         return itemsListArray.count;
     }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //self.instanceView.hidden = NO;
    [MTGenericAlertViewtainer show];
    if(tableView == self.calendarTableView){
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (tableView == self.calendarTableView) {
        HMItemListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Calendarcell"];
        return cell;
    }else if(tableView == self.itemListTableView){
        
    static NSString *cellIdentifier = @"ItemListCell";
        
    ItemTableViewCell *celll = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(indexPath.row ==0 ){
              celll.itemNameLabel.text = @"Meanu";
        }
        
        NSArray *itemsArray = [itemsListArray valueForKey:@"title"];
        
        celll.itemNameLabel.text = itemsArray [indexPath.row];
        return celll;

    }else
    return  cell;
}
- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
    

}


-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    [service getcurrmealplanusingBlock:^(NSMutableArray *resultArray) {
        
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
- (IBAction)lunchButtonAction:(id)sender {
   

    if(itemsListArray.count >= 1)
    {
     MTGenericAlertViewtainer = [[MTGenericAlertView alloc] initWithTitle:@"Menu" titleColor:nil titleFont:nil backgroundImage:nil];
        [MTGenericAlertViewtainer show];


    //self.instanceView.hidden = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
  //  UIButton *btn = (UIButton *)sender;
    [MTGenericAlertViewtainer setCustomInputView:self.instanceView]; //Add customized view to this method
    MTGenericAlertViewtainer.tag = 3;
   // [MTGenericAlertViewtainer setCustomButtonTitlesArray:[NSMutableArray arrayWithObjects:@"OK",nil]];
    [MTGenericAlertViewtainer show];
    }
    
    [self.itemListTableView reloadData];

}
- (IBAction)dinnerButtonAction:(id)sender {
    [MTGenericAlertViewtainer show];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.itemListTableView reloadData];

}

@end
