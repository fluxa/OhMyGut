//
//  DietItem.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/1/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DietItem : UIView

@property (nonatomic,strong) NSString *dietID;
@property (nonatomic,weak) IBOutlet UILabel *nameLabel;
@property (nonatomic,weak) IBOutlet UISwitch *switchControl;

@end
