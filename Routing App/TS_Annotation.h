//
//  TS_Annotation.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 07/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TS_Annotation : NSObject<MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property(nonatomic, copy)NSString* subtitle;
@property(nonatomic, retain)NSString* placemark;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *image;
@property (nonatomic, retain)UIImage* tImage;
@property(nonatomic, copy)NSString* tfname;

-(id)initWithCoordinates:(CLLocationCoordinate2D) paramCoordinates
                   image:(NSString *) paramImage;

- (id)initWithTitle:(NSString *)title andCoordinate:

(CLLocationCoordinate2D)coordinate2d;


@end
