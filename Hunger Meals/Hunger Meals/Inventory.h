//
//  Inventory.h
//  Hunger Meals
//
//  Created by Vamsi on 24/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"

@interface Inventory : JSONModel
{
    NSString *id;
    NSString *product_id;
    NSString *kitchen_id;
    NSString *price;
    NSString *stock;
    NSString *date;
    NSString *created_at;
    NSString *updated_at;
    NSString *is_lunch;
    NSString *is_dinnerr;
}

@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, retain) NSString<Optional> *product_id;
@property (nonatomic, retain) NSString<Optional> *kitchen_id;
@property (nonatomic, retain) NSString<Optional> *price;
@property (nonatomic, retain) NSString<Optional> *stock;
@property (nonatomic, retain) NSString<Optional> *date;
@property (nonatomic, retain) NSString<Optional> *created_at;
@property (nonatomic, retain) NSString<Optional> *updated_at;
@property (nonatomic, retain) NSString<Optional> *is_lunch;
@property (nonatomic, retain) NSString<Optional> *is_dinnerr;

-(void)genrateinverntoryObject:(NSDictionary *)invObj;

@end
