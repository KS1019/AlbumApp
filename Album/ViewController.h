//
//  ViewController.h
//  Album
//
//  Created by Kotaro Suto on 2015/05/04.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBImagePicker.h"
#import <CoreImage/CoreImage.h>

@interface ViewController : UIViewController{
    NSMutableArray *PhotoArray;
    NSMutableArray *ResultsArray;
    
    PHAsset *asset;
    
    IBOutlet UIImageView *imview;
    IBOutlet UITextView *textView;
}


@end

