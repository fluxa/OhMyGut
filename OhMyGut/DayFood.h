//
//  DayFood.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/8/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Food;

@interface DayFood : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) Food *food;

@end
