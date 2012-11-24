//
//  Data.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "Data.h"

@interface Data ()
{
    NSArray *_groups;
    NSArray *_symptoms;
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
    [self managedObjectContext];
    [self loadInitialData];
    return self;
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
    }
    
    NSArray *symptoms = [self getSymptoms];
    if ([symptoms count] == 0) {
        symptoms = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SXs" ofType:@"plist"]];
        for (NSDictionary *sx in symptoms) {
            SXs *sxs = [NSEntityDescription insertNewObjectForEntityForName:@"SXs"
                                                             inManagedObjectContext:self.managedObjectContext];
            SXGroup *sxgroup = [self groupByID:[[sx objectForKey:@"gid"] intValue]];
            sxs.group = sxgroup;
            sxs.text = [sx objectForKey:@"text"];
            
        }
    }
    
    NSError *error = nil;
    [self.managedObjectContext save:&error];

}

- (NSArray*) getGroups {
    if (_groups == nil) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SXGroup"];
        NSError *error = nil;
        _groups = [self.managedObjectContext executeFetchRequest:request error:&error];
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


@end
