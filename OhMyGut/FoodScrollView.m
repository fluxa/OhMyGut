//
//  FoodScrollView.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "FoodScrollView.h"
#import "FoodItemView.h"
#import <QuartzCore/QuartzCore.h>

#define V_MARGIN 5
#define H_MARGIN 5
#define V_SPACE 5
#define H_SPACE 5
#define H_INNER_MARGIN 15
#define V_INNER_MARGIN 10

@implementation FoodScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) render {
    
    [self clean];
    
    int locX = H_MARGIN;
    int locY = V_MARGIN;
    CGSize contSize = CGSizeMake(310, 400);
    
    for (NSManagedObject *item in self.items) {
        
        FoodItemView *itemv = [[[NSBundle mainBundle] loadNibNamed:@"FoodItemView" owner:self options:nil]
                               objectAtIndex:0];
        NSString *title = [item valueForKey:@"name"];
        [itemv.button setTitle:title forState:UIControlStateNormal];
        
        UIImage *itemBG;
        switch ([[item valueForKey:@"state"] intValue]) {
            case 0:
                //safe
                itemBG = [UIImage imageNamed:@"itemSafeBG.png"];
                break;
                
            case 1:
                //eating
                itemBG = [UIImage imageNamed:@"itemEatingBG.png"];
                break;
                
            case 2:
                //not eating
                itemBG = [UIImage imageNamed:@"itemNotEatingBG.png"];
                break;
        }
        [itemv.button setBackgroundImage:itemBG forState:UIControlStateNormal];
        itemv.button.layer.cornerRadius = 10;
        itemv.button.clipsToBounds = YES;
        itemv.managedObject = item;
        [itemv.button addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize itemSize = [title sizeWithFont:itemv.button.titleLabel.font];
        CGRect itemvFrame;
        
        if (locX + H_SPACE + itemSize.width < contSize.width - H_MARGIN) {
            //this line
            itemvFrame = CGRectMake(locX, locY, itemSize.width+H_INNER_MARGIN, itemSize.height+V_INNER_MARGIN);
        } else {
            //new line
            locX = H_MARGIN;
            locY += V_SPACE + itemSize.height + V_INNER_MARGIN;
            itemvFrame = CGRectMake(locX, locY, itemSize.width+H_INNER_MARGIN, itemSize.height+V_INNER_MARGIN);
        }
        locX += H_SPACE + itemSize.width + H_INNER_MARGIN;
        
        itemv.frame = itemvFrame;
        [self addSubview:itemv];
    }
    
    [self setContentSize:CGSizeMake(contSize.width, locY)];
    
}

- (void) clean {
    for (UIView *uv in [self subviews]) {
        [uv removeFromSuperview];
    }
}

- (void) onItemClick:(id)sender {
    FoodItemView *item = (FoodItemView*)[sender superview];
    self.onItemClick(item.managedObject);
}

@end
