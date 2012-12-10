//
//  Diet.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/9/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Diet : NSManagedObject

@property (nonatomic, retain) NSString * dietid;
@property (nonatomic, retain) NSString * name;

@end
