//
//  ShowPhotsViewController.h
//  Album
//
//  Created by Kotaro Suto on 2015/06/13.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ShowPhotosViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSDictionary *photosDic;
    CGRect selfViewRect;
    UIImage *srcImage;
    double cellSize;
    int sectionCount;
    int objectsWidth;
    
    NSMutableArray *setedImagesArray;
    NSMutableArray *imagesArray;
    NSMutableDictionary *imagesDictionary;
    
    UICollectionViewFlowLayout *flowLayout;
    
    }
@property(nonatomic)NSDictionary *photosDic;
@property IBOutlet UICollectionView *collectionView;

//@property (nonatomic, strong) NSMutableArray * sourceArray;
//@property (nonatomic, strong) NSMutableArray * sourceArray_bis;


@end
