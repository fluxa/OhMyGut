//
//  Food.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FoodGroup;

@interface Food : NSManagedObject

@property (nonatomic, retain) NSNumber * foodid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stdlegal;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) FoodGroup *group;

@end
