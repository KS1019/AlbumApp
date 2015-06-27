//
//  ShowPhotsViewController.h
//  Album
//
//  Created by Kotaro Suto on 2015/06/13.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ShowPhotosViewController : UIViewController{
    NSDictionary *photosDic;
    CGRect rect1;
    UIImageView *imageView;
    UIImage *srcImage;
    }
@property(nonatomic)NSDictionary *photosDic;


@end
