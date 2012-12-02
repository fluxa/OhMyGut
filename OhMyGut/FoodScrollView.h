//
//  FoodScrollView.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"
#import "FoodGroup.h"

typedef void(^OnItemClick)(NSManagedObject* obj);

@interface FoodScrollView : UIScrollView

@property (nonatomic,strong) NSArray *items;
@property (nonatomic,copy) OnItemClick onItemClick;

- (void) render;
- (void) clean;

@end
