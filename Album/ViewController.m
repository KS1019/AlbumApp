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
    PhotoArray = [[NSMutableArray alloc]init];
    for (asset in assets) {
        // Do something with the asset
        
        [PhotoArray addObject:asset];
        
    }
    NSLog(@"----> %@ <----",PhotoArray);
    [[PHImageManager defaultManager] requestImageForAsset:PhotoArray[0]
                                               targetSize:CGSizeMake(300,300)
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                if (result) {
                                                    imview.image = result;//[UIImage imageNamed:@"face.jpg"];
                                                    
                                                    [self eguther];
                                                }
                                            }];

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
[self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)eguther{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        
        CIImage *image = [CIImage imageWithCGImage:imview.image.CGImage];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
        
        NSDictionary *options = @{
                                  CIDetectorSmile: @(YES),
                                  CIDetectorEyeBlink: @(YES),
                                  };
        
        NSArray *features = [detector featuresInImage:image options:options];
        
        NSMutableString *resultStr = @"DETECTED FACES:\n\n".mutableCopy;
        
        for(CIFaceFeature *feature in features)
        {
            [resultStr appendFormat:@"bounds:%@\n", NSStringFromCGRect(feature.bounds)];
            [resultStr appendFormat:@"hasSmile: %@\n\n", feature.hasSmile ? @"YES" : @"NO"];
            //        NSLog(@"faceAngle: %@", feature.hasFaceAngle ? @(feature.faceAngle) : @"NONE");
            //        NSLog(@"leftEyeClosed: %@", feature.leftEyeClosed ? @"YES" : @"NO");
            //        NSLog(@"rightEyeClosed: %@", feature.rightEyeClosed ? @"YES" : @"NO");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
           
            
            textView.text = resultStr;
            NSLog(@"<<<<<<< %@ >>>>>>>>>",resultStr);
        });
    });
}
@end
