//
//  CartItem.h
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 26/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"
#import "Product.h"

@interface CartItem : JSONModel
{
    NSString *id;
    NSString *user_id;
    NSString *inventories_id;
    Product *product;
    NSString *price;
    NSString *name;
    NSString *quantity;
    NSDictionary *created_at;
    NSDictionary *updated_at;
}

@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, retain) NSString<Optional> *user_id;
@property (nonatomic, retain) NSString<Optional> *inventories_id;
@property (nonatomic, retain) Product *product;
@property (nonatomic, retain) NSString<Optional> *price;
@property (nonatomic, retain) NSString<Optional> *quantity;
@property (nonatomic, retain) NSString<Optional> *name;
@property (nonatomic, retain) NSDictionary<Optional> *created_at;
@property (nonatomic, retain) NSDictionary<Optional> *updated_at;


@end
