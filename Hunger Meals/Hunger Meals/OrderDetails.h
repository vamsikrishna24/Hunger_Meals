//
//  OrderDetails.h
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 23/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"
#import "CartItem.h"

@interface OrderDetails : JSONModel
{
    NSString *address;
    NSArray<CartItem *> *cartItems;
    NSString *deliveryboy_id;
    NSString *deliveryboyname;
    NSString *id;
    NSString *kitchen_id;
    NSString *order_status;
    NSString *payment_type;
    NSString *phone;
    NSString *totalprice;
    NSString *user_name;
    NSDictionary *created_at;
}

@property (nonatomic, strong) NSString<Optional> *address;
@property (nonatomic, retain) NSArray<CartItem *> *cartItems;
@property (nonatomic, retain) NSString<Optional> *deliveryboy_id;
@property (nonatomic, retain) NSString<Optional> *deliveryboyname;
@property (nonatomic, retain) NSString<Optional> *id;
@property (nonatomic, retain) NSString<Optional> *kitchen_id;
@property (nonatomic, retain) NSString<Optional> *order_status;
@property (nonatomic, retain) NSString<Optional> *payment_type;
@property (nonatomic, retain) NSString<Optional> *phone;
@property (nonatomic, retain) NSString<Optional> *totalprice;
@property (nonatomic, retain) NSString<Optional> *user_name;
@property (nonatomic, retain) NSDictionary<Optional> *created_at;

@end
