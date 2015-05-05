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
       resultsArray = [[NSMutableArray alloc]init];
    for (asset in assets) {
        // Do something with the asset
        
        NSLog(@"%@", asset);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(300,300)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                imview.image = result;
                PhotoData *photoData = [[PhotoData alloc] init];
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
                
                for(CIFaceFeature *feature in features){
                    
                    [photoData.features addObject:feature];
                    [photoData.boundsArray addObject:NSStringFromCGRect(feature.bounds)];
                    [photoData.smileArray addObject:[NSNumber numberWithBool:feature.hasSmile]];
                    
                    /*
                    [resultStr appendFormat:@"bounds:%@\n", NSStringFromCGRect(feature.bounds)];
                    [resultStr appendFormat:@"hasSmile: %@\n\n", feature.hasSmile ? @"YES" : @"NO"];
                    NSLog(@"%d", feature.hasSmile);
                        if (feature.hasSmile == NO) {
                            NSLog(@"miss");
                        }else if(feature.hasSmile == YES) {
                            NSLog(@"hit");
                        }
                     */
                }
                
                [resultsArray addObject:photoData];
                
                NSLog(@"<<<<<<< %@ >>>>>>>>>",resultsArray);

            }
                                                    
        }];

    }
    //textView.text = [NSString stringWithFormat:@"%@",ResultsArray];
    NSLog(@"%@",resultsArray);
    NSMutableArray *imageArray = [NSMutableArray new];
    NSMutableArray *smileArray = [NSMutableArray new];
    NSMutableArray *boundsArray = [NSMutableArray new];
    
    for (PhotoData *p in resultsArray) {
        [imageArray addObject:p.image];
        [smileArray addObject:p.smileArray];
        [boundsArray addObject:p.boundsArray];
    }
    
    imview.image = imageArray[0];
    
    textView.text = [NSString stringWithFormat:@"image == %@ \n smile == %@ \n bounds == %@", imageArray, smileArray, boundsArray];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
