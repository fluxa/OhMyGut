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

@interface Data : NSObject

+ (Data *)shared;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSArray*) getGroups;
- (NSArray*) getSymptoms;
- (SXGroup*) groupByID:(int) gid;

@end
