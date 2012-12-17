//
//  Data.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SXGroup.h"
#import "SXs.h"
#import "DaySX.h"
#import "FoodGroup.h"
#import "Food.h"
#import "DayFood.h"
#import "Diet.h"

#define FOOD_SAFE 0
#define FOOD_EATING 1
#define FOOD_NOT_EATING 2

@interface Data : NSObject

+ (Data *)shared;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) NSMutableDictionary *myDiets;

+ (NSDate*) TodayMidnight;

- (void) save;
- (void) updateDailyFoods;
- (NSArray*) getGroups;
- (NSArray*) getSymptoms;
- (NSArray*) getFoodGroups;
- (NSArray*) getFoods;
- (NSArray*) getDiets;
- (NSMutableDictionary*) getFilteredFoodGroups;
- (SXGroup*) groupByID:(int) gid;
- (DaySX*) getDaySX:(SXs*)sx date:(NSDate*)date;
- (DaySX*) getLatestDaySX:(SXs*)sx;
- (DayFood*) getDayFood:(Food*)food date:(NSDate*)date;


@end
