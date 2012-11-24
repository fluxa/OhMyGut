//
//  SXs.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SXGroup;

@interface SXs : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) SXGroup *group;

@end
