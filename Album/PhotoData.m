//
//  PhotoData.m
//  Album
//
//  Created by Kotaro Suto on 2015/05/05.
//  Copyright (c) 2015年 Kotaro Suto. All rights reserved.
//

#import "PhotoData.h"

@implementation PhotoData

@synthesize image;
@synthesize features;
@synthesize smileArray;
@synthesize boundsArray;

- (id)init
{
    self = [super init];
    if (self) {
        //Initialization
        self.image = nil;
        self.features = [NSMutableArray new];
        self.smileArray = [NSMutableArray new];
        self.boundsArray = [NSMutableArray new];
    }
    return self;
}

@end
