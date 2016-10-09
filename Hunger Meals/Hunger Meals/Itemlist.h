//
//  Itemlist.h
//  Hunger Meals
//
//  Created by Vamsi on 08/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSonModel.h"

@interface Itemlist : JSONModel{
    NSString *category;
    NSString *created_at;
    NSString *desc;
    NSString *img;
    NSString *id;
    NSString *title;
    NSString *type;
    NSString *updated_at;

}

@property (nonatomic, strong) NSString<Optional> *category;
@property (nonatomic, retain) NSString<Optional> *created_at;
@property (nonatomic, retain) NSString<Optional> *desc;
@property (nonatomic, retain) NSString<Optional> *id;
@property (nonatomic, retain) NSString<Optional> *img;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, retain) NSString<Optional> *type;
@property (nonatomic, retain) NSString<Optional> *updated_at;



@end
