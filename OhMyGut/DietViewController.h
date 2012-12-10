//
//  DietViewController.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FoodScrollView.h"

@interface DietViewController : UIViewController

@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UIButton *renderButton;
@property (nonatomic,weak) IBOutlet UIButton *renderAllButton;
@property (nonatomic,weak) IBOutlet FoodScrollView *scrollView;

@end
