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
#import "PhotoData.h"


@interface ViewController : UIViewController{
    NSMutableArray *PhotoArray;
    NSMutableArray *resultsArray;
    
    NSMutableArray *imArray;
    NSMutableArray *smArray;
    NSMutableArray *boArray;
    
    NSMutableDictionary *pointsDictionary;
    
    NSArray *features;
    
    NSString *localIdentifier;
    
    int pt;
    
    
    
    
    PHAsset *asset;
    
    PhotoData *photoData;
    
    IBOutlet UIImageView *imview;
    IBOutlet UITextView *textView;
}


@end

