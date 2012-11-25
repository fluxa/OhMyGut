//
//  FoodItemView.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoodItemView : UIView

@property (nonatomic,weak) IBOutlet UIButton *button;
@property (nonatomic,strong) NSManagedObject *managedObject;

@end
