//
//  PhotoData.h
//  Album
//
//  Created by Kotaro Suto on 2015/05/05.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoData : NSObject

@property(nonatomic, strong)UIImage *image;
@property(nonatomic, strong)NSMutableArray *features;
@property(nonatomic, strong)NSMutableArray *smileArray;
@property(nonatomic, strong)NSMutableArray *boundsArray;

@end
