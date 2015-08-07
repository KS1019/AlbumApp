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
    //imageView.frame = CGRectMake(100, 100, 100 ,100);
    NSLog(@"photosDic--->%@",photosDic);
    [self sortDictionary];
    
    imagesDictionary = [NSMutableDictionary new];
    imagesArray = [NSMutableArray new];
    
    rect1 = [[UIScreen mainScreen] bounds];
    NSLog(@"rect1.size.width : %f , rect1.size.height : %f", rect1.size.width, rect1.size.height);
    
    int photoCount = [photosDic count];
    //最小のセルの大きさを計算
    cellSize = rect1.size.height * rect1.size.width / photoCount;
    cellSize = sqrt(cellSize);
    NSLog(@"\nSmallest Cell Size : %f",cellSize);
    
    
    [self makeSquareImages];
    
    // データの要求を受け取る先を自分自身に設定する
    self.collectionView.dataSource = self;
    // イベントの受け取り先を自分自身に設定する
    self.collectionView.delegate = self;
    
    
    //FlowLayout作成
    flowLayout = [UICollectionViewFlowLayout new];
    //セクションとアイテムの間隔
    flowLayout.minimumLineSpacing = 3.0;
    //アイテム同士の間隔
    flowLayout.minimumInteritemSpacing = 3.0;
    //コレクションビューへの適用
    self.collectionView = flowLayout;
    
    
    
//    // UICollectionViewにカスタムセルを追加する
//    UINib *nibFirst = [UINib nibWithNibName:@"FirstSectionCell" bundle:nil];
//    [collectionView registerNib:nibFirst forCellWithReuseIdentifier:@"FirstSectionCell"];
//    
//    UINib *nibSecond = [UINib nibWithNibName:@"SecondSectionCell" bundle:nil];
//    [collectionView registerNib:nibSecond forCellWithReuseIdentifier:@"SecondSectionCell"];

    //[collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];

//    [UICollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
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
        NSLog(@"\nimageW : %d\nimageH : %d",imageW,imageH);
        
        int point = [photosDic valueForKey:identifier];
        NSLog(@"point---->>>%d",point);
        
        int posX = imageW / 2;
        int posY = imageH / 2;
        int trimsize = 0;
        
        
        
        if (point <= 20) {
            trimsize = 20;
            NSLog(@"\nThis picture : %@ \nPoint : %d\nTrimSize : %d",identifier,point,trimsize);
        }else{
            trimsize = 40;
            NSLog(@"\nThis picture : %@ \nPoint : %d\nTrimSize : %d",identifier,point,trimsize);
        }
        /*
        if (point == 0) {
            trimsize = 100;
            NSLog(@"\nThis picture : %@ \nPoint : %d\nTrimSize : %d",identifier,point,trimsize);
        }else if(0 < point && point < 10){
            trimsize = 200;
            NSLog(@"\nThis picture : %@ \nPoint : %d\nTrimSize : %d",identifier,point,trimsize);
        }else if(10 < point && point < 20){
            trimsize = 300;
            NSLog(@"\nThis picture : %@ \nPoint : %d\nTrimSize : %d",identifier,point,trimsize);
        }else if(20 < point){
            trimsize = 400;
            NSLog(@"\nThis picture : %@ \nPoint : %d\nTrimSize : %d",identifier,point,trimsize);
        }
        */
        
    
        // 切り抜く位置を指定するCGRectを作成する。
        // なお簡略化のため、imageW,imageHともに320以上と仮定する。
        
        CGRect trimArea = CGRectMake(posX, posY, trimsize, trimsize);
        
        // CoreGraphicsの機能を用いて、
        // 切り抜いた画像を作成する。
        CGImageRef srcImageRef = [srcImage CGImage];
        CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(srcImageRef, trimArea);
        UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef];
        
        [imagesDictionary setObject:trimmedImage forKey:srcImage];
        [imagesArray addObject:trimmedImage];
        NSLog(@"\ntrimmedImage : %@",NSStringFromCGSize(trimmedImage.size));
    }
    NSLog(@"imageDictionary : %@",imagesDictionary);
    
}

#pragma mark -UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return imagesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"iefjnfnrinerinfifr");
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
//    NSString *imgName = [NSString stringWithFormat:@"photo%d.JPG", (int)(indexPath.row+1)];
//    UIImage *image = [UIImage imageNamed:imgName];
    UIImage *image = [imagesArray objectAtIndex:indexPath.row];
    imageView.image = image;
    
    //仮
    cellSize = 40;
    
    CGSize listCellSize;
    float height = image.size.height;
    if (height == 20){
                //最小のセルのサイズ
                // １セルあたりのサイズを計算
                listCellSize = CGSizeMake(cellSize,cellSize);
    }else if(height == 40){
                //違ったら普通のサイズ
                // １セルあたりのサイズを計算
                listCellSize = CGSizeMake(cellSize * 2,cellSize * 2);
    }
    
        CGRect red = cell.frame;
        red.size = listCellSize;
        cell.frame = red;
        NSLog(@"\ncell : %@",cell);

//    UIImage *image2 = [imagesArray objectAtIndex:indexPath.row];
//    CGSize listCellSize;
//    float height = image2.size.height;
//    if (height == 200){
//        //最小のセルのサイズ
//        // １セルあたりのサイズを計算
//        listCellSize = CGSizeMake(cellSize,cellSize);
//    }else if(height == 400){
//        //違ったら普通のサイズ
//        // １セルあたりのサイズを計算
//        listCellSize = CGSizeMake(cellSize * 2,cellSize * 2);
//    }
//
//    CGRect red = cell.frame;
//    red.size = listCellSize;
//    cell.frame = red;
//    NSLog(@"\ncell : %@",cell);
//    
    return cell;
}


//セルのサイズをプログラムで変更できる
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"called");
    UIImage *image = [imagesArray objectAtIndex:indexPath.row];
    CGSize listCellSize;
    float height = image.size.height;
    if (height == 200){
        //最小のセルのサイズ
        // １セルあたりのサイズを計算
        listCellSize = CGSizeMake(cellSize,cellSize);
    }else if(height == 400){
        //違ったら普通のサイズ
        // １セルあたりのサイズを計算
        listCellSize = CGSizeMake(cellSize * 2,cellSize * 2);
    }
    return listCellSize;
    
    
    
    /*
     // １セルあたりのサイズを計算
     CGRect screenSize = [[UIScreen mainScreen] bounds];
     NSUInteger space = 10;
     NSUInteger bar = 64;
     CGSize listCellSize = CGSizeMake(100,
     100);
     return listCellSize;
     */
//}



- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];

    return attributes;
}

@end
