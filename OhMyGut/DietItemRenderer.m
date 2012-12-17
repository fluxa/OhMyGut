//
//  DietItemRenderer.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/17/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "DietItemRenderer.h"

@implementation DietItemRenderer
@synthesize diet = _diet;
@synthesize state = _state;

- (void) setDiet:(Diet *)diet {
    _diet = diet;
    self.name.text = diet.name;
}

- (void) setState:(int)state {
    _state = state;
    self.stateIV.image = [UIImage imageNamed:(state==0?@"redsquare.png":@"greensquare.png")];
}

@end
