//
//  ViewController.m
//  Album
//
//  Created by Kotaro Suto on 2015/05/04.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import "ViewController.h"
#import "PhotoData.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    textView.editable = NO;
    pointsDictionary = [NSMutableDictionary dictionary];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)start:(id)sender{
    QBImagePickerController *imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    photoData = [[PhotoData alloc] init];
    smArray = [[NSMutableArray alloc]init];
    boArray = [[NSMutableArray alloc]init];
    resultsArray = [[NSMutableArray alloc]init];
    
    
    NSLog(@"ASSETS COUNT %ld", assets.count);
    for (asset in assets) {
        // Do something with the asset
        
        NSLog(@"%@", asset);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(300,300)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    NSString *localIdentifier = [NSString new];
            if (result) {
                //result = [UIImage imageNamed:@"face.jpg"];
                int pt = 0;
                imview.image = result;
                photoData.image = result;
                CIImage *image = [CIImage imageWithCGImage:result.CGImage];
                CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                          context:nil
                                                          options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
                                                                
                NSDictionary *options = @{CIDetectorSmile: @(YES),
                                          CIDetectorEyeBlink: @(YES),
                                        };
#warning features 0 after ditect features
                NSArray *features = [detector featuresInImage:image options:options];
                
                NSLog(@"FEATURES COUNT %ld", features.count);
                if (asset) {
                for(CIFaceFeature *feature in features){
                      pt = pt + 1;
                    if (feature.hasSmile == YES) {
                        pt = pt + 2;
                    }
                    //textView.text = [NSString stringWithFormat:@"image == %@ \n smile == %@ \n bounds == %@", imArray, smArray, boArray];
                }
                NSNumber *pointNum = [NSNumber numberWithInt:pt];
                localIdentifier = asset.localIdentifier;
                NSLog(@"localIdentifier=%@ \n pointNum=%@",localIdentifier,pointNum);
                [pointsDictionary setObject:pointNum forKey:localIdentifier];
                NSLog(@"pointsDictionary===%@",pointsDictionary);
                NSLog(@"localIdentifier===%@",localIdentifier);
                NSLog(@"pointNum===%@",pointNum);
                }
            }
                                                    
        }];
}
    //textView.text = [NSString stringWithFormat:@"%@",ResultsArray];
 /* NSLog(@"%@",resultsArray);
    NSMutableArray *imageArray = [NSMutableArray new];
    NSMutableArray *smileArray = [NSMutableArray new];
    NSMutableArray *boundsArray = [NSMutableArray new];
    
    for (PhotoData *p in resultsArray) {
        [imageArray addObject:p.image];
        [smileArray addObject:p.smileArray];
        [boundsArray addObject:p.boundsArray];
    }*/
    
    //imview.image = imageArray[0];
    //NSLog(@"%@",smileArray);
    
//    textView.text = [NSString stringWithFormat:@"image == %@ \n smile == %@ \n bounds == %@", imageArray, smileArray, boundsArray];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
