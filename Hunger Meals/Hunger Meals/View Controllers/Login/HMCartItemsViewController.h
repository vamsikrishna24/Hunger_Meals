//
//  HMCartItemsViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 26/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMCartItemsViewController : UIViewController
@property (strong,nonatomic)IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *dishImagesArray;

@end
