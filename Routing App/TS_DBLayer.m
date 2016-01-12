//
//  TS_DBLayer.m
//  Routing App
//
//  Created by TacktileSystemsMac4 on 09/05/15.
//  Copyright (c) 2015 Tacktile Systems. All rights reserved.
//

#import "TS_DBLayer.h"
#import "TS_ParaRouteName.h"


@implementation TS_DBLayer
@synthesize tisRouteNameisPrestent;

#pragma mark-INSERT DATA
-(void)tInsertAddressInDB:(TS_ParaAddress *)tpara :(NSString*)tRouteName
{
  
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"TBROUTE.sqlite"];
    
    
    FMDatabase *fmDatabase=[FMDatabase databaseWithPath:path];
    [fmDatabase close];
    [fmDatabase open];
    //create table and give the name.
    //STORE IMAGE IN DB
    
 
    

        
        [fmDatabase executeUpdate: @"CREATE  TABLE IF NOT EXISTS TBROUTE(dbid INTEGER PRIMARY KEY AUTOINCREMENT, dbaddress VARCHAR,dbnotes VARCHAR, dbfirstproperty INTEGER, Student_Id INTEGER FOREGIN KEY REFERENCES TBROUTE(dbid))"];
        
        
        [fmDatabase executeUpdate:[NSString stringWithFormat:@"INSERT INTO TBROUTE (dbaddress,dbnotes,dbfirstproperty) values ('%@' , '%@' ,'%d')",tpara.taddress,tpara.tnotes,tpara.tFirstProperty]];
    
    
    
    
        [fmDatabase close];
}


-(void)tInsertRouteName:(NSString *)tnameOfRoute
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    
    
    FMDatabase *fmDatabase=[FMDatabase databaseWithPath:path];
    [fmDatabase close];
    [fmDatabase open];
    //create table and give the name.
    //STORE IMAGE IN DB
    
    
    
    
    
    [fmDatabase executeUpdate: @"CREATE  TABLE IF NOT EXISTS TBROUTE(dbid INTEGER PRIMARY KEY AUTOINCREMENT, dbroutename VARCHAR)"];
    
    
    [fmDatabase executeUpdate:[NSString stringWithFormat:@"INSERT INTO TBROUTE (dbroutename) values ('%@' )",tnameOfRoute]];
    
    
    
    
    
    [fmDatabase close];
}


-(void)tInsertRouteNameAndAddress:(NSString *)trouteName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    
    
    FMDatabase *fmDatabase=[FMDatabase databaseWithPath:path];
    [fmDatabase close];
    [fmDatabase open];
    //create table and give the name.
    //STORE IMAGE IN DB
    
   
    tisRouteNameisPrestent = [self tRetrieveData:trouteName];
    
    if(tisRouteNameisPrestent)
    {
    
    [fmDatabase executeUpdate: @"CREATE TABLE IF NOT EXISTS TBROUTE2(dbid INTEGER PRIMARY KEY AUTOINCREMENT, dbroutename VARCHAR, dbrouteflag INTEGER)"];
    
        int trouteflag=0;
    [fmDatabase executeUpdate:[NSString stringWithFormat:@"INSERT INTO TBROUTE2 (dbroutename,dbrouteflag) values ('%@','%d')",trouteName,trouteflag]];
    
       
    [fmDatabase close];
        
        
           }
    else
    {
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Route Name" message:[NSString stringWithFormat:@"Route Name : %@ already exist",trouteName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [talertObj show];
        TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
        tserverObj.isSaveRoutes= false;
        
    }
    

    
    NSLog(@"path=%@",path);

    
    
}


-(void)tSaveAddressInDB: (NSMutableArray*)tAddressArray
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    TS_ParaAddress* tpara = [TS_ParaAddress new];
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    
    
    [self tRetrieveRouteNameId:tserverObj.tRouteName];
    
    if(tisRouteNameisPrestent)
    {
    
    for(int i=0; i<tAddressArray.count; i++)
    {
    
        tpara = [tAddressArray objectAtIndex:i];
        tpara.tidentifireName = [self randomStringWithLength:9+i];
        NSLog(@"Identifier=%@",tpara.tidentifireName);
        NSLog(@"Lat-%f&Long-=%f",tpara.tLatitude,tpara.tLongitude);
    FMDatabase *fmDatabase=[FMDatabase databaseWithPath:path];
    [fmDatabase close];
    [fmDatabase open];
    //create table and give the name.
    //STORE IMAGE IN DB
      
#warning insert Latitude & Longitude
    [fmDatabase executeUpdate: @"CREATE  TABLE IF NOT EXISTS TBSAVEADDRESS(dbId INTEGER PRIMARY KEY AUTOINCREMENT, dbaddress VARCHAR,dbnotes VARCHAR, dbfirstproperty INTEGER,dbidentifier VARCHAR,dblatitude DOUBLE,dblongitude DOUBLE,dbid2 INTEGER FOREGIN KEY REFERENCES TBROUTE2(dbid))"];
    
    
    [fmDatabase executeUpdate:[NSString stringWithFormat:@"INSERT INTO TBSAVEADDRESS (dbaddress,dbnotes,dbfirstproperty,dbidentifier,dblatitude,dblongitude,dbid2) values ('%@' , '%@' ,'%d','%@','%f','%f','%d')",tpara.taddress,tpara.tnotes,tpara.tFirstProperty,tpara.tidentifireName,tpara.tLatitude,tpara.tLongitude,tserverObj.tForeginKey]];

        NSLog(@"Path=%@",path);
       
    [fmDatabase close];
        
     
    }
        UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Route" message:[NSString stringWithFormat:@"Route Name : %@ data successfully saved.",tserverObj.tRouteName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [talertObj show];
    }
   
}


#pragma mark-RETRIEVE DATA

-(BOOL)tRetrieveData :(NSString*)tRouteName
{
    NSMutableArray* returnArray = [NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    BOOL isYesOrNo = true;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBROUTE2 WHERE dbroutename='%@'",tRouteName];
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next])
    {
        
        //        TS_ParaNotifications* tpara = [TS_ParaNotifications new];
        
        NSString* tnameOfRoute=[resultsWithNameLocation stringForColumn:@"dbroutename"];
        NSLog(@"NameOfRoute=%@",tnameOfRoute);
        [returnArray addObject:tnameOfRoute];
        
        
    }
    
    [database close];
    
    for(int i=0; i<returnArray.count;i++)
    {
        NSString* tname = [returnArray objectAtIndex:i];
        if([tname isEqualToString:tRouteName])
        {
            isYesOrNo = false;
        }
       
    }
    if(isYesOrNo)
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

-(BOOL)tRetrieveDataOfAddress:(NSString*)taddress :(int)tRouteId
{
    NSMutableArray* returnArray = [NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    BOOL isYesOrNo = true;
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBSAVEADDRESS WHERE dbid2='%d'",tRouteId];
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next])
    {
        
        //        TS_ParaNotifications* tpara = [TS_ParaNotifications new];
        
        NSString* tnameOfRoute=[resultsWithNameLocation stringForColumn:@"dbaddress"];
        NSLog(@"NameOfRoute=%@",tnameOfRoute);
        [returnArray addObject:tnameOfRoute];
        
        
    }
    
    [database close];
    
    for(int i=0; i<returnArray.count;i++)
    {
        NSString* tadd = [returnArray objectAtIndex:i];
        if([tadd isEqualToString:taddress])
        {
            isYesOrNo = false;
        }
        
    }
    if(isYesOrNo)
    {
        return YES;
    }
    else
    {
        return NO;
    }

    return NO;
}

-(void)tRetrieveRouteNameId :(NSString*)trouteName
{
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBROUTE2 WHERE dbroutename='%@'",trouteName];
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next])
    {
        TS_ServerClass* tserObj = [TS_ServerClass tsharedInstance];
                tserObj.tForeginKey = [resultsWithNameLocation intForColumn:@"dbid"];
                NSLog(@"Id=%d",tserObj.tForeginKey);
        
    }
    
    
    [database close];

}

-(NSMutableArray*)tRetrieveSaveRoutesList
{
    NSMutableArray* returnArray = [NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    int trouteflag = 0;
    
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBROUTE2 where dbrouteflag = %d",trouteflag];
    
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        
       
        TS_ParaRouteName* tpara = [TS_ParaRouteName new];
        tpara.trouteName = [resultsWithNameLocation stringForColumn:@"dbroutename"];
        tpara.tdbid = [resultsWithNameLocation intForColumn:@"dbid"];
        
        [returnArray addObject:tpara];
        
        
    }
    
    NSLog(@"Path=%@",paths);
    
    [database close];
    
    
    return returnArray;
}

-(NSMutableArray*)tRetrieveCompletedRoutesList
{
    NSMutableArray* returnArray = [NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    int trouteflag = 1;
    
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBROUTE2 where dbrouteflag = %d",trouteflag];
    
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        
        
        TS_ParaRouteName* tpara = [TS_ParaRouteName new];
        tpara.trouteName = [resultsWithNameLocation stringForColumn:@"dbroutename"];
        tpara.tdbid = [resultsWithNameLocation intForColumn:@"dbid"];
        
        [returnArray addObject:tpara];
        
        
    }
    
    [database close];
    
    
    return returnArray;
}


-(NSMutableArray*)tRerieveRoutesData:(int)tdbId
{
    NSMutableArray* returnArray = [NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    NSLog(@"Path=%@",dbPath);
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBSAVEADDRESS WHERE dbid2='%d'",tdbId];
    
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        
        
        TS_ParaAddress* tpara = [TS_ParaAddress new];
        tpara.taddress = [resultsWithNameLocation stringForColumn:@"dbaddress"];
        tpara.tnotes = [resultsWithNameLocation stringForColumn:@"dbnotes"];
        NSLog(@"Notes=%@",tpara.tnotes);
        tpara.tidentifireName = [resultsWithNameLocation stringForColumn:@"dbidentifier"];
        tpara.tRouteId = [resultsWithNameLocation intForColumn:@"dbId"];
        tpara.tForeginKey = [resultsWithNameLocation intForColumn:@"dbid2"];
        tpara.tFirstProperty = [resultsWithNameLocation intForColumn:@"dbfirstproperty"];
        tpara.tLatitude = [resultsWithNameLocation doubleForColumn:@"dblatitude"];
        tpara.tLongitude = [resultsWithNameLocation doubleForColumn:@"dblongitude"];
        
        NSLog(@"Identifer=%@",tpara.tidentifireName);
        
        [returnArray addObject:tpara];
        
        
    }
    
    [database close];
    
    
    return returnArray;

}
#pragma mark-UPDATE

-(void)tUpdateAddressId :(TS_ParaAddress*)tpara
{
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir=[documentsPaths objectAtIndex:0];
    NSString* dbPath=[documentsDir stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    FMDatabase *database=[FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:[NSString stringWithFormat:@"UPDATE TBSAVEADDRESS set dbaddress='%@',dbnotes='%@', dbfirstproperty='%d',dbidentifier='%@',dblatitude='%f',dblongitude='%f',dbid2='%d' where dbId=%d",tpara.taddress,tpara.tnotes,tpara.tFirstProperty,tpara.tidentifireName,tpara.tLatitude,tpara.tLongitude,tpara.tForeginKey,tpara.tRouteId]];
    NSLog(@"dbaddress='%@',dbnotes='%@', dbfirstproperty='%d',dbidentifier='%@',dbid2='%d' where dbid2=%d",tpara.taddress,tpara.tnotes,tpara.tFirstProperty,tpara.tidentifireName,tpara.tForeginKey,tpara.tRouteId);
    [database close];
    NSLog(@"Path=%@",dbPath);
}

-(void)tUpdateAddressData:(NSMutableArray *)taddressArray
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *path = [docsPath stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    TS_ParaAddress* tpara = [TS_ParaAddress new];
    TS_ServerClass* tserverObj = [TS_ServerClass tsharedInstance];
    
    
    [self tRetrieveRouteNameId:tserverObj.tRouteName];
  
    
    
        for(int i=0; i<taddressArray.count; i++)
        {
            
            tpara = [taddressArray objectAtIndex:i];
            NSLog(@"Notes=%@\nAddred=%@",tpara.tnotes,tpara.taddress);
            tpara.tidentifireName = [self randomStringWithLength:9+i];
            BOOL isAddressPresent = [self tRetrieveDataOfAddress:tpara.taddress :tserverObj.tForeginKey];
            if(isAddressPresent)
            {
                
            FMDatabase *fmDatabase=[FMDatabase databaseWithPath:path];
            [fmDatabase close];
            [fmDatabase open];
            //create table and give the name.
            //STORE IMAGE IN DB
            
                [fmDatabase executeUpdate: @"CREATE  TABLE IF NOT EXISTS TBSAVEADDRESS(dbId INTEGER PRIMARY KEY AUTOINCREMENT, dbaddress VARCHAR,dbnotes VARCHAR, dbfirstproperty INTEGER,dbidentifier VARCHAR,dblatitude DOUBLE,dblongitude DOUBLE,dbid2 INTEGER FOREGIN KEY REFERENCES TBROUTE2(dbid))"];
                
                
                [fmDatabase executeUpdate:[NSString stringWithFormat:@"INSERT INTO TBSAVEADDRESS (dbaddress,dbnotes,dbfirstproperty,dbidentifier,dblatitude,dblongitude,dbid2) values ('%@' , '%@' ,'%d','%@','%f','%f','%d')",tpara.taddress,tpara.tnotes,tpara.tFirstProperty,tpara.tidentifireName,tpara.tLatitude,tpara.tLongitude,tserverObj.tForeginKey]];

            
            
            [fmDatabase close];
                if(i == taddressArray.count-1)
                {
                UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Route" message:[NSString stringWithFormat:@"Route Name : %@ data successfully saved.",tserverObj.tRouteName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [talertObj show];
                }
        }
    
    }
    
}

-(void)tUpdateRouteData :(NSString*)trouteName
{
    
    NSArray *documentsPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDir=[documentsPaths objectAtIndex:0];
    NSString* dbPath=[documentsDir stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    FMDatabase *database=[FMDatabase databaseWithPath:dbPath];
    [database open];
    int tRouteFlag = 1;
    
    [database executeUpdate:[NSString stringWithFormat:@"UPDATE TBROUTE2 set dbrouteflag='%d' where dbroutename='%@'",tRouteFlag,trouteName]];
 
    [database close];
    NSLog(@"Path=%@",dbPath);
}


#pragma mark-DELETE
-(void)deleteData:(int)deleteDataOfId
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:[NSString stringWithFormat:@"DELETE FROM TBSAVEADDRESS WHERE dbid=%d", deleteDataOfId], nil];
    [database close];
}

-(void)tDeleteRouteData:(int)dbid
{
   
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:[NSString stringWithFormat:@"DELETE FROM TBROUTE2 WHERE dbid=%d", dbid], nil];
    [database close];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadTableView" object:nil];
    [self tDeleteAddressRecord:dbid];
}
-(void)tDeleteAddressRecord:(int)dbid
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:[NSString stringWithFormat:@"DELETE FROM TBSAVEADDRESS WHERE dbid2=%d", dbid], nil];
    [database close];

}
-(NSMutableArray*)selectMaxId
{
    
    NSMutableArray* treturnarray=[NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBSAVEADDRESS"];
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        
        
        
       int lastId=[resultsWithNameLocation intForColumn:@"dbfirstproperty"];
        //        NSLog(@"LADT ID=%d",lastId);
        NSNumber* tid =[NSNumber numberWithInt:lastId];
        [treturnarray addObject:tid];
        
    }
    
    [database close];
    
    
    return treturnarray;
    
}
-(int)treturnMaxId
{
    int number = 0;
    NSMutableArray* treturnarray=[NSMutableArray new];
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"TBSAVEADDRESS.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = [NSString stringWithFormat:@"SELECT * FROM TBSAVEADDRESS"];
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        
        
        
        int lastId=[resultsWithNameLocation intForColumn:@"dbid"];
        //        NSLog(@"LADT ID=%d",lastId);
        NSNumber* tid =[NSNumber numberWithInt:lastId];
        [treturnarray addObject:tid];
        
    }
    
    [database close];
    
    for(int i=0;i<treturnarray.count;i++)
    {
       NSNumber* num = [treturnarray objectAtIndex:i];
        number = [num intValue];
        NSLog(@"Number=%d\n%@",number,treturnarray);
    }
    
    return number;
}
#pragma mark-GENERATE UNIQUE STRING
-(NSString *) randomStringWithLength: (int) len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

/*
 IMPORTANT METHOD
 -(void)tInsertRouteNameAndAddress:(NSString *)trouteName
 {
 NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 NSString *docsPath = [paths objectAtIndex:0];
 NSString *path = [docsPath stringByAppendingPathComponent:@"TBROUTE2.sqlite"];
 
 
 FMDatabase *fmDatabase=[FMDatabase databaseWithPath:path];
 [fmDatabase close];
 [fmDatabase open];
 //create table and give the name.
 //STORE IMAGE IN DB
 
 
 tisRouteNameisPrestent = [self tRetrieveData:trouteName];
 
 if(tisRouteNameisPrestent)
 {
 
 [fmDatabase executeUpdate: @"CREATE TABLE IF NOT EXISTS TBROUTE2(dbid INTEGER PRIMARY KEY AUTOINCREMENT, dbroutename VARCHAR)"];
 
 
 [fmDatabase executeUpdate:[NSString stringWithFormat:@"INSERT INTO TBROUTE2 (dbroutename) values ('%@')",trouteName]];
 
 
 [fmDatabase close];
 
 
 }
 else
 {
 UIAlertView* talertObj = [[UIAlertView alloc]initWithTitle:@"Route Name" message:[NSString stringWithFormat:@"Route Name : %@ already exist",trouteName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
 [talertObj show];
 
 }
 
 
 
 NSLog(@"path=%@",path);
 
 
 
 }
 */



@end
