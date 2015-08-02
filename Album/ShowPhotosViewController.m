//
//  ShowPhotsViewController.m
//  Album
//
//  Created by Kotaro Suto on 2015/06/13.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import "ShowPhotosViewController.h"
#import "FirstSectionCell.h"
#import "SecondSectionCell.h"

@interface ShowPhotosViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    NSString *selectedName;
}

@end

@implementation ShowPhotosViewController

@synthesize photosDic;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageView = [UIImageView new];
    //imageView.frame = CGRectMake(100, 100, 100 ,100);
    NSLog(@"photosDic--->%@",photosDic);
    [self sortDictionary];
    
    imagesArray = [NSMutableArray new];
    imagesArray = [NSMutableArray array];
    
    rect1 = [[UIScreen mainScreen] bounds];
    NSLog(@"rect1.size.width : %f , rect1.size.height : %f", rect1.size.width, rect1.size.height);
    
    [self makeSquareImages];
    
    // データの要求を受け取る先を自分自身に設定する
    collectionView.dataSource = self;
    // イベントの受け取り先を自分自身に設定する
    collectionView.delegate = self;
    

    
//    // UICollectionViewにカスタムセルを追加する
//    UINib *nibFirst = [UINib nibWithNibName:@"FirstSectionCell" bundle:nil];
//    [collectionView registerNib:nibFirst forCellWithReuseIdentifier:@"FirstSectionCell"];
//    
//    UINib *nibSecond = [UINib nibWithNibName:@"SecondSectionCell" bundle:nil];
//    [collectionView registerNib:nibSecond forCellWithReuseIdentifier:@"SecondSectionCell"];

    //[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)sortDictionary{
    NSArray *ar = [photosDic allValues];
    NSArray *AR = [photosDic allKeys];
    NSLog(@"allValues->%@ allKeys->%@",ar,AR);
    
}

-(void)makeSquareImages{
    NSArray *allids = [photosDic allKeys];
    srcImage = [UIImage new];

    for (NSString *identifier in allids) {

    PHFetchResult *assets = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil];
    [assets enumerateObjectsUsingBlock:^(PHAsset *asseeet, NSUInteger idx, BOOL *stop) {
        NSLog(@"asset:%@", asseeet);
        [[PHImageManager defaultManager] requestImageForAsset:asseeet
                                                   targetSize:CGSizeMake(300,300)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (result) {
                                                        // imageVivew を更新します
                                                        //imageView.image = result;
                                                        //[self.view addSubview:imageView];
                                                        srcImage = result;
                                                    }}];
    }];
    NSLog(@"FetchResult-->%@ identifier-->%@",assets,identifier);
        
        // 切り抜き元となる画像を用意する。
        int imageW = srcImage.size.width;
        int imageH = srcImage.size.height;
        
        int point = [photosDic valueForKey:identifier];
        NSLog(@"point---->>>%d",point);
        
        int posX = imageW / 2;
        int posY = imageH / 2;
        int trimsize = 0;
        
        if (point == 0) {
            trimsize = 100;
        }else if(0 < point && point < 10){
            trimsize = 200;
        }else if(10 < point && point < 20){
            trimsize = 300;
        }else if(20 < point){
            trimsize = 400;
        }
        
        
    
        // 切り抜く位置を指定するCGRectを作成する。
        // なお簡略化のため、imageW,imageHともに320以上と仮定する。
        
        CGRect trimArea = CGRectMake(posX, posY, trimsize, trimsize);
        
        // CoreGraphicsの機能を用いて、
        // 切り抜いた画像を作成する。
        CGImageRef srcImageRef = [srcImage CGImage];
        CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, trimArea);
        UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef];
        
//        imageView.image = trimmedImage;
//        imageView.frame = CGRectMake(point, point, 100, 100);
//        [self.view addSubview:imageView];
        
        [imagesArray addObject:trimmedImage];
    }
}

#pragma mark -UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  /*  if (section == 0) {
        return 2;
    }
    else{
        return 4;
    }
   */
    return imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   /*
    if (indexPath.section == 0) {
        // １つめのセクションは、背景色を赤にする
        cell.backgroundColor = [UIColor redColor];
    }
    else{
        // ２つ目のセクションは背景色を緑にする
        cell.backgroundColor = [UIColor greenColor];
    }
    */
   // UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UIImage *image = [imagesArray objectAtIndex:indexPath.row];
    imageView.image = image;

    return cell;
}

@end
