//
//  TS_Annotation.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 07/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TS_Annotation.h"

@implementation TS_Annotation

@synthesize tImage,title,coordinate,subtitle,placemark,tfname;

-(id)initWithTitle:(NSString *)titles andCoordinate:
(CLLocationCoordinate2D)coordinate2d
{
    title = titles;
    coordinate =coordinate2d;
    
    
    return self;
}

-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                   image:(NSString *)paramImage
{
    self = [super init];
    if(self != nil)
    {
        coordinate = paramCoordinates;
        _image = paramImage;
    }
    return (self);
}

@end
