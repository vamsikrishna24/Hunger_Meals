//
//  Coupon.h
//  Hunger Meals
//
//  Created by Vamsi on 28/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"

@interface Coupon : JSONModel{
    NSString *code;
    NSString *amount;
    NSString *type;
    NSString *category;
    NSString *starstAt;
    NSString *endsAt;
}

@property (nonatomic, strong) NSString<Optional> *code;
@property (nonatomic, retain) NSString<Optional> *amount;
@property (nonatomic, retain) NSString<Optional> *type;
@property (nonatomic, retain) NSString<Optional> *category;
@property (nonatomic, retain) NSString<Optional> *starstAt;
@property (nonatomic, retain) NSString<Optional> *endsAt;
@end
