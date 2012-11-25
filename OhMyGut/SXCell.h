//
//  SXCell.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/24/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXs.h"

@interface SXCell : UITableViewCell

@property (nonatomic,weak) IBOutlet UISegmentedControl *buttons;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;

@property (nonatomic,strong) SXs *sx;

@end
