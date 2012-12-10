//
//  Data.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "Data.h"

#define DIETS_KEY @"dietsKey"


@interface Data ()
{
    NSArray *_groups;
    NSArray *_symptoms;
    NSArray *_foodGroups;
    NSArray *_foods;
    NSArray *_diets;
    NSMutableDictionary *_filteredFoodGroups;
    BOOL _filteredGroupsDirty;
}

@end

@implementation Data

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

+ (Data *)shared
{
    static Data *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[Data alloc] init];
        // Do any other initialisation stuff here
    });
    return shared;
}

- (id) init {
    self = [super init];
    self.myDiets = [[NSUserDefaults standardUserDefaults] objectForKey:DIETS_KEY];
    if (self.myDiets == nil) {
        self.myDiets = [NSMutableDictionary dictionary];
    }
    
    [self managedObjectContext];
    [self loadInitialData];
    [self updateDailyFoods];
    return self;
}

- (void) save {
    [[NSUserDefaults standardUserDefaults] setObject:self.myDiets forKey:DIETS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    _filteredGroupsDirty = YES;
}

- (void) loadInitialData {
    
    NSArray *groups = [self getGroups];
    if ([groups count] == 0) {
        groups = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SXGroups" ofType:@"plist"]];
        for (NSDictionary *group in groups) {
            SXGroup *sxgroup = [NSEntityDescription insertNewObjectForEntityForName:@"SXGroup"
                                                             inManagedObjectContext:self.managedObjectContext];
            sxgroup.gid = [group objectForKey:@"gid"];
            sxgroup.name = [group objectForKey:@"name"];
            
        }
        _groups = nil;
    }
    
    NSArray *symptoms = [self getSymptoms];
    if ([symptoms count] == 0) {
        symptoms = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SXs" ofType:@"plist"]];
        for (NSDictionary *sx in symptoms) {
            SXs *sxs = [NSEntityDescription insertNewObjectForEntityForName:@"SXs"
                                                             inManagedObjectContext:self.managedObjectContext];
            SXGroup *sxgroup = [self groupByID:[[sx objectForKey:@"gid"] intValue]];
            sxs.sxid = [sx objectForKey:@"sxid"];
            sxs.group = sxgroup;
            sxs.text = [sx objectForKey:@"text"];
            
        }
        _symptoms = nil;
    }
    
    NSArray *foodGroups = [self getFoodGroups];
    if ([foodGroups count] == 0) {
        foodGroups = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FoodGroups" ofType:@"plist"]];
        for (NSDictionary *dict in foodGroups) {
            FoodGroup *foodg = [NSEntityDescription insertNewObjectForEntityForName:@"FoodGroup"
                                                          inManagedObjectContext:self.managedObjectContext];
            
            foodg.gid = [dict objectForKey:@"gid"];
            foodg.name = [dict objectForKey:@"name"];
            foodg.notes = [dict objectForKey:@"notes"];
            foodg.state = @1;
            
        }
        _foodGroups = nil;
    }
    
    NSArray *foods = [self getFoods];
    if ([foods count] == 0) {
        foods = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Foods" ofType:@"plist"]];
        for (NSDictionary *dict in foods) {
            Food *food = [NSEntityDescription insertNewObjectForEntityForName:@"Food"
                                                          inManagedObjectContext:self.managedObjectContext];
            
            FoodGroup *fg = [self foodGroupByID:[[dict objectForKey:@"gid"] intValue]];
            food.group = fg;
            food.foodid = dict[@"foodid"];
            food.name = dict[@"name"];
            food.scdlegal = dict[@"scdlegal"];
            food.gapslegal = dict[@"gapslegal"];
            food.histamine = dict[@"histamine"];
            food.fodmaps = dict[@"fodmaps"];
            food.fiber = dict[@"fiber"];
            food.goitrogenic = dict[@"goitrogenic"];
            food.notes = dict[@"notes"];
            food.state = @1;
            
        }
        _foods = nil;
    }
    
    NSArray *diets = [self getDiets];
    if ([diets count] == 0) {
        diets = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Diets" ofType:@"plist"]];
        for (NSDictionary *dict in diets) {
            Diet *diet = [NSEntityDescription insertNewObjectForEntityForName:@"Diet"
                                                       inManagedObjectContext:self.managedObjectContext];
            
            diet.dietid = dict[@"dietid"];
            diet.name = dict[@"name"];
            
        }
        _diets = nil;
    }


    NSError *error = nil;
    [self.managedObjectContext save:&error];

}

- (void) updateDailyFoods {
    NSArray *allfood = [self getFoods];
    for (Food *food in allfood) {
        
        NSDate *today = [Data TodayMidnight];
        DayFood *df = [self getLatestDayFood:food];
        if (df == nil) {
            //first
            df = [NSEntityDescription insertNewObjectForEntityForName:@"DayFood"
                                               inManagedObjectContext:self.managedObjectContext];
            df.food = food;
            df.state = food.state;
            df.date = today;
            
        } else {
            
            if (df.state != food.state) {
                NSTimeInterval t = [df.date timeIntervalSinceDate:today];
                if (t == 0) {
                    NSLog(@"%@ changed from %d to %d, saved for sameday",food.name,df.state.intValue,food.state.intValue);
                    df.state = food.state;
                } else {
                    NSLog(@"%@ changed from %d to %d, saved for new day",food.name,df.state.intValue,food.state.intValue);
                    DayFood *newdf = [NSEntityDescription insertNewObjectForEntityForName:@"DayFood"
                                                       inManagedObjectContext:self.managedObjectContext];
                    newdf.food = food;
                    newdf.state = food.state;
                    newdf.date = today;
                }
                
                
            }
        }
    }
    NSError *error = nil;
    [self.managedObjectContext save:&error];
}

- (NSArray*) getDiets {
    if (_diets == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Diet"];
        NSError *error = nil;
        _diets = [self.managedObjectContext executeFetchRequest:request error:&error];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"dietid" ascending:YES];
        _diets = [_groups sortedArrayUsingDescriptors:@[sort]];
        if (error != nil) {
            Alert(@"Data", [error description]);
        }
    }
    return _diets;
}

- (NSArray*) getGroups {
    if (_groups == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SXGroup"];
        NSError *error = nil;
        _groups = [self.managedObjectContext executeFetchRequest:request error:&error];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gid" ascending:YES];
        _groups = [_groups sortedArrayUsingDescriptors:@[sort]];
        if (error != nil) {
            Alert(@"Data", [error description]);
        }
    }
    return _groups;
}

- (NSArray*) getSymptoms {
    if (_symptoms == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SXs"];
        NSError *error = nil;
        _symptoms = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error != nil) {
            Alert(@"Data", [error description]);
        }
    }
    return _symptoms;
}

- (NSArray*) getFoodGroups {
    if (_foodGroups == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FoodGroup"];
        NSError *error = nil;
        _foodGroups = [self.managedObjectContext executeFetchRequest:request error:&error];
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gid" ascending:YES];
        _foodGroups = [_foodGroups sortedArrayUsingDescriptors:@[sort]];
        if (error != nil) {
            Alert(@"Data", [error description]);
        }
    }
    return _foodGroups;
}

- (NSArray*) getFoods {
    if (_foods == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Food"];
        NSError *error = nil;
        _foods = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error != nil) {
            Alert(@"Data", [error description]);
        }
    }
    return _foods;
}

- (NSMutableDictionary*) getFilteredFoodGroups {
    
    if (_filteredFoodGroups == nil || _filteredGroupsDirty) {
        _filteredFoodGroups = [NSMutableDictionary dictionary];
        NSArray *allGroups = [self getFoodGroups];
        for (FoodGroup *fg in allGroups) {
            NSMutableArray *foodCanEat = [NSMutableArray array];
            NSMutableArray *foodCant = [NSMutableArray array];
            for (Food *food in fg.foods) {
                if ([food.state intValue] == FOOD_SAFE || [food.state intValue] == FOOD_EATING) {
                    [foodCanEat addObject:food];
                } else {
                    [foodCant addObject:food];
                }
            }
            [_filteredFoodGroups setObject:@[foodCanEat,foodCant] forKey:fg.gid];
        }

    }
    return _filteredFoodGroups;
}

- (SXGroup*) groupByID:(int) gid {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gid == %d",gid];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SXGroup"];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([a count] > 0 && error == nil)
    {
        return (SXGroup*)[a objectAtIndex:0];
    }
    return nil;
}

- (DaySX*) getDaySX:(SXs*)sx date:(NSDate*)date {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sx == %@ AND date == %@",sx,date];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DaySX"];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([a count] > 0 && error == nil)
    {
        return (DaySX*)[a objectAtIndex:0];
    }
    return nil;
}

- (DaySX*) getLatestDaySX:(SXs*)sx {
    NSArray *all = [sx.trackeddays allObjects];
    NSSortDescriptor *byDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *ordered = [all sortedArrayUsingDescriptors:@[byDate]];
    if ([all count] > 0)
    {
        return [ordered objectAtIndex:0];
    }
    return nil;
}

- (FoodGroup*) foodGroupByID:(int) gid {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"gid == %d",gid];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"FoodGroup"];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([a count] > 0 && error == nil)
    {
        return (FoodGroup*)[a objectAtIndex:0];
    }
    return nil;
}

- (DayFood*) getDayFood:(Food*)food date:(NSDate*)date {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"food == %@ AND date == %@",food,date];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"DayFood"];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *a = [self.managedObjectContext executeFetchRequest:request error:&error];
    if ([a count] > 0 && error == nil)
    {
        return (DayFood*)[a objectAtIndex:0];
    }
    return nil;
}

- (DayFood*) getLatestDayFood:(Food*)food {
    NSArray *all = [food.tracked allObjects];
    NSSortDescriptor *byDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *ordered = [all sortedArrayUsingDescriptors:@[byDate]];
    if ([all count] > 0)
    {
        return [ordered objectAtIndex:0];
    }
    return nil;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// UTILS
+ (NSDate*) TodayMidnight {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    return [calendar dateFromComponents:[calendar components:preservedComponents fromDate:date]];
}

@end
