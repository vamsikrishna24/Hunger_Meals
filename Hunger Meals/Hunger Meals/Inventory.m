//
//  Inventory.m
//  Hunger Meals
//
//  Created by Vamsi on 24/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "Inventory.h"

@implementation Inventory
@synthesize id,product_id,kitchen_id,price,stock,date,created_at,updated_at,is_lunch,is_dinnerr;

-(void)genrateinverntoryObject:(NSDictionary *)invObj
{
    self.id =  [invObj valueForKey:@"id"];
}

@end
