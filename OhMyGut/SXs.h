//
//  SXs.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DaySX, SXGroup;

@interface SXs : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * sxid;
@property (nonatomic, retain) SXGroup *group;
@property (nonatomic, retain) NSSet *trackeddays;
@end

@interface SXs (CoreDataGeneratedAccessors)

- (void)addTrackeddaysObject:(DaySX *)value;
- (void)removeTrackeddaysObject:(DaySX *)value;
- (void)addTrackeddays:(NSSet *)values;
- (void)removeTrackeddays:(NSSet *)values;

@end
