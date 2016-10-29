//
//  Product.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 8/29/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"

@interface Product : JSONModel
{
    NSString *id;
    NSString *name;
    NSString *description;
    NSString *price;
    NSString *type;
    NSString *category;
    NSString *label;
    NSNumber *is_lunch;
    NSNumber *is_dinner;
    NSNumber *user_id;
    NSString *image_url;
    NSString *created_at;
    NSString *updated_at;
    NSMutableArray *inventories;
    NSNumber *quantity;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, strong) NSString<Optional> *description;
@property (nonatomic, strong) NSString<Optional> *price;
@property (nonatomic, retain) NSString<Optional> *type;
@property (nonatomic, retain) NSString<Optional> *category;
@property (nonatomic, retain) NSString<Optional> *label;
@property (nonatomic, retain) NSNumber<Optional> *is_lunch;
@property (nonatomic, retain) NSNumber<Optional> *is_dinner;
@property (nonatomic, retain) NSNumber<Optional> *user_id;
@property (nonatomic, retain) NSString<Optional> *image_url;
@property (nonatomic, retain) NSString<Optional> *created_at;
@property (nonatomic, retain) NSString<Optional> *updated_at;
@property (nonatomic, retain) NSNumber<Optional> *quantity;
@property (nonatomic, retain) NSMutableArray<Optional> *inventories;






@end
