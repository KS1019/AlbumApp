//
//  ViewController.m
//  Album
//
//  Created by Kotaro Suto on 2015/05/04.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import "ViewController.h"

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
       ResultsArray = [[NSMutableArray alloc]init];
    for (asset in assets) {
        // Do something with the asset
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:CGSizeMake(300,300)
                                                  contentMode:PHImageContentModeAspectFit
                                                      options:nil
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
            if (result) {
                imview.image = result;
                CIImage *image = [CIImage imageWithCGImage:result.CGImage];
                CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                          context:nil
                                                          options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
                                                                
                NSDictionary *options = @{CIDetectorSmile: @(YES),
                                          CIDetectorEyeBlink: @(YES),
                                        };
                                                                
                NSArray *features = [detector featuresInImage:image options:options];
                NSMutableString *resultStr = [NSMutableString string];
                [resultStr appendString:@"DETECTED FACES:\n\n"];
                                                                
                for(CIFaceFeature *feature in features){
                    [resultStr appendFormat:@"bounds:%@\n", NSStringFromCGRect(feature.bounds)];
                    [resultStr appendFormat:@"hasSmile: %@\n\n", feature.hasSmile ? @"YES" : @"NO"];
                    }
                [ResultsArray addObject:resultStr];

                
          
                NSLog(@"<<<<<<< %@ >>>>>>>>>",resultStr);
                NSLog(@"%@",ResultsArray);
               
                            

            }
                                                    
        }];

    }
    //NSLog(@"----> %@ <----",PhotoArray);
    //textView.text = [NSString stringWithFormat:@"%@",ResultsArray];
    NSLog(@"6666666666%@666666666",ResultsArray);
    textView.text = [NSString stringWithFormat:@"%@",ResultsArray];
        [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
