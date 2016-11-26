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
#import "MTGenericAlertView.h"
#import "Itemlist.h"
#import "BTAlertController.h"
#import "HMMonthlyCartViewController.h"

@interface HMMealPlannerViewController (){
    NSMutableDictionary *_eventsByDate;
    
    NSDate *_dateSelected;
    NSMutableArray *itemsListArray;
    HMItemList *itemListView;
    MTGenericAlertView *MTGenericAlertViewtainer;
   
    NSIndexPath *selectedCalenderIndexPath;
    BOOL isLunchBtn;
    BOOL isDinnerBtn;
    int *calenderCount;
    NSString *currentMonth;
}

@property (weak, nonatomic) IBOutlet UITableView *calendarTableView;
@property (strong, nonatomic) IBOutlet UIView *instanceView;
@property (weak, nonatomic) IBOutlet UITableView *itemListTableView;

@end

@implementation HMMealPlannerViewController
@synthesize dinnerItemsList, lunchItemsList;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(!self){
        return nil;
    }
    
    self.title = @"Vertical";
    isLunchBtn = NO;
    isDinnerBtn = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Monthly Meal Planner";
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
    self.navigationItem.rightBarButtonItem = saveBtn;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
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
    
    [_calendarTableView reloadData];
    [self.itemListTableView reloadData];
    [self fetchMonthlyProducts];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    
    if (!_isFromComboVC) {
        
        lunchItemsList = [[NSMutableArray alloc]initWithCapacity:numberOfDaysInMonth];
        dinnerItemsList = [[NSMutableArray alloc]initWithCapacity:numberOfDaysInMonth];
        
        for(int i = 0; i < numberOfDaysInMonth; ++i){
            [lunchItemsList addObject:@""];
            [dinnerItemsList addObject:@""];
        }
        
        [self fetchAndLoadData];
    }
   
    
   //get month name
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM"];
    NSString *month = [formatter stringFromDate:now];
    currentMonth = month;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
  //  self.instanceView.center = CGPointMake(self.view.frame.size.width  / 2,
                                          // (self.view.frame.size.height / 2)+50);

   // self.instanceView.frame = CGRectMake(16, self.view.frame.size.height / 2 - 30, self.view.frame.size.width - 32, 7*40);
    [self.instanceView setBackgroundColor: [UIColor clearColor]];

   // [self.view addSubview: self.instanceView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(IBAction)saveButtonClicked:(id)sender{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSMutableArray *lunchPlanDataArray = [[NSMutableArray alloc] init];
    NSMutableArray *dinnerPlanDataArray = [[NSMutableArray alloc] init];
    
    for (NSString *itemName in lunchItemsList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title = %@",itemName];
        NSArray *filteredArray = [itemsListArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            Itemlist *item = filteredArray.firstObject;
            [lunchPlanDataArray addObject:item.id];
        }
        else {
            [lunchPlanDataArray addObject:@""];
        }
        
    }

    for (NSString *itemName in dinnerItemsList) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title = %@",itemName];
        NSArray *filteredArray = [itemsListArray filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0) {
            Itemlist *item = filteredArray.firstObject;
            [dinnerPlanDataArray addObject:item.id];
        }
        else {
            [dinnerPlanDataArray addObject:@""];
        }
        
    }

    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:lunchPlanDataArray, @"lunchplandata", dinnerPlanDataArray, @"dinnerplandata", nil];
    
    SVService *service = [[SVService alloc] init];
    [service saveMonthlyMealPlan:params usingBlock:^(NSString *resultMessage) {

        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        
        if ([resultMessage  isEqual: @"Meal Plan saved successfully"]) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HMMonthlyCartViewController *monthlyCartMealViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MonthlyCartViewIdentifier"];
            [self.navigationController pushViewController:monthlyCartMealViewController animated:YES];
        }
        else if (![resultMessage isEqualToString:@""]){
            [self showAlertWithTitle:@"Hunger Meals" andMessage:resultMessage];
        }
       
    }];

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

#pragma mark - Calender methods

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
   // [MTGenericAlertViewtainer show];
    if(tableView == self.itemListTableView){
        NSIndexPath *selectedIndexPath = [self.itemListTableView indexPathForSelectedRow];
        if(selectedIndexPath){
            [MTGenericAlertViewtainer close];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            ItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if(isLunchBtn){
                lunchItemsList[selectedCalenderIndexPath.row] = cell.itemNameLabel.text;
            } else{
                dinnerItemsList[selectedCalenderIndexPath.row] = cell.itemNameLabel.text;
            }
            //reload calenderTableView
            // Add them in an index path array
            NSArray* indexArray = [NSArray arrayWithObjects:selectedCalenderIndexPath, nil];
            // Launch reload for the two index path
            [self.calendarTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if(tableView == self.calendarTableView){
        NSIndexPath *selectedIndexPath = [self.calendarTableView indexPathForSelectedRow];
        if(selectedIndexPath){
            
//            HMItemListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [cell.lunchButtonOutlet setTitle:[NSString stringWithFormat:@" Lunch: %@",str] forState:UIControlStateNormal];
//            [self.itemListTableView reloadData];
//            [cell.lunchButtonOutlet addTarget:self action:@selector(lunchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.lunchButtonOutlet addTarget:self action:@selector(lunchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (tableView == self.calendarTableView) {
        
        HMItemListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Calendarcell"];
        NSString *date = currentMonth;
        cell.dateLbl.text = [date stringByAppendingString:[NSString stringWithFormat:@" %ld",indexPath.row+1]];
        cell.lunchButtonOutlet.tag = indexPath.row;
        cell.dinnerButtonOutlet.tag = indexPath.row;
        
        if([lunchItemsList count] > 0 && [lunchItemsList count] > indexPath.row){
            
            NSString *lunchText =[lunchItemsList objectAtIndex:indexPath.row];
            [cell.lunchButtonOutlet setTitle:[NSString stringWithFormat:@" Lunch: %@",lunchText] forState:UIControlStateNormal];
        }
        else{
            
            return  cell;
        }
        
        if([dinnerItemsList count] > 0 && [dinnerItemsList count] > indexPath.row){
            
            NSString *lunchText =[dinnerItemsList objectAtIndex:indexPath.row];
            [cell.dinnerButtonOutlet setTitle:[NSString stringWithFormat:@" Dinner: %@",lunchText] forState:UIControlStateNormal];
        }
        else{
            
            return  cell;
        }


        return cell;
    }else if(tableView == self.itemListTableView){
        
    static NSString *cellIdentifier = @"ItemListCell";
        

    ItemTableViewCell *celll = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(indexPath.row ==0 ){
              celll.itemNameLabel.text = @"Menu";
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
    [service getcurrmealplanusingBlock:^(NSDictionary *resultDict) {

        NSMutableArray *lunchList = [resultDict valueForKeyPath:@"data.lunchplandata.title"];
        NSMutableArray *dinnerList = [resultDict valueForKeyPath:@"data.dinnerplandata.title"];
        if (lunchList.count > 0 && dinnerList.count > 0 ) {
            [lunchItemsList removeAllObjects];
            [dinnerItemsList removeAllObjects];
            
            for (NSArray *array in lunchList) {
                if ([array firstObject] != nil) {
                    [lunchItemsList addObject:[array firstObject]];
                }
                else {
                    [lunchItemsList addObject:@""];
                }
            }
            for (NSArray *array in dinnerList) {

                    if ([array firstObject] != nil) {
                        [dinnerItemsList addObject:[array firstObject]];
                    }
                    else {
                        [dinnerItemsList addObject:@""];
                    }
            }
            
            [_calendarTableView reloadData];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
- (IBAction)lunchButtonAction:(id)sender {
    isLunchBtn = YES;
    isDinnerBtn = NO;
    selectedCalenderIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    
    if(itemsListArray.count >= 1)
    {
        if (MTGenericAlertViewtainer == nil) {
            MTGenericAlertViewtainer = [[MTGenericAlertView alloc] initWithTitle:@"Menu" titleColor:nil titleFont:nil backgroundImage:nil];
            MTGenericAlertViewtainer.isPopUpView = YES;
            [MTGenericAlertViewtainer setCustomInputView:self.instanceView];

        }
        [MTGenericAlertViewtainer show];
        
        [MTGenericAlertViewtainer setAlertViewButtonActionCompletionHandler:^(MTGenericAlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)alertView.tag);
            [alertView close];
            
        }];
    }
   
    [self.itemListTableView reloadData];

}
- (IBAction)dinnerButtonAction:(id)sender {
    isLunchBtn = NO;
    isDinnerBtn = YES;
    selectedCalenderIndexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    if (MTGenericAlertViewtainer == nil) {
        MTGenericAlertViewtainer = [[MTGenericAlertView alloc] initWithTitle:@"Menu" titleColor:nil titleFont:nil backgroundImage:nil];
         MTGenericAlertViewtainer.isPopUpView = YES;
        [MTGenericAlertViewtainer setCustomInputView:self.instanceView];
    }
    [MTGenericAlertViewtainer show];
    [self.itemListTableView reloadData];
}

- (void)fetchMonthlyProducts{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    [service getmonthlyproductsusingBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count > 0) {
            itemsListArray = resultArray;
            [_itemListTableView reloadData];
        }
        
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];

}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}

@end
