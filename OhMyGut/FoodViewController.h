//
//  FoodViewController.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/2/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodScrollView.h"
#import "Food.h"

@interface FoodViewController : UIViewController

@property (nonatomic,assign) BOOL renderEating;
@property (nonatomic,weak) IBOutlet UISegmentedControl *stateControl;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UITextView *textView;
@property (nonatomic,strong) Food *food;

@end
