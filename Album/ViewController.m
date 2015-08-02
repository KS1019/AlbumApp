//
//  ViewController.m
//  Album
//
//  Created by Kotaro Suto on 2015/05/04.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import "ViewController.h"
#import "PhotoData.h"

@interface ViewController ()<QBImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    textView.editable = NO;
    pointsDictionary = [NSMutableDictionary dictionary];
    idArray = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)test{
    NSLog(@"pointsDictionary--->%@",pointsDictionary);
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
    NSLog(@"ASSETS === %@",assets);
    for (asset in assets) {
        
        // Do something with the asset
        
        
        NSLog(@"%@", asset);
        assetData = asset;
        NSString *localIdentifier = assetData.localIdentifier;
        NSLog(@"NOW LOCALIDENTIFIER == %@",assetData.localIdentifier);

        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(300,300)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    //NSString *localIdentifier = [NSString new];
            if (result) {
                NSLog(@"result was called");
                imview.image = result;
                photoData.image = result;
                CIImage *image = [CIImage imageWithCGImage:result.CGImage];
                CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                          context:nil
                                                          options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
                                                                
                NSDictionary *options = @{CIDetectorSmile: @(YES),
                                          CIDetectorEyeBlink: @(YES),
                                        };
                
                
                features = [detector featuresInImage:image options:options];
                
                NSLog(@"FEATURES COUNT %ld", features.count);
                
                if (features) {
                    NSLog(@"if was called");
                    //[self setPoint];
                    int pt = 0;
                    
                    for(CIFaceFeature *feature in features){
                        NSLog(@"for was called");
                        
                        pt = pt + 1;
                        if (feature.hasSmile == YES) {
                            NSLog(@"================hasSmile===================");
                            pt = pt + 2;
                        }
                        //textView.text = [NSString stringWithFormat:@"image == %@ \n smile == %@ \n bounds == %@", imArray, smArray, boArray];
                    }
                    
                    if (pt > 0) {
                        NSNumber *pointNum = [NSNumber numberWithInt:pt];
                        NSLog(@"localIdentifier=%@ \n pointNum=%@",localIdentifier,pointNum);
                        [pointsDictionary setObject:pointNum forKey:localIdentifier];
                        NSLog(@"pointsDictionary===%@",pointsDictionary);
                        NSLog(@"localIdentifier===%@",localIdentifier);
                        NSLog(@"pointNum===%@",pointNum);
                    }else if(pt == 0){
                        NSLog(@"else was called");
                        //NSNumber *num = 0;
                        [pointsDictionary setObject:[NSNumber numberWithInt:0] forKey:localIdentifier];
                      //[pointsDictionary setObject:[NSNull null] forKey:localIdentifier];

                    }
                    NSLog(@"===smile===\n\n\n%@\n\n\n==========",features);
                }
                
            }
                                                    
        }];
    }
    
    int countOfPoints = [pointsDictionary count];
    NSArray *pointsArray = [pointsDictionary allValues];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO];
    NSArray *sortedArray = [pointsArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    NSLog(@"=========================\n\n\n\n\n\n\n\n\n\n\nsortedArray----->>>%@\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n=========================",sortedArray);
    for (int i = 0; i<countOfPoints; i++) {
        NSArray *array =  [pointsDictionary allKeysForObject:[sortedArray objectAtIndex:i]];
        [idArray addObject:array];
    }
    NSLog(@"=========================\n\n\n\n\n\n\n\n\n\n\nidArray----->>>%@\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n=========================",idArray);
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self test];
    [self goToSHVC];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
[self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)goToSHVC{
    ShowPhotosViewController *SHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowPhotosViewController"];
    SHVC.photosDic = pointsDictionary;
    [self presentViewController:SHVC animated:YES completion:nil];
    
}
/*
-(void)setPoint{
    NSLog(@"setPoint was called");
    int pt = 0;
    
    for(CIFaceFeature *feature in features){
        NSLog(@"for was called");
        
        pt = pt + 1;
        if (feature.hasSmile == YES) {
            NSLog(@"================hasSmile===================");
            pt = pt + 2;
        }
        //textView.text = [NSString stringWithFormat:@"image == %@ \n smile == %@ \n bounds == %@", imArray, smArray, boArray];
    }
    
    if (pt > 0) {
        NSNumber *pointNum = [NSNumber numberWithInt:pt];
        //    localIdentifier = assetData.localIdentifier;
        NSLog(@"localIdentifier=%@ \n pointNum=%@",localIdentifier,pointNum);
        [pointsDictionary setObject:pointNum forKey:localIdentifier];
        NSLog(@"pointsDictionary===%@",pointsDictionary);
        NSLog(@"localIdentifier===%@",localIdentifier);
        NSLog(@"pointNum===%@",pointNum);
    }
}
 
 */

@end
