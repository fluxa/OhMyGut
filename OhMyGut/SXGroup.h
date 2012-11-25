//
//  SXGroup.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SXs;

@interface SXGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * gid;
@property (nonatomic, retain) NSSet *sxsbygroup;
@end

@interface SXGroup (CoreDataGeneratedAccessors)

- (void)addSxsbygroupObject:(SXs *)value;
- (void)removeSxsbygroupObject:(SXs *)value;
- (void)addSxsbygroup:(NSSet *)values;
- (void)removeSxsbygroup:(NSSet *)values;

@end
