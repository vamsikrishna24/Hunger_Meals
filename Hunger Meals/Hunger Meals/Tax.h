//
//  Tax.h
//  Hunger Meals
//
//  Created by Vamsi on 05/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"

@interface Tax : JSONModel{
    NSString *CESS;
    NSString *VAT;
    NSString *created_at;
    NSString *delivery_charge;
    NSString *id;
    NSString *kitchen_id;
    NSString *packing_charge;
    NSString *service_charge;
    NSString *service_tax;
    NSString *surge;
    NSString *updated_at;
}


@property (nonatomic, strong) NSString<Optional> *CESS;
@property (nonatomic, retain) NSString<Optional> *VAT;
@property (nonatomic, retain) NSString<Optional> *created_at;
@property (nonatomic, retain) NSString<Optional> *delivery_charge;
@property (nonatomic, retain) NSString<Optional> *id;
@property (nonatomic, retain) NSString<Optional> *kitchen_id;
@property (nonatomic, strong) NSString<Optional> *packing_charge;
@property (nonatomic, retain) NSString<Optional> *service_charge;
@property (nonatomic, retain) NSString<Optional> *service_tax;
@property (nonatomic, retain) NSString<Optional> *surge;
@property (nonatomic, retain) NSString<Optional> *updated_at;


@end
