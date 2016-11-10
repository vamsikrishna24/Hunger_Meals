//
//  CardsViewController.m
//  PaymentSdk_GUI
//
//  Created by Vikas Singh on 8/26/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "CardsViewController.h"
#import "HMSegmentedControl.h"
#import "AutoloadViewController.h"

@interface CardsViewController () <UIPickerViewDataSource, UIPickerViewDelegate>{
    NSArray *array;
    UITextField *currentTextField;
    UISegmentedControl *_segControl;
    NSArray *debitArray;
    NSArray *creditArray;
    NSMutableArray *_savedAccountsArray;
    NSMutableArray *_balancesArray;
    NSMutableArray *_banksArray;
    NSDictionary *netBankingDict;
    NSInteger selectedRow;
    NSString *cvvText;
    NSMutableDictionary *imageDict;
    UISwitch *switchView;
    
    CTSPaymentOptions *_paymentOptions;
    NSDecimalNumber *mvcEnteredAmount;
    NSDecimalNumber *prepiadEnteredAmount;
    NSDecimalNumber *otherEnteredAmount;
    NSDecimalNumber *remainingAmount_tobePaid;
    NSDecimalNumber *totalEnteredAmount;
    
    NSDecimalNumber *transactionAmount;
    
    BOOL _useMVC;
    BOOL _useCash;
    BOOL _useOther;
    BOOL _useOtherWas;
    
    CTSSimpliChargeDistribution *_amountDistribution;
    BOOL _allSet;
    NSString *selectedPaymentoption;
    NSIndexPath *oldIndexPath;
    NSIndexPath *selectedIndexPath;
    NSDictionary *oldDictionary;
    BOOL _useSavedAccounts;
    
    NSDecimalNumber *_mvcMaxBalance;
    NSDecimalNumber *_cashMaxBalance;
    NSDecimalNumber *_totalSelectedAmount;
    
    BOOL isAnySubscriptionActive;
    UISwitch *autoloadSwitch;
    UIView *pickerToolBarView;
}
@end

@implementation CardsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDecimal zero = [NSDecimalNumber zero].decimalValue;
    mvcEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    prepiadEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    otherEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    remainingAmount_tobePaid = [NSDecimalNumber decimalNumberWithDecimal:zero];
    
    _useMVC = NO;
    _useCash = NO;
    _useOther = NO;
    _allSet = YES;
    oldDictionary = [[NSDictionary alloc] init];
    selectedRow = NSNotFound;
    selectedPaymentoption = [[NSString alloc] init];
    self.amount = [NSString stringWithFormat:@"%.02f", [self.amount floatValue]];
    
    NSDecimal myFloatDecimal = [[NSNumber numberWithFloat:[self.amount floatValue]] decimalValue];
    transactionAmount = [NSDecimalNumber decimalNumberWithDecimal:myFloatDecimal];
    
    [self initialSetting];
    LogTrace(@"landingscreeen : %d",self.landingScreen);
    
    _paymentOptions = [CTSPaymentOptions new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [switchView setOn:NO animated:YES];
    [autoloadSwitch setOn:NO animated:YES];
    
    if (self.landingScreen == 0) {
        self.title = [NSString stringWithFormat:@"Load Money for Amount : %@", self.amount];
    }
    else if (self.landingScreen == 2){
        self.title = [NSString stringWithFormat:@"Payment for Amount : %@", self.ruleInfo.originalAmount];
        self.amount = self.ruleInfo.originalAmount;
        NSDecimal myFloatDecimal = [[NSNumber numberWithFloat:[self.amount floatValue]] decimalValue];
        transactionAmount = [NSDecimalNumber decimalNumberWithDecimal:myFloatDecimal];
    }
    else {
        self.title = [NSString stringWithFormat:@"Payment for Amount : %@", self.amount];
    }
}

#pragma mark - Initial Setting Methods

- (void) initialSetting {
    
    // Button & View setting
    self.indicatorView.hidden = TRUE;
    self.loadButton.layer.cornerRadius = 4;
    //    [self.saveCardsTableView setHidden:TRUE];
    self.netBankCodeTextField.hidden = TRUE;
    
    
    array =[[NSArray alloc]init];
    _savedAccountsArray =[[NSMutableArray alloc] init];
    _balancesArray =[[NSMutableArray alloc] init];
    _banksArray =[[NSMutableArray alloc] init];
    
    if (self.landingScreen == 0) {
        [self requestLoadMoneyPgSettings];
    }
    else {
        [self requestPaymentModes];
    }
    
    
    if (!self.isDirectPaymentEnable) {
        if (self.landingScreen==1) {
            [self calculatePaymentDistribution];
        }
        [self getSaveCards:nil];
    }
    
    
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [self.ccddtableView addGestureRecognizer:tapRecognizer];
    
//    [self.pickerView setHidden:TRUE];
    
//    UIToolbar *accessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    accessoryToolbar.barTintColor = [UIColor orangeColor];
//    // Configure toolbar .....
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePickerView)];
//    
//    [accessoryToolbar setItems:[NSArray arrayWithObjects:doneButton, nil] animated:YES];
    
//    self.netBankCodeTextField.inputView = self.pickerView;
//    self.netBankCodeTextField.inputAccessoryView = accessoryToolbar;
    
    
    pickerToolBarView = [[UIView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/1.5, self.view.frame.size.width,200)];
    [pickerToolBarView setBackgroundColor:[UIColor whiteColor]];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,pickerToolBarView.frame.size.width,42)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePickerView)];
    [toolBar setItems:[NSArray arrayWithObjects:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    
    self.aPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,toolBar.frame.size.height,toolBar.frame.size.width,200)];
    [self.aPickerView setDataSource: self];
    [self.aPickerView setDelegate: self];
    self.aPickerView.showsSelectionIndicator = YES;
    [self.aPickerView setBackgroundColor:[UIColor whiteColor]];
    
    [pickerToolBarView addSubview:toolBar];
    [pickerToolBarView addSubview:self.aPickerView];
    [self.view addSubview:pickerToolBarView];
    [self.view bringSubviewToFront:pickerToolBarView];
    [pickerToolBarView setHidden:YES];

    //Setting for Segment Control
    if (self.landingScreen==1) {
        
        self.title = @"Payment";
        NSString *string = [NSString stringWithFormat:@"Pay Rs %@",self.amount];
        [self.loadButton setTitle:string forState:UIControlStateNormal];
    }
    else if (self.landingScreen==0){
        self.title = @"Load Money";
        NSString *string = [NSString stringWithFormat:@"Load Rs %@",self.amount];
        [self.loadButton setTitle:string forState:UIControlStateNormal];
    }
    else if (self.landingScreen==2){
        self.title = @"Dynamic Pricing";
        NSString *string = [NSString stringWithFormat:@"Pay Rs %@",self.ruleInfo.originalAmount];
        [self.loadButton setTitle:string forState:UIControlStateNormal];
        
        self.amount = string;
    }
    
    // Segmented control with scrolling
    HMSegmentedControl *segmentedControl ;
    
    if (self.isDirectPaymentEnable) {
        segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Debit Card", @"Credit Card", @"Net Banking"]];
    }
    else{
        
        segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Saved Card", @"Debit Card", @"Credit Card", @"Net Banking"]];
    }
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    segmentedControl.frame = CGRectMake(0, 64, viewWidth, 45);
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor whiteColor];
    segmentedControl.verticalDividerWidth = 1.5f;
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(loadUsingCard:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:segmentedControl];
    
    [self loadUsingCard:nil];
    imageDict = [[CTSDataCache sharedCache] fetchCachedDataForKey:BANK_LOGO_KEY];
    
    
}

- (void)calculatePaymentDistribution {
    
    [paymentLayer requestCalculatePaymentDistribution:self.amount
                             completionHandler:^(CTSSimpliChargeDistribution *amountDistribution,
                                                 NSError *error) {
                                 
                                 if (error) {
                                     NSLog(@"error %@", [error localizedDescription]);
                                 }
                                 else {
                                     _amountDistribution = amountDistribution;
                                     _useMVC = amountDistribution.useMVC;
                                     _useCash = amountDistribution.useCash;
                                     NSLog(@"_amountDistribution %@", _amountDistribution);
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         [self.saveCardsTableView reloadData];
                                     });
                                 }
                                 
                             }];
    
}


#pragma mark - Action Methods

- (IBAction)loadUsingCard:(id)sender {
    
    _segControl = (UISegmentedControl *)sender;
    
    [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetUI];
    });
    [pickerToolBarView setHidden:TRUE];
    self.loadButton.hidden = FALSE;
    self.loadButton.userInteractionEnabled = TRUE;
    
    if (self.isDirectPaymentEnable) {
        if (_segControl.selectedSegmentIndex==0 ||
            _segControl.selectedSegmentIndex==1) {
            
            [self.saveCardsTableView setHidden:TRUE];
            self.ccddtableView.hidden = FALSE;
            self.netBankCodeTextField.hidden = TRUE;
            
        }
        else if (_segControl.selectedSegmentIndex==2){
            
            [self.saveCardsTableView setHidden:TRUE];
            self.ccddtableView.hidden = TRUE;
            self.netBankCodeTextField.hidden = FALSE;
            self.loadButton.userInteractionEnabled = FALSE;
        }
    }
    else {
        if (_segControl.selectedSegmentIndex==0){
            
            [self.saveCardsTableView setHidden:FALSE];
            self.ccddtableView.hidden = TRUE;
            self.netBankCodeTextField.hidden = TRUE;
            self.loadButton.hidden = FALSE;
            
            _useSavedAccounts = YES;
        }
        else if (_segControl.selectedSegmentIndex==1 ||
                 _segControl.selectedSegmentIndex==2) {
            
            [self.saveCardsTableView setHidden:TRUE];
            self.ccddtableView.hidden = FALSE;
            self.netBankCodeTextField.hidden = TRUE;
            
            [self.ccddtableView reloadData];
            if (_segControl.selectedSegmentIndex==2) {
                if ([authLayer isLoggedIn]) {
                    [self getActiveSubs:nil];
                }
            }
            
            _useMVC = NO;
            _useCash = NO;
            
            _useSavedAccounts = NO;
            
        }
        else if (_segControl.selectedSegmentIndex==3){
            
            [self.saveCardsTableView setHidden:TRUE];
            self.ccddtableView.hidden = TRUE;
            self.netBankCodeTextField.hidden = FALSE;
            self.loadButton.userInteractionEnabled = FALSE;
            
            _useSavedAccounts = NO;
        }
        else if (_segControl.selectedSegmentIndex==4){
            
            [self.saveCardsTableView setHidden:TRUE];
            self.ccddtableView.hidden = TRUE;
            self.netBankCodeTextField.hidden = TRUE;
            self.loadButton.hidden = TRUE;
            
            _useSavedAccounts = NO;
        }
        
    }
}

- (IBAction)getSaveCards:(id)sender {
    
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
    [proifleLayer requestPaymentInformationWithCompletionHandler:^(CTSConsumerProfile * consumerProfile,
                                                                   NSError * error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
            
        });
        if(error){
            // Your code to handle error.
            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Couldn't find saved cards \nerror: %@",[error localizedDescription]]];
        }
        else {
            // Your code to handle success.
            
            // get saved NetBanking payment options
            NSArray  *netBankingArray = [consumerProfile getSavedNBPaymentOptions];
            NSLog(@"netBankingArray %@", netBankingArray);
            
            // get saved Debit cards payment options
            NSArray  *debitCardArray = [consumerProfile getSavedDCPaymentOptions];
            NSLog(@"debitCardArray %@", debitCardArray);
            
            // get saved Credit cards payment options
            NSArray  *creditCardArray = [consumerProfile getSavedCCPaymentOptions];
            NSLog(@"creditCardArray %@", creditCardArray);
            
            if ([_balancesArray count] != 0) {
                [_balancesArray removeAllObjects];
            }
            
            if ([_savedAccountsArray count] != 0) {
                [_savedAccountsArray removeAllObjects];
            }
            
            NSMutableString *toastString = [[NSMutableString alloc] init];
            if([consumerProfile.paymentOptionsList count])
            {
                for (NSDictionary *dict in [consumerProfile.paymentOptionsList mutableCopy]) {
                    if ([[dict valueForKey:@"paymentMode"] isEqualToString:@"MVC"]) {
                        [_balancesArray addObject:dict];
                        NSDecimal myFloatDecimal = [[NSNumber numberWithFloat:[[dict valueForKey:@"maxBalance"] floatValue]] decimalValue];
                        _mvcMaxBalance = [NSDecimalNumber decimalNumberWithDecimal:myFloatDecimal];
                    }
                    else if ([[dict valueForKey:@"paymentMode"] isEqualToString:@"PREPAID_CARD"]) {
                        [_balancesArray addObject:dict];
                        NSDecimal myFloatDecimal = [[NSNumber numberWithFloat:[[dict valueForKey:@"maxBalance"] floatValue]] decimalValue];
                        _cashMaxBalance = [NSDecimalNumber decimalNumberWithDecimal:myFloatDecimal];
                    }
                    else {
                        [_savedAccountsArray addObject:dict];
                    }
                }
                NSLog(@"saveCardsArray %@", _savedAccountsArray);
                NSLog(@"_balancesArray %@", _balancesArray);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.saveCardsTableView reloadData];
                });
                
            }
            else{
                toastString =(NSMutableString *) @"No saved cards, please save card first";
                [UIUtility toastMessageOnScreen:toastString];
            }
        }
    }];
}

- (IBAction)saveCard:(id)sender {
    
    self.loadButton.userInteractionEnabled = TRUE;
    
    [self setPaymentInfoForSmartPay];
    
    switchView = (UISwitch *)sender;
    
    NSString *resultantDate;
    if (self.expiryDateTextField.text.length!=0) {
        NSArray* subStrings = [self.expiryDateTextField.text componentsSeparatedByString:@"/"];
        int year = [[subStrings objectAtIndex:1] intValue]+2000;
        resultantDate = [NSString stringWithFormat:@"%d/%d",[[subStrings objectAtIndex:0] intValue],year];
    }
    
    if (self.cardNumberTextField.text.length>0) {
        NSString *scheme = [CTSUtility fetchCardSchemeForCardNumber:self.cardNumberTextField.text];
        if ([scheme isEqualToString:@"MTRO"] && self.cvvTextField.text.length==0 && self.expiryDateTextField.text.length==0) {
            self.expiryDateTextField.text = @"11/2019";
            self.cvvTextField.text = @"123";
        }
    }
    
    // Configure your request here.
    if (self.cardNumberTextField.text.length==0 || self.expiryDateTextField.text.length==0 || self.cvvTextField.text.length==0 || self.ownerNameTextField.text.length==0) {
        [UIUtility toastMessageOnScreen:@"Couldn't save this card.\n All fields are mandatory."];
        [switchView setOn:NO animated:YES];
    }
    else if (![CTSUtility validateExpiryDate:resultantDate]){
        [UIUtility toastMessageOnScreen:@"Expiry date is not valid."];
        [switchView setOn:NO animated:YES];
    }
    else{
        
        [proifleLayer updatePaymentInformation:_paymentOptions
                         withCompletionHandler:^(NSError *error) {
                             self.loadButton.userInteractionEnabled = TRUE;
                             if(error == nil){
                                 // Your code to handle success.
                                 [UIUtility toastMessageOnScreen:@"Successfully card saved"];
                             }
                             else {
                                 [switchView setOn:NO animated:YES];
                                 // Your code to handle error.
                                 [UIUtility toastMessageOnScreen:error.localizedDescription];
                             }
                         }];
    }
    
}


-(void)requestLoadMoneyPgSettings {
    
    [paymentLayer requestLoadMoneyPgSettingsCompletionHandler:^(CTSPgSettings *pgSettings, NSError *error){
        if(error){
            //handle error
            LogTrace(@"[error localizedDescription] %@ ", [error localizedDescription]);
        }
        else {
            debitArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.debitCard] allObjects] ];
            creditArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.creditCard] allObjects] ];
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            
            
            LogTrace(@" pgSettings %@ ", pgSettings);
            for (NSString* val in creditArray) {
                LogTrace(@"CC %@ ", val);
            }
            
            for (NSString* val in debitArray) {
                LogTrace(@"DC %@ ", val);
            }
            
            _banksArray = pgSettings.netBanking;
            
            for (NSDictionary* arr in pgSettings.netBanking) {
                //setting the object for Issuer bank code in Dictionary
                [tempDict setObject:[arr valueForKey:@"issuerCode"] forKey:[arr valueForKey:@"bankName"]];
                
                LogTrace(@"bankName %@ ", [arr valueForKey:@"bankName"]);
                LogTrace(@"issuerCode %@ ", [arr valueForKey:@"issuerCode"]);
                
            }
            netBankingDict = tempDict;
        }
        
    }];
    
    
}

- (void)requestPaymentModes {
    [paymentLayer requestMerchantPgSettings:VanityUrl withCompletionHandler:^(CTSPgSettings *pgSettings, NSError *error) {
        if(error){
            //handle error
            LogTrace(@"[error localizedDescription] %@ ", [error localizedDescription]);
        }
        else {
            debitArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.debitCard] allObjects] ];
            creditArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.creditCard] allObjects] ];
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            
            
            LogTrace(@" pgSettings %@ ", pgSettings);
            for (NSString* val in creditArray) {
                LogTrace(@"CC %@ ", val);
            }
            
            for (NSString* val in debitArray) {
                LogTrace(@"DC %@ ", val);
            }
            
            _banksArray = pgSettings.netBanking;
            
            for (NSDictionary* arr in pgSettings.netBanking) {
                //setting the object for Issuer bank code in Dictionary
                [tempDict setObject:[arr valueForKey:@"issuerCode"] forKey:[arr valueForKey:@"bankName"]];
                
                LogTrace(@"bankName %@ ", [arr valueForKey:@"bankName"]);
                LogTrace(@"issuerCode %@ ", [arr valueForKey:@"issuerCode"]);
                
            }
            netBankingDict = tempDict;
        }
    }];
}

- (void)updateSwitchAtIndexPath:(UISwitch *)localSwitchView {
    
    if ([localSwitchView isOn]) {
        [localSwitchView setOn:YES animated:YES];
        [self saveCard:localSwitchView];
    } else {
        [localSwitchView setOn:NO animated:YES];
        
    }
    
}

- (IBAction)loadOrPayMoney:(id)sender {
    _allSet = YES;
    if (self.landingScreen==1) {
        [self setPaymentInfoForSmartPay];
        [self paymentSummary];
    }
    else if(self.landingScreen==0){
        [self setPaymentInfoForSmartPay];
        [self paymentSummary];
    }
    else if(self.landingScreen==2){
        [self setPaymentInfoForSmartPay];
        [self paymentSummary];
    }
}

- (void)loadOrPayDPMoney {
    if (self.landingScreen==1) {
        if (_allSet) {
            [self simpliPay];
        }
    }
    else if(self.landingScreen==0){
        if (_allSet) {
            [self loadMoneyInCitrusPay];
        }
    }
    else if(self.landingScreen==2){
        if (_allSet) {
            [self dynamicPricing];
        }
    }
}


- (void)validateCardSchemesBanks {
    
    [self.view endEditing:YES];
//    NSString *cardNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    if (_segControl.selectedSegmentIndex==1) {
//        if (debitArray.count==0) {
//            [UIUtility toastMessageOnScreen:@"Please Contact to Citruspay care to enable your card scheme."];
//            _allSet = NO;
//            return;
//        }
//        else{
//            BOOL isSchemeAvailable = FALSE;
//            for(NSString *string in debitArray){
//                NSLog(@"card scheme %@",[CTSUtility fetchCardSchemeForCardNumber:cardNumber]);
//                if ([string caseInsensitiveCompare:[CTSUtility fetchCardSchemeForCardNumber:cardNumber]] == NSOrderedSame) {
//                    isSchemeAvailable=TRUE;
//                    break;
//                }
//            }
            NSArray* subStrings = [self.expiryDateTextField.text componentsSeparatedByString:@"/"];
            if ([self.expiryDateTextField.text length] != 0) {
                int year = [[subStrings objectAtIndex:1] intValue]+2000;
                NSString *resultantDate = [NSString stringWithFormat:@"%d/%d",[[subStrings objectAtIndex:0] intValue],year];
                if (![CTSUtility validateExpiryDate:resultantDate]){
                    [UIUtility toastMessageOnScreen:@"Expiry date is not valid."];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        self.indicatorView.hidden = TRUE;
                    });
                    return;
                }
            }
//        }
//    }
//    else if (_segControl.selectedSegmentIndex==1){

//        if (creditArray.count==0) {
//            [UIUtility toastMessageOnScreen:@"Please Contact to Citruspay care to enable your card scheme."];
//            _allSet = NO;
//            return;
//        }
//        else{
        
//            BOOL isSchemeAvailable = FALSE;
//            for(NSString *string in creditArray){
//                if ([string caseInsensitiveCompare:[CTSUtility fetchCardSchemeForCardNumber:cardNumber]] == NSOrderedSame) {
//                    isSchemeAvailable = TRUE;
//                    break;
//                }
//            }
//            if (!isSchemeAvailable) {
//                
//                [UIUtility toastMessageOnScreen:@"This card scheme is not valid for you.Please Contact to Citruspay care."];
//                _allSet = NO;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.indicatorView stopAnimating];
//                    self.indicatorView.hidden = TRUE;
//                });
//                return;
//            }
            
//            NSArray* subStrings = [self.expiryDateTextField.text componentsSeparatedByString:@"/"];
//            if ([self.expiryDateTextField.text length] != 0) {
//                int year = [[subStrings objectAtIndex:1] intValue]+2000;
//                NSString *resultantDate = [NSString stringWithFormat:@"%d/%d",[[subStrings objectAtIndex:0] intValue],year];
//                if (![CTSUtility validateExpiryDate:resultantDate]){
//                    [UIUtility toastMessageOnScreen:@"Expiry date is not valid."];
//                    _allSet = NO;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [self.indicatorView stopAnimating];
//                        self.indicatorView.hidden = TRUE;
//                    });
//                    return;
//                }
//            }
//        }
//    }
}

- (void)setPaymentInfoForSmartPay {
    
    _allSet = YES;
    
    NSDecimal zero = [NSDecimalNumber zero].decimalValue;
    totalEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    
    mvcEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    prepiadEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    otherEnteredAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    
    NSDecimalNumber *remiainingAmount;
    remiainingAmount = [NSDecimalNumber decimalNumberWithDecimal:zero];
    
    
    if (self.landingScreen == 0 ||
        self.landingScreen == 2) {
        if (_useSavedAccounts) {
            if (_useOther) {
                otherEnteredAmount = [otherEnteredAmount decimalNumberByAdding:transactionAmount];
                totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:otherEnteredAmount];
            }
        }
        else {
            otherEnteredAmount = [otherEnteredAmount decimalNumberByAdding:transactionAmount];
            totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:otherEnteredAmount];
        }
        
        LogTrace(@"_useOther");
        LogTrace(@"otherEnteredAmount %f", [otherEnteredAmount floatValue]);
        
        if ([totalEnteredAmount floatValue] != [transactionAmount floatValue]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Selected payment option is zero or more than transction amount.\nPlease try again"
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
        }
        else {
            _totalSelectedAmount = totalEnteredAmount;
        }
    }
    else {
        if (_useSavedAccounts) {
            
            if (_useMVC) {
                if ([_mvcMaxBalance floatValue] < [transactionAmount floatValue]) {
                    totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:_mvcMaxBalance];
                    mvcEnteredAmount = _mvcMaxBalance;
                }
                else {
                    totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:transactionAmount];
                    mvcEnteredAmount = totalEnteredAmount;
                }
                remiainingAmount = [transactionAmount decimalNumberBySubtracting:mvcEnteredAmount];
                
                LogTrace(@"_useMVC");
                LogTrace(@"mvcEnteredAmount %f", [mvcEnteredAmount floatValue]);
            }
            
            if (_useCash) {
                if ([remiainingAmount floatValue] == 0) {
                    if ([_cashMaxBalance floatValue] < [transactionAmount floatValue]) {
                        totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:_cashMaxBalance];
                        prepiadEnteredAmount = _cashMaxBalance;
                    }
                    else {
                        totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:transactionAmount];
                        prepiadEnteredAmount = transactionAmount;
                    }
                }
                else {
                    if ([_cashMaxBalance floatValue] < [remiainingAmount floatValue]) {
                        totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:_cashMaxBalance];
                        prepiadEnteredAmount = _cashMaxBalance;
                    }
                    else {
                        totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:remiainingAmount];
                        prepiadEnteredAmount = remiainingAmount;
                    }
                }
                
                if ([remiainingAmount floatValue] != 0) {
                    remiainingAmount = [transactionAmount decimalNumberBySubtracting:totalEnteredAmount];
                }
                else {
                    remiainingAmount = [transactionAmount decimalNumberBySubtracting:prepiadEnteredAmount];
                }
                
                LogTrace(@"_useCash");
                LogTrace(@"prepiadEnteredAmount %f", [prepiadEnteredAmount floatValue]);
            }
            
            if (_useOther) {
                if ([remiainingAmount floatValue] != 0) {
                    totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:remiainingAmount];
                    otherEnteredAmount = remiainingAmount;
                }
                else if ([totalEnteredAmount floatValue] != 0 &&
                         !_useMVC &&
                         !_useCash) {
                    otherEnteredAmount = [transactionAmount decimalNumberBySubtracting:totalEnteredAmount];
                    totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:otherEnteredAmount];
                }
                else {
                    otherEnteredAmount = [otherEnteredAmount decimalNumberByAdding:transactionAmount];
                    totalEnteredAmount = [totalEnteredAmount decimalNumberByAdding:otherEnteredAmount];
                }
                LogTrace(@"_useOther");
                LogTrace(@"otherEnteredAmount %f", [otherEnteredAmount floatValue]);
            }
            
            if ([totalEnteredAmount floatValue] > [transactionAmount floatValue]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Selected payment option is more than transaction amount.\nPlease try again"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                _allSet = NO;
                return;
            }
            else if ([totalEnteredAmount floatValue] < [transactionAmount floatValue]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Selected payment option is less than transaction amount.\nPlease try again"
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
                _allSet = NO;
                return;
            }
            else {
                _totalSelectedAmount = totalEnteredAmount;
            }
        }
        else {
            otherEnteredAmount = [otherEnteredAmount decimalNumberByAdding:transactionAmount];
            _totalSelectedAmount = otherEnteredAmount;
            totalEnteredAmount = otherEnteredAmount;
            LogTrace(@"_useOther");
            LogTrace(@"otherEnteredAmount %f", [otherEnteredAmount floatValue]);
        }
    }
    LogTrace(@"totalEnteredAmount %f", [totalEnteredAmount floatValue]);
    
    _paymentOptions = nil;
    
    if (!_useMVC ||
        !_useCash ||
        [otherEnteredAmount floatValue] != 0.00) {
        NSString *cardNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (self.isDirectPaymentEnable) {
            if (_segControl.selectedSegmentIndex==0 ||
                _segControl.selectedSegmentIndex==1) {
                if (cardNumber.length == 0 ||
                    self.expiryDateTextField.text.length == 0 ||
                    self.cvvTextField.text.length == 0) {
                    UIAlertView *cvvAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Payment details can't be blank.\nPlease enter correct payment details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [cvvAlert show];
                    _allSet = NO;
                    return;
                }
            }
            
            if (_segControl.selectedSegmentIndex==0) {
                // Debit card
                _paymentOptions = [CTSPaymentOptions debitCardOption:cardNumber
                                                      cardExpiryDate:self.expiryDateTextField.text
                                                                 cvv:self.cvvTextField.text];
                selectedPaymentoption = cardNumber;
            }
            else if (_segControl.selectedSegmentIndex==1) {
                // Credit card
                _paymentOptions = [CTSPaymentOptions creditCardOption:cardNumber
                                                       cardExpiryDate:self.expiryDateTextField.text
                                                                  cvv:self.cvvTextField.text];
                selectedPaymentoption = cardNumber;
            }
            else if (_segControl.selectedSegmentIndex==2){
                NSString *code = [netBankingDict valueForKey:self.netBankCodeTextField.text];
                [_banksArray enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
                    /* Do something with |obj|. */
                    if ([obj[@"issuerCode"] isEqualToString:code]) {
                        selectedPaymentoption = obj[@"bankName"];
                    }
                }];
                
                _paymentOptions = [CTSPaymentOptions netBankingOption:selectedPaymentoption
                                                           issuerCode:code];
                
            }
            
        }
        else {
            if (_segControl.selectedSegmentIndex==1 ||
                _segControl.selectedSegmentIndex==2) {
                if (cardNumber.length == 0 ||
                    self.expiryDateTextField.text.length == 0 ||
                    self.cvvTextField.text.length == 0) {
                    UIAlertView *cvvAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Payment details can't be blank.\nPlease enter correct payment details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [cvvAlert show];
                    _allSet = NO;
                    return;
                }
            }
            
            if (_segControl.selectedSegmentIndex==1) {
                // Debit card
                _paymentOptions = [CTSPaymentOptions debitCardOption:cardNumber
                                                      cardExpiryDate:self.expiryDateTextField.text
                                                                 cvv:self.cvvTextField.text];
                selectedPaymentoption = cardNumber;
            }
            else if (_segControl.selectedSegmentIndex==2) {
                // Credit card
                _paymentOptions = [CTSPaymentOptions creditCardOption:cardNumber
                                                       cardExpiryDate:self.expiryDateTextField.text
                                                                  cvv:self.cvvTextField.text];
                selectedPaymentoption = cardNumber;
            }
            else if (_segControl.selectedSegmentIndex==3){
                NSString *code = [netBankingDict valueForKey:self.netBankCodeTextField.text];
                [_banksArray enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
                    /* Do something with |obj|. */
                    if ([obj[@"issuerCode"] isEqualToString:code]) {
                        selectedPaymentoption = obj[@"bankName"];
                    }
                }];
                
                _paymentOptions = [CTSPaymentOptions netBankingOption:selectedPaymentoption
                                                           issuerCode:code];
                
            }
            else if (_segControl.selectedSegmentIndex==0){
                
                [_savedAccountsArray enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
                    /* Do something with |obj|. */
                    if ([[obj valueForKey:@"selected"] boolValue] == YES) {
                        selectedRow = idx;
                    }
                }];
                
                if (selectedRow != NSNotFound) {
                    
                    JSONModelError* jsonError;
                    CTSConsumerProfileDetails* consumerProfileDetails = [[CTSConsumerProfileDetails alloc]
                                                                         initWithDictionary:[_savedAccountsArray objectAtIndex:selectedRow]
                                                                         error:&jsonError];
                    selectedPaymentoption = consumerProfileDetails.name;
                    
                    if ([consumerProfileDetails.paymentMode isEqualToString:@"DEBIT_CARD"]) {
                        [consumerProfileDetails setCvv:cvvText];
                        _paymentOptions = [CTSPaymentOptions debitCardTokenized:consumerProfileDetails];
                    }
                    else if ([consumerProfileDetails.paymentMode isEqualToString:@"CREDIT_CARD"]) {
                        [consumerProfileDetails setCvv:cvvText];
                        _paymentOptions = [CTSPaymentOptions creditCardTokenized:consumerProfileDetails];
                    }
                    else if ([consumerProfileDetails.paymentMode isEqualToString:@"NET_BANKING"]) {
                        _paymentOptions = [CTSPaymentOptions netBankingTokenized:consumerProfileDetails];
                    }
                }
            }
            
        }
    }
    
    [self validateCardSchemesBanks];
}

- (void)paymentSummary {
    
    if (_allSet) {
        NSString *message = [[NSString alloc] init];
        
        NSString *title;
        title = [NSString stringWithFormat:@"Payment Summary\n\nTotal Amount : %@", _totalSelectedAmount];
        
        if (_useSavedAccounts) {
            if ([mvcEnteredAmount floatValue] != 0.0) {
                message = [message stringByAppendingString:[NSString stringWithFormat:@"\nMVC Amount : %@", mvcEnteredAmount]];
            }
            
            if ([prepiadEnteredAmount floatValue] != 0.0) {
                message = [message stringByAppendingString:[NSString stringWithFormat:@"\nPrepaid Amount : %@", prepiadEnteredAmount]];
            }
        }
        
        if ([otherEnteredAmount floatValue] != 0.0) {
            message = [message stringByAppendingString:[NSString stringWithFormat:@"\nCharge Payment option : %@\nAmount : %@", selectedPaymentoption, otherEnteredAmount]];
        }
        
        if ([totalEnteredAmount floatValue] != 0.0) {
            message = [message stringByAppendingString:[NSString stringWithFormat:@"\nTotal selected amount : %@", totalEnteredAmount]];
        }
        
        
        if ([mvcEnteredAmount floatValue] != 0 ||
            [prepiadEnteredAmount floatValue] != 0 ||
            [otherEnteredAmount floatValue] != 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Not Now"
                                                      otherButtonTitles:@"Pay Now", nil];
                alert.tag = 2000;
                [alert show];
            });
        }
        
    }
}


- (void)simpliPay {

    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
    if (_segControl.selectedSegmentIndex==1 ||
        _segControl.selectedSegmentIndex==2 ||
        _segControl.selectedSegmentIndex==3) {
        _useMVC = NO;
        _useCash = NO;
    }

    
    NSString *totalSelectedAmount = [NSString stringWithFormat:@"%.02f", [_totalSelectedAmount floatValue]];
    
    // If you wish to use BillURL follow below signature
    PaymentType *paymentType;
    if ((!_useMVC && !_useCash) && _paymentOptions) {
        paymentType = [PaymentType PGPayment:totalSelectedAmount
                                     billUrl:BillUrl
                               paymentOption:_paymentOptions
                                     contact:contactInfo
                                     address:addressInfo];
    }
    if ((_useMVC ||_useCash) && _paymentOptions) {
        paymentType = [PaymentType splitPayment:totalSelectedAmount
                                        billUrl:BillUrl
                                         useMVC:_useMVC
                                        useCash:_useCash
                                  paymentOption:_paymentOptions
                                        contact:contactInfo
                                        address:addressInfo];
    }
    else if (_useMVC && !_paymentOptions) {
        paymentType = [PaymentType mvcPayment:totalSelectedAmount
                                      billUrl:BillUrl
                                      contact:contactInfo
                                      address:addressInfo];
    }
    else if (_useCash && !_paymentOptions) {
        paymentType = [PaymentType citrusCashPayment:totalSelectedAmount
                                             billUrl:BillUrl
                                             contact:contactInfo
                                             address:addressInfo];
    }
    
    [paymentLayer requestSimpliPay:paymentType
           andParentViewController:self
                 completionHandler:^(CTSPaymentReceipt *paymentReceipt, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.indicatorView stopAnimating];
                         self.indicatorView.hidden = TRUE;
                     });
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (error) {
                             [UIUtility toastMessageOnScreen:[error localizedDescription]];
                             NSLog(@"error %@", [error localizedDescription]);
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                         else {
                             NSLog(@"response %@", paymentReceipt.toDictionary);
                             
                             NSString *paymentStatus = paymentReceipt.toDictionary[@"TxStatus"];
                             if ([paymentStatus length] == 0) {
                                 paymentStatus = paymentReceipt.toDictionary[@"Reason"];
                             }
                             
                             [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Payment Status: %@", paymentStatus]];
                             [self resetUI];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     });
                 }];
    
    
    // optional
// If you wish to use CTSBill object follow below signature
/*
    [CTSUtility requestBillAmount:totalSelectedAmount
                          billURL:BillUrl
                         callback: ^(CTSBill *bill,
                                     NSError *error) {
                             if (error) {
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     [self.indicatorView stopAnimating];
                                     self.indicatorView.hidden = TRUE;
                                 });
                                 [UIUtility toastMessageOnScreen:[error localizedDescription]];
                                 NSLog(@"error %@", [error localizedDescription]);
                                 [self.navigationController popViewControllerAnimated:YES];
                                 return;
                             }
                             else {
                                 bill.customParameters = customParams; // optional
                                 
                                 PaymentType *paymentType;
                                 if ((!_useMVC && !_useCash) && _paymentOptions) {
                                     paymentType = [PaymentType PGPayment:totalSelectedAmount
                                                                  billObject:bill
                                                            paymentOption:_paymentOptions
                                                                  contact:contactInfo
                                                                  address:addressInfo];
                                 }
                                 if ((_useMVC ||_useCash) && _paymentOptions) {
                                     paymentType = [PaymentType splitPayment:totalSelectedAmount
                                                                  billObject:bill
                                                                      useMVC:_useMVC
                                                                     useCash:_useCash
                                                               paymentOption:_paymentOptions
                                                                     contact:contactInfo
                                                                     address:addressInfo];
                                 }
                                 else if (_useMVC && !_paymentOptions) {
                                     paymentType = [PaymentType mvcPayment:totalSelectedAmount
                                                                billObject:bill
                                                                   contact:contactInfo
                                                                   address:addressInfo];
                                 }
                                 else if (_useCash && !_paymentOptions) {
                                     paymentType = [PaymentType citrusCashPayment:totalSelectedAmount
                                                                       billObject:bill
                                                                          contact:contactInfo
                                                                          address:addressInfo];
                                 }
                                 
                                 [paymentLayer requestSimpliPay:paymentType
                                        andParentViewController:self
                                              completionHandler:^(CTSPaymentReceipt *paymentReceipt, NSError *error) {
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      [self.indicatorView stopAnimating];
                                                      self.indicatorView.hidden = TRUE;
                                                  });
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      if (error) {
                                                          [UIUtility toastMessageOnScreen:[error localizedDescription]];
                                                          NSLog(@"error %@", [error localizedDescription]);
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }
                                                      else {
                                                          NSLog(@"response %@", paymentReceipt.toDictionary);
                                                          
                                                          NSString *paymentStatus = paymentReceipt.toDictionary[@"TxStatus"];
                                                          if ([paymentStatus length] == 0) {
                                                              paymentStatus = paymentReceipt.toDictionary[@"Reason"];
                                                          }
                                                          
                                                          [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Payment Status: %@", paymentStatus]];
                                                          [self resetUI];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      }
                                                  });
                                              }];
                             }
                         }];
 */
}


- (void)loadMoneyInCitrusPay {
    
    
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
    NSString *totalSelectedAmount = [NSString stringWithFormat:@"%.02f", [_totalSelectedAmount floatValue]];
    
    PaymentType *paymentType;
    paymentType = [PaymentType loadMoney:totalSelectedAmount
                               returnUrl:LoadWalletReturnUrl
                           paymentOption:_paymentOptions
                            customParams:customParams
                                 contact:contactInfo
                                 address:addressInfo];

    [paymentLayer requestSimpliPay:paymentType
           andParentViewController:self
                 completionHandler:^(CTSPaymentReceipt *paymentReceipt, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.indicatorView stopAnimating];
                         self.indicatorView.hidden = TRUE;
                     });
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (error) {
                             [UIUtility toastMessageOnScreen:[error localizedDescription]];
                             NSLog(@"error %@", [error localizedDescription]);
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                         else {
                             NSLog(@"response %@", paymentReceipt.toDictionary);
                             //                             [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Load Money Status %@",[paymentReceipt.toDictionary valueForKey:LoadMoneyResponeKey]]];
                             [self resetUI];
                             
                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Load Money Status %@",[paymentReceipt.toDictionary valueForKey:LoadMoneyResponeKey]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                             
                             if (_segControl.selectedSegmentIndex==2) {
                                 alert.delegate = self;
                                 alert.tag = 102;
                             }
                             [alert show];
                             //[self.navigationController popViewControllerAnimated:YES];
                         }
                     });
                 }];
}



- (void)dynamicPricing {
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
    NSString *totalSelectedAmount = [NSString stringWithFormat:@"%.02f", [_totalSelectedAmount floatValue]];

    // If you wish to use BillURL follow below signature
    PaymentType *paymentType;
    paymentType = [PaymentType performDynamicPricing:totalSelectedAmount
                                             billUrl:BillUrl
                                       paymentOption:_paymentOptions
                                            ruleInfo:self.ruleInfo
                                         extraParams:nil
                                             contact:contactInfo
                                             address:addressInfo];
    
    //
    [paymentLayer requestSimpliPay:paymentType
           andParentViewController:self
                 completionHandler:^(CTSPaymentReceipt *paymentReceipt, NSError *error) {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self.indicatorView stopAnimating];
                         self.indicatorView.hidden = TRUE;
                     });
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         if (error) {
                             [UIUtility toastMessageOnScreen:[error localizedDescription]];
                             NSLog(@"error %@", [error localizedDescription]);
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                         else {
                             NSLog(@"response %@", paymentReceipt.toDictionary);
                             
                             NSString *paymentStatus = paymentReceipt.toDictionary[@"TxStatus"];
                             if ([paymentStatus length] == 0) {
                                 paymentStatus = paymentReceipt.toDictionary[@"Reason"];
                             }
                             
                             [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Payment Status: %@", paymentStatus]];
                             [self resetUI];
                             [self.navigationController popViewControllerAnimated:YES];
                         }
                     });
                 }];

    
    // optional
    // If you wish to use CTSBill object follow below signature
/*
    [CTSUtility requestDPBillForRule:self.ruleInfo
                             billURL:BillUrl
                            callback:^(CTSBill *bill, NSError *error) {
                                if (error) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self.indicatorView stopAnimating];
                                        self.indicatorView.hidden = TRUE;
                                    });
                                    
                                    [UIUtility toastMessageOnScreen:[error localizedDescription]];
                                    NSLog(@"error %@", [error localizedDescription]);
                                    [self.navigationController popViewControllerAnimated:YES];
                                }
                                else {
                                    PaymentType *paymentType;
                                    paymentType = [PaymentType performDynamicPricing:totalSelectedAmount
                                                                          billObject:bill
                                                                       paymentOption:_paymentOptions
                                                                            ruleInfo:self.ruleInfo
                                                                         extraParams:nil
                                                                             contact:contactInfo
                                                                             address:addressInfo];
                                    
                                    //
                                    [paymentLayer requestSimpliPay:paymentType
                                           andParentViewController:self
                                                 completionHandler:^(CTSPaymentReceipt *paymentReceipt, NSError *error) {
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self.indicatorView stopAnimating];
                                                         self.indicatorView.hidden = TRUE;
                                                     });
                                                     
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (error) {
                                                             [UIUtility toastMessageOnScreen:[error localizedDescription]];
                                                             NSLog(@"error %@", [error localizedDescription]);
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }
                                                         else {
                                                             NSLog(@"response %@", paymentReceipt.toDictionary);
                                                             
                                                             NSString *paymentStatus = paymentReceipt.toDictionary[@"TxStatus"];
                                                             if ([paymentStatus length] == 0) {
                                                                 paymentStatus = paymentReceipt.toDictionary[@"Reason"];
                                                             }
                                                             
                                                             [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Payment Status: %@", paymentStatus]];
                                                             [self resetUI];
                                                             [self.navigationController popViewControllerAnimated:YES];
                                                         }
                                                     });
                                                 }];

                                }
                            }];
  */
}

- (void)resignKeyboard:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)hidePickerView{
    self.loadButton.userInteractionEnabled = TRUE;
    [currentTextField resignFirstResponder];
    [pickerToolBarView setHidden:YES];
}


-(IBAction)getActiveSubs:(id)sender{
    
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    CTSPaymentLayer *paymentlayer = [CitrusPaymentSDK fetchSharedPaymentLayer];
    [paymentlayer requestGetAutoLoadSubType:AutoLoadSubsctiptionTypeActive completion:^(CTSAutoLoadSubGetResp *autoloadSubscriptions, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
        });
        if (error) {
            [UIUtility toastMessageOnScreen:[error localizedDescription]];
        }
        else{
            if (autoloadSubscriptions.subcriptions.count==0) {
                autoloadSwitch.userInteractionEnabled = TRUE;
                isAnySubscriptionActive = NO;
            }
            else{
                autoloadSwitch.userInteractionEnabled = FALSE;
                isAnySubscriptionActive = YES;
            }
        }
    }];
}

- (void)loadMoneyWithAutoloadView:(UISwitch *)localSwitchView {
    
    if ([localSwitchView isOn]) {
        [localSwitchView setOn:YES animated:YES];
        
        [self setPaymentInfoForSmartPay];
        if (self.cardNumberTextField.text.length==0 || self.expiryDateTextField.text.length==0 || self.cvvTextField.text.length==0 || self.ownerNameTextField.text.length==0) {
//            [UIUtility toastMessageOnScreen:@"Couldn't do Autoload.\n All fields are mandatory."];
            [localSwitchView setOn:NO animated:YES];
        }
        else {
            [self performSegueWithIdentifier:@"AutoloadViewIdentifier" sender:self];
        }
        
    } else {
        [localSwitchView setOn:NO animated:YES];
        
    }
    
}


#pragma mark - TextView Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.netBankCodeTextField resignFirstResponder];

    if (textField==self.netBankCodeTextField) {
        
        if (netBankingDict.count==0) {
            [pickerToolBarView setHidden:TRUE];
//            [self.netBankCodeTextField resignFirstResponder];
            [UIUtility toastMessageOnScreen:@"Please Contact to Citruspay care to enable your Net banking."];
        }
        else{
            [pickerToolBarView setHidden:NO];
            currentTextField=textField;
            array = [netBankingDict allKeys];
            [self.aPickerView reloadAllComponents];
            [self.aPickerView selectRow:0 inComponent:0 animated:YES];
            [self pickerView:self.aPickerView didSelectRow:0 inComponent:0];
//            [self.netBankCodeTextField becomeFirstResponder];
        }
    }
}

-(BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    if (textField.tag == 2000) {
        __block NSString *text = [textField text];
        if ([textField.text isEqualToString:@""] || ( [string isEqualToString:@""] && textField.text.length==1)) {
            self.schemeTypeImageView.image = [CTSUtility getSchmeTypeImage:string forParentView:self.view];
        }
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length>1) {
            self.schemeTypeImageView.image = [CTSUtility getSchmeTypeImage:text forParentView:self.view];
        }
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if (newString.length>1) {
            NSString* scheme = [CTSUtility fetchCardSchemeForCardNumber:[newString stringByReplacingOccurrencesOfString:@" " withString:@""]];
            if ([scheme isEqualToString:@"MTRO"]) {
                if (newString.length >= 24) {
                    return NO;
                }
            }
            else{
                if (newString.length >= 20) {
                    return NO;
                }
            }
        }
        
        [textField setText:newString];
        return NO;
        
    }
    else if (textField==self.cvvTextField) {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int length = (int)[currentString length];
        if (length > 4) {
            return NO;
        }
    }
    else if (textField==self.expiryDateTextField) {
        __block NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789/"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        NSArray* subStrings = [text componentsSeparatedByString:@"/"];
        int month = [[subStrings objectAtIndex:0] intValue];
        if(month > 12){
            NSString *string=@"";
            string = [string stringByAppendingFormat:@"0%@",text];
            text = string;
        }
        text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 2)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 2 && ![newString containsString:@"/"]) {
                newString = [newString stringByAppendingString:@"/"];
            }
            text = [text substringFromIndex:MIN(text.length, 2)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if (newString.length >=6) {
            return NO;
        }
        
        [textField setText:newString];
        
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        else{
            return NO;
        }
    }
    
    return YES;
    
}

#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.landingScreen == 0 ||
       self.landingScreen == 2){
        return 1;
    }
    else
        return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    //
    if (tableView == self.saveCardsTableView) {
        if(section == 0 &&
           self.landingScreen == 1) {
            return _balancesArray.count;
        }
        else if(section == 1 ||
                self.landingScreen == 0 ||
                self.landingScreen == 2){
            return _savedAccountsArray.count;
        }
    }
    else {
        if (_segControl.selectedSegmentIndex==2 && self.landingScreen==0) {
            return 5;
        }
        else if(section == 0) {
            return 4;
        }
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.saveCardsTableView) {
        if(section == 0 &&
           self.landingScreen == 1) {
            return @"Balance Accounts details";
        }
        else if(section == 1 ||
                self.landingScreen == 0 ||
                self.landingScreen == 2){
            return @"Saved Accounts details";
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.saveCardsTableView) {
        return 120;
    }
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (tableView == self.ccddtableView) {
        if (indexPath.section == 0) {
            NSString *simpleTableIdentifier =[NSString stringWithFormat:@"test%d",(int)indexPath.row];
            cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            if (indexPath.row==0) {
                self.cardNumberTextField = (UITextField *)[cell.contentView viewWithTag:2000];
                self.cardNumberTextField.delegate = self;
                self.schemeTypeImageView = (UIImageView *)[cell.contentView viewWithTag:2001];
            }
            if (indexPath.row==1) {
                self.expiryDateTextField = (UITextField *)[cell.contentView viewWithTag:2002];
                self.expiryDateTextField.delegate = self;
                self.cvvTextField = (UITextField *)[cell.contentView viewWithTag:2004];
                self.cvvTextField.delegate = self;
            }
            if (indexPath.row==2) {
                self.ownerNameTextField = (UITextField *)[cell.contentView viewWithTag:2006];
                self.ownerNameTextField.delegate = self;
                
            }
            if (indexPath.row==3) {
                UISwitch *localSwitchView = (UISwitch *)[cell.contentView viewWithTag:2005];
                [localSwitchView addTarget:self action:@selector(updateSwitchAtIndexPath:)forControlEvents:UIControlEventValueChanged];
            }
            if (indexPath.row==4) {
                autoloadSwitch = (UISwitch *)[cell.contentView viewWithTag:2007];
                [autoloadSwitch addTarget:self action:@selector(loadMoneyWithAutoloadView:)forControlEvents:UIControlEventValueChanged];
            }
        }
    }
    else if (tableView == self.saveCardsTableView){
        
        if (indexPath.section == 0 &&
            self.landingScreen == 1) {
            static NSString *CellIdentifier = @"balanceIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.contentView viewWithTag:1000].layer.cornerRadius = 5;
            
            NSDictionary *balanceDict = [_balancesArray objectAtIndex:indexPath.row];
            if ([balanceDict[@"paymentMode"]  isEqualToString:@"MVC"]) {
                ((UILabel *) [cell.contentView viewWithTag:1001]).text = balanceDict[@"paymentMode"];
                ((UILabel *) [cell.contentView viewWithTag:1002]).text = [NSString stringWithFormat:@"Your Current Balance is Rs : %.02f", [balanceDict[@"maxBalance"] floatValue]];
                
                if ([balanceDict[@"maxBalance"] floatValue] != 0.00) {
                    if (_useMVC) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
                else {
                    ((UILabel *) [cell.contentView viewWithTag:1003]).text = @"Insufficient balance. Please tap on other payment option.";
                }
            }
            else if ([balanceDict[@"paymentMode"]  isEqualToString:@"PREPAID_CARD"]) {
                ((UILabel *) [cell.contentView viewWithTag:1001]).text = balanceDict[@"paymentMode"];
                ((UILabel *) [cell.contentView viewWithTag:1002]).text = [NSString stringWithFormat:@"Your Current Balance is Rs : %.02f", [balanceDict[@"maxBalance"] floatValue]];
                
                if ([balanceDict[@"maxBalance"] floatValue] != 0.00) {
                    if (_useCash) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
                else {
                    ((UILabel *) [cell.contentView viewWithTag:1003]).text = @"Insufficient balance. Please tap on other payment option.";
                }
            }
            
        }
        else if (indexPath.section == 1 ||
                 self.landingScreen == 0 ||
                 self.landingScreen == 2){
            static NSString *CellIdentifier = @"saveCardIdentifier";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell.contentView viewWithTag:1000].layer.cornerRadius = 5;
            
            NSDictionary *accountsDict = [_savedAccountsArray objectAtIndex:indexPath.row];
            if ([accountsDict[@"paymentMode"]  isEqualToString:@"NET_BANKING"]) {
                ((UILabel *) [cell.contentView viewWithTag:1001]).text = (![accountsDict[@"name"]  isEqual: [NSNull null]]) ? accountsDict[@"name"] : @"";
                ((UILabel *) [cell.contentView viewWithTag:1002]).text = (![accountsDict[@"bank"]  isEqual: [NSNull null]]) ? accountsDict[@"bank"] : @"";
                ;
                ((UILabel *) [cell.contentView viewWithTag:1003]).text = @"";
                ((UILabel *) [cell.contentView viewWithTag:1004]).text = @"";
            }
            else {
                ((UILabel *) [cell.contentView viewWithTag:1001]).text = (![accountsDict[@"name"]  isEqual: [NSNull null]]) ? accountsDict[@"name"] : @"";
                ;
                ((UILabel *) [cell.contentView viewWithTag:1002]).text = (![accountsDict[@"cardNumber"]  isEqual: [NSNull null]]) ? accountsDict[@"cardNumber"] : @"";
                ;
                ((UILabel *) [cell.contentView viewWithTag:1003]).text = (![accountsDict[@"bank"]  isEqual: [NSNull null]]) ? accountsDict[@"bank"] : @"";
                ;
                NSString *cardExpiryDate = (![accountsDict[@"cardExpiryDate"]  isEqual: [NSNull null]]) ? accountsDict[@"cardExpiryDate"] : @"";
                
                if (cardExpiryDate.length != 0) {
                    NSMutableString *string = [cardExpiryDate mutableCopy];
                    [string insertString:@"/" atIndex:2];
                    ((UILabel *) [cell.contentView viewWithTag:1004]).text = string;
                }
            }
            
            if ([accountsDict[@"selected"] boolValue] == YES &&
                oldIndexPath == indexPath) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([accountsDict[@"paymentMode"] isEqualToString:@"NET_BANKING"]) {
                    ((UIImageView *) [cell.contentView viewWithTag:1005]).image = [CTSUtility fetchBankLogoImageByBankName:(![accountsDict[@"bank"]  isEqual: [NSNull null]]) ? accountsDict[@"bank"] : @"" forParentView:self.view];
                }
                else {
                    ((UIImageView *) [cell.contentView viewWithTag:1005]).image = [CTSUtility fetchSchemeImageBySchemeType:(![accountsDict[@"cardScheme"]  isEqual: [NSNull null]]) ? accountsDict[@"cardScheme"] : @"" forParentView:self.view];
                }
            });
            
        }
    }
    
    
    return cell;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.saveCardsTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (indexPath.section == 0 &&
            self.landingScreen == 1) {
            NSMutableDictionary *balanceDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[_balancesArray objectAtIndex:indexPath.row];
            [balanceDict addEntriesFromDictionary:oldDict];
            
            if ([balanceDict[@"maxBalance"] floatValue] != 0.00) {
                if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
                    if ([balanceDict[@"paymentMode"] isEqualToString:@"MVC"]) {
                        _useMVC = NO;
                        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                        if ([_cashMaxBalance floatValue] < [transactionAmount floatValue]) {
                            _useCash = YES;
                            NSIndexPath * newIndexPath = [NSIndexPath  indexPathForRow:indexPath.row+1 inSection:indexPath.section];
                            [tableView cellForRowAtIndexPath:newIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                        }
                        ((UILabel *) [[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1003]).text = @"Check row to pay using MVC payment options";
                    }
                    
                    if ([balanceDict[@"paymentMode"] isEqualToString:@"PREPAID_CARD"]) {
                        _useCash = NO;
                        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                        ((UILabel *) [[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1003]).text = @"Check row to pay using Prepaid payment options";
                    }
                    
                    if (![balanceDict[@"paymentMode"] isEqualToString:@"PREPAID_CARD"] &&
                        ![balanceDict[@"paymentMode"] isEqualToString:@"MVC"]) {
                        selectedRow = NSNotFound;
                    }
                }
                else {
                    if ([balanceDict[@"paymentMode"] isEqualToString:@"MVC"]) {
                        _useMVC = YES;
                        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                        ((UILabel *) [[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1003]).text = @"Uncheck row to pay using other payment options";
                    }
                    
                    if ([balanceDict[@"paymentMode"] isEqualToString:@"PREPAID_CARD"]) {
                        _useCash = YES;
                        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                        ((UILabel *) [[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:1003]).text = @"Uncheck row to pay using other payment options";
                    }
                    
                    if (![balanceDict[@"paymentMode"] isEqualToString:@"PREPAID_CARD"] &&
                        ![balanceDict[@"paymentMode"] isEqualToString:@"MVC"]) {
                        selectedRow = indexPath.row;
                    }
                    
                    if ([balanceDict[@"paymentMode"] isEqualToString:@"PREPAID_CARD"] ||
                        [balanceDict[@"paymentMode"] isEqualToString:@"MVC"]) {
                        [self setPaymentInfoForSmartPay];
                        [self paymentSummary];
                    }
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *cvvAlert = [[UIAlertView alloc] initWithTitle:@"Balance Accounts details" message:@"Insufficient balance.\n Please tap on other payment option." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [cvvAlert show];
                });
            }
        }
        if (indexPath.section == 1 ||
            self.landingScreen == 0 ||
            self.landingScreen == 2) {
            
            NSMutableDictionary *accountsDict = [[NSMutableDictionary alloc] init];
            NSDictionary *oldDict = (NSDictionary *)[_savedAccountsArray objectAtIndex:indexPath.row];
            [accountsDict addEntriesFromDictionary:oldDict];
            
            if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
                selectedRow = NSNotFound;
                selectedIndexPath = nil;
                
                _useOther = NO;
                
                [accountsDict setObject:@"0" forKey:@"selected"];
                [_savedAccountsArray replaceObjectAtIndex:indexPath.row withObject:accountsDict];
                
                if (oldIndexPath != indexPath &&
                    oldDictionary != accountsDict) {
                    oldIndexPath = indexPath;
                    oldDictionary = accountsDict;
                }
            }
            else {
                [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                selectedRow = indexPath.row;
                selectedIndexPath = indexPath;
                
                if (oldIndexPath != nil &&
                    oldIndexPath != indexPath &&
                    oldDictionary != accountsDict) {
                    [tableView cellForRowAtIndexPath:oldIndexPath].accessoryType = UITableViewCellAccessoryNone;
                    [accountsDict setObject:@"0" forKey:@"selected"];
                    [_savedAccountsArray replaceObjectAtIndex:oldIndexPath.row withObject:oldDictionary];
                }
                
                
                if ([accountsDict[@"paymentMode"] isEqualToString:@"NET_BANKING"]) {
                    _useOther = YES;
                    
                    if (oldIndexPath != indexPath &&
                        oldDictionary != accountsDict) {
                        oldIndexPath = indexPath;
                        oldDictionary = accountsDict;
                    }
                    
                    [accountsDict setObject:@"1" forKey:@"selected"];
                    [_savedAccountsArray replaceObjectAtIndex:indexPath.row withObject:accountsDict];
                    
                    
                    [self setPaymentInfoForSmartPay];
                    [self paymentSummary];
                    selectedPaymentoption = accountsDict[@"bank"];
                }
                else {
                    
                    JSONModelError* jsonError;
                    CTSConsumerProfileDetails* consumerProfileDetails = [[CTSConsumerProfileDetails alloc]
                                                                         initWithDictionary:[_savedAccountsArray objectAtIndex:indexPath.row]
                                                                         error:&jsonError];
                    
                    if ([accountsDict[@"paymentMode"] isEqualToString:@"DEBIT_CARD"]) {
                        _paymentOptions = [CTSPaymentOptions debitCardTokenized:consumerProfileDetails];
                    }
                    else if ([accountsDict[@"paymentMode"] isEqualToString:@"CREDIT_CARD"]) {
                        _paymentOptions = [CTSPaymentOptions creditCardTokenized:consumerProfileDetails];
                    }
                    
                    if ([_paymentOptions canDoOneTapPayment]) {
                        //do not prompt user for CVV
                        LogTrace(@"found Stored OneTap Paymentinfo, will do the OneTapPayment");
                        
                        _paymentOptions.cvv = nil;
                        cvvText = nil;
                        
                        _useOther = YES;
                        
                        
                        if (oldIndexPath != selectedIndexPath &&
                            oldDictionary != accountsDict) {
                            oldIndexPath = selectedIndexPath;
                            oldDictionary = accountsDict;
                        }
                        
                        [accountsDict setObject:@"1" forKey:@"selected"];
                        [_savedAccountsArray replaceObjectAtIndex:indexPath.row withObject:accountsDict];
                        
                        [self setPaymentInfoForSmartPay];
                        [self paymentSummary];
                        
                    }
                    else {
                        //get cvv from user
                        LogTrace(@"no oneTapPaymentInfo found for the token");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView *cvvAlert = [[UIAlertView alloc] initWithTitle:@""
                                                                               message:@"Please enter cvv."
                                                                              delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
                            cvvAlert.tag = 100;
                            cvvAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                            UITextField *textField = [cvvAlert textFieldAtIndex:0];
                            textField.keyboardType = UIKeyboardTypeNumberPad;
                            textField.placeholder = @"cvv";
                            [cvvAlert show];
                        });
                    }
                    
                }
                
            }
        }
    }
}

#pragma mark - AlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView dismissWithClickedButtonIndex:buttonIndex
                                    animated:NO];
    [self.view endEditing:YES];
    
    if (alertView.tag==100){
        NSMutableDictionary *accountsDict = [[NSMutableDictionary alloc] init];
        
        if (buttonIndex==1) {
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            [alertTextField resignFirstResponder];
            
            NSDictionary *oldDict = (NSDictionary *)[_savedAccountsArray objectAtIndex:selectedIndexPath.row];
            [accountsDict addEntriesFromDictionary:oldDict];
            
            cvvText = alertTextField.text;
            
            _useOther = YES;
            
            if (oldIndexPath != selectedIndexPath &&
                oldDictionary != accountsDict) {
                oldIndexPath = selectedIndexPath;
                oldDictionary = accountsDict;
            }
            
            [accountsDict setObject:@"1" forKey:@"selected"];
            [_savedAccountsArray replaceObjectAtIndex:selectedIndexPath.row withObject:accountsDict];
            
            [self setPaymentInfoForSmartPay];
            [self paymentSummary];
        }
        else {
            
            NSDictionary *oldDict = (NSDictionary *)[_savedAccountsArray objectAtIndex:oldIndexPath.row];
            [accountsDict addEntriesFromDictionary:oldDict];
            
            _useOther = NO;
            
            if (oldIndexPath != selectedIndexPath &&
                oldDictionary != accountsDict) {
                oldIndexPath = selectedIndexPath;
                oldDictionary = accountsDict;
            }
            
            [self.saveCardsTableView cellForRowAtIndexPath:oldIndexPath].accessoryType = UITableViewCellAccessoryNone;
            [accountsDict setObject:@"0" forKey:@"selected"];
            [_savedAccountsArray replaceObjectAtIndex:oldIndexPath.row withObject:accountsDict];
        }
    }
    else if (alertView.tag == 2000){
        if (buttonIndex==1) {
            [self loadOrPayDPMoney];
        }
    }
    else if (alertView.tag == 102){
        if (buttonIndex==0) {
            if (!isAnySubscriptionActive) {
                sleep(.3);
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self subscribeCard];
                });
            }
        }

    }
    else if (alertView.tag==103){
        
        if (buttonIndex==1) {
            
            [self suscribeAfterLoadWithThresholdAmount:[alertView textFieldAtIndex:0].text andWithLoadAmount:[alertView textFieldAtIndex:0].text];
            
        }
    }
    
}

-(IBAction)suscribeAfterLoadWithThresholdAmount:(NSString *)thresholdAmount andWithLoadAmount:(NSString *)loadAmount{
    CTSPaymentLayer *paymentlayer = [CitrusPaymentSDK fetchSharedPaymentLayer];
    CTSAutoLoad *autoload = [[CTSAutoLoad alloc]init];
    
    autoload.autoLoadAmt = loadAmount;
    autoload.thresholdAmount = thresholdAmount;
    
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
    [paymentlayer requestSubscribeAutoAfterLoad:autoload withCompletionHandler:^(CTSAutoLoadSubResp *autoloadResponse, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
        });
        
        if(error){
            [UIUtility toastMessageOnScreen:[error localizedDescription]];
        }
        else{
            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"autoloadSubscriptions %@",autoloadResponse]];
        }
    }];
}

- (void) subscribeCard{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertView *sendMoneyAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Do you want to subscribe this card?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
        sendMoneyAlert.tag = 103;
        sendMoneyAlert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField * alertTextField1 = [sendMoneyAlert textFieldAtIndex:0];
        alertTextField1.keyboardType = UIKeyboardTypeDecimalPad;
        alertTextField1.placeholder = @"Enter Threshold Amount.";
        
        UITextField * alertTextField2 = [sendMoneyAlert textFieldAtIndex:1];
        alertTextField2.keyboardType = UIKeyboardTypeDecimalPad;
        alertTextField2.placeholder = @"Enter Autoload Amount.";
        [alertTextField2  setSecureTextEntry:FALSE];
        
        [sendMoneyAlert show];
    });
    
}

#pragma mark - StoryBoard Delegate Methods
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"AutoloadViewIdentifier"]) {
        AutoloadViewController *viewController = (AutoloadViewController *)segue.destinationViewController;
        viewController.cardInfo = _paymentOptions;
        
    }
    
}


#pragma mark - PickerView Delegate Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    return [array count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    currentTextField.text = [array objectAtIndex:row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    return [array objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UIView *tempView = view;
    
    UILabel *pickerLabel;
    UIImageView *imageView;
    if (!tempView)
    {
        tempView =[[UIView alloc]init];
        imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(10, 5, 40, 40);
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, -5, self.view.bounds.size.width, 50)];
        pickerLabel.textColor = [UIColor darkGrayColor];
        pickerLabel.font = [UIFont fontWithName:@"Verdana-Semibold" size:15];
        pickerLabel.textAlignment = NSTextAlignmentLeft;
        pickerLabel.backgroundColor = [UIColor clearColor];
        

        [tempView addSubview:imageView];
        [tempView addSubview:pickerLabel];
    }
    
    imageView.image = [CTSUtility fetchBankLogoImageByBankIssuerCode:[[netBankingDict allValues] objectAtIndex:row] forParentView:self.view];
    [pickerLabel setText:[array objectAtIndex:row]];
    
    return tempView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component __TVOS_PROHIBITED;
{
    return 50;
}
#pragma mark - Reset UI Methods

- (void) resetUI {
    self.cardNumberTextField.text = @"";
    self.ownerNameTextField.text = @"";
    self.expiryDateTextField.text = @"";
    self.cvvTextField.text = @"";
    self.netBankCodeTextField.text = @"";
    self.schemeTypeImageView.image = nil;
    [switchView setOn:NO animated:YES];
}

#pragma mark - Dealloc Methods

- (void) dealloc {
    self.cardNumberTextField = nil;
    self.ownerNameTextField = nil;
    self.expiryDateTextField = nil;
    self.cvvTextField = nil;
    self.netBankCodeTextField = nil;
    self.loadButton = nil;
    self.aPickerView = nil;
    self.indicatorView = nil;
    self.schemeTypeImageView = nil;
}


/*
- (void)smartPay {
    
    CTSPaymentOptions *debitCardPayment = [CTSPaymentOptions debitCardOption:@"4111111111111111"
                                                              cardExpiryDate:@"01/18"
                                                                         cvv:@"000"];
    [paymentLayer requestSimpliPay:@"10.00"
                           billURL:BillUrl
                     paymentOption:debitCardPayment
                            useMVC:YES
                           useCash:YES
                   useDynamicPrice:NO
                          ruleInfo:nil
           andParentViewController:self
                 completionHandler:^(CTSPaymentReceipt *paymentReceipt,
                                     NSError *error) {
                     if (error) {
                         NSLog(@"error %@", [error localizedDescription]);
                     }
                     else {
                         NSLog(@"response %@", paymentReceipt.toDictionary);
                     }
                 }];
}



- (void)loadmoney {
    CTSPaymentOptions *debitCardPayment = [CTSPaymentOptions debitCardOption:@"4111111111111111"
                                                              cardExpiryDate:@"01/18"
                                                                         cvv:@"000"];
    [paymentLayer requestLoadMoney:@"10.00"
                         returnURL:LoadWalletReturnUrl
                     paymentOption:debitCardPayment
           andParentViewController:self
                 completionHandler:^(CTSPaymentReceipt *paymentReceipt,
                                     NSError *error) {
                     if (error) {
                         NSLog(@"error %@", [error localizedDescription]);
                     }
                     else {
                         NSLog(@"response %@", paymentReceipt.toDictionary);
                     }
                 }];
    
}

- (void)CalculateSplitPay {
    
    [paymentLayer calculatePaymentDistribution:@"10.0"
                             completionHandler:^(CTSSimpliChargeDistribution *amountDistribution,
                                                 NSError *error) {
                                 if (error) {
                                     NSLog(@"error %@", [error localizedDescription]);
                                 }
                                 else {
                                     CTSPaymentOptions *debitCardPayment = nil;
                                     if (!amountDistribution.enoughMVCAndCash) {
                                         debitCardPayment = [CTSPaymentOptions
                                                             debitCardOption:@"4111111111111111"
                                                             cardExpiryDate:@"01/18"
                                                             cvv:@"000"];
                                     }
                                     
                                     [paymentLayer requestSimpliPay:amountDistribution.totalAmount
                                                            billURL:BillUrl
                                                      paymentOption:debitCardPayment
                                                             useMVC:amountDistribution.useMVC
                                                            useCash:amountDistribution.useCash
                                                    useDynamicPrice:NO
                                                           ruleInfo:nil
                                            andParentViewController:self
                                                  completionHandler:^(CTSPaymentReceipt *paymentReceipt,
                                                                      NSError *error) {
                                                      if (error) {
                                                          NSLog(@"error %@", [error localizedDescription]);
                                                      }
                                                      else {
                                                          NSLog(@"response %@", paymentReceipt.toDictionary);
                                                      }
                                                      
                                                  }];
                                 }
                             }];
    
}
*/
@end