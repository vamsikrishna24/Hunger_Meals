//
//  HMCartItemsViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMCartItemsViewController.h"
#import "SVService.h"

@interface HMCartItemsViewController ()


@end

static NSString * const cellIdentifier = @"CartItemCellIdentifier";

@implementation HMCartItemsViewController{
   //
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}


//checkoutItemsView
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



//************************************************
#pragma mark - UICollectionView Datasource
//************************************************

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return 4;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:222];
    NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
    imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark – UICollectionViewDelegateFlowLayout
//- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGRect collectionViewSize = collectionView.bounds;
//    
//    //CGFloat cellWidth = (collectionViewSize.size.width-(3*CELLSPACING))/2;
//    //    CGFloat cellHeight = (collectionViewSize.size.height-(3*CELLSPACING)-STATUSNAVIGATIONHEIGHT)/3;
//    //CGFloat cellHeight = 220;
//    //CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
//    
//    return cellSize;
//    
//}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionFooter) {
        HMCartCollectionReusableView *CartFooterView  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
 
        
        reusableview = CartFooterView;
    }
    
    
    return reusableview;
}



- (UIEdgeInsets) collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
@end
