//
//  DietItemRenderer.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/17/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Diet.h"

@interface DietItemRenderer : UIView

@property (nonatomic,weak) IBOutlet UIImageView *stateIV;
@property (nonatomic,weak) IBOutlet UILabel *name;
@property (nonatomic,strong) Diet *diet;
@property (nonatomic,assign) int state;
@end
