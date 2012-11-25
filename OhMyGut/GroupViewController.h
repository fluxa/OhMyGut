//
//  GroupViewController.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodGroup.h"
#import "Food.h"
#import "FoodScrollView.h"

@interface GroupViewController : UIViewController

@property (nonatomic,weak) IBOutlet UISegmentedControl *stateControl;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet FoodScrollView *scrollView;

@property (nonatomic,strong) FoodGroup *foodGroup;

@end
