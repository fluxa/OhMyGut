//
//  Food.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/1/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodGroup;

@interface Food : NSManagedObject

@property (nonatomic, retain) NSNumber * foodid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSNumber * scdlegal;
@property (nonatomic, retain) NSNumber * gapslegal;
@property (nonatomic, retain) NSNumber * histamine;
@property (nonatomic, retain) NSNumber * fodmaps;
@property (nonatomic, retain) NSNumber * fiber;
@property (nonatomic, retain) NSNumber * goitrogenic;
@property (nonatomic, retain) FoodGroup *group;

@end
