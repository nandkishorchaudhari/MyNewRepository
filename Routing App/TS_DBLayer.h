//
//  TS_DBLayer.h
//  Routing App
//
//  Created by TacktileSystemsMac4 on 09/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "TS_ParaAddress.h"
#import <UIKit/UIKit.h>
#import "TS_ServerClass.h"

@interface TS_DBLayer : NSObject

@property(nonatomic)BOOL tisRouteNameisPrestent;

-(void)tInsertAddressInDB :(TS_ParaAddress*)tpara :(NSString*)tRouteName;
-(void)tInsertRouteName :(NSString*)tnameOfRoute;
-(void)tInsertRouteNameAndAddress :(NSString*)trouteName;
-(void)tSaveAddressInDB:(NSMutableArray*)tAddressArray;
-(void)tRetrieveRouteNameId :(NSString*)trouteName;
-(void)tDeleteRouteData:(int)dbid;
-(void)tUpdateAddressData : (NSMutableArray*)taddressArray;
-(NSMutableArray*)tRetrieveSaveRoutesList;
-(NSMutableArray*)tRerieveRoutesData:(int)tdbId;
-(void)tUpdateAddressId :(TS_ParaAddress*)tpara;
-(void)tDeleteAddressRecord:(int)dbid;
-(void)deleteData:(int)deleteDataOfId;
-(void)tUpdateRouteData :(NSString*)trouteName;
-(NSMutableArray*)tRetrieveCompletedRoutesList;
-(NSMutableArray*)selectMaxId;
-(int)treturnMaxId;

@end
