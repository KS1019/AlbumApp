//
//  ShowPhotsViewController.h
//  Album
//
//  Created by Kotaro Suto on 2015/06/13.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ShowPhotosViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>{
    NSDictionary *photosDic;
    CGRect rect1;
    UIImageView *imageView;
    UIImage *srcImage;
    

    NSMutableArray *imagesArray;
    
    }
@property(nonatomic)NSDictionary *photosDic;
@property IBOutlet UICollectionView *collectionView;

//@property (nonatomic, strong) NSMutableArray * sourceArray;
//@property (nonatomic, strong) NSMutableArray * sourceArray_bis;


@end
