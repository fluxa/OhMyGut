//
//  DietViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DietViewController.h"
#import "Food.h"
#import "FoodGroup.h"
#import "Data.h"
#import "FoodItemView.h"

#define V_MARGIN 5
#define H_MARGIN 5
#define V_SPACE 5
#define H_SPACE 5
#define H_INNER_MARGIN 15
#define V_INNER_MARGIN 10

@interface DietViewController ()

@end

@implementation DietViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self render];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) render {
    
    [self clean];
    
    int locX = H_MARGIN;
    int locY = V_MARGIN;
    CGSize contSize = CGSizeMake(310, 400);
    
    for (FoodGroup *foodg in [[Data shared] getFoodGroups]) {
        
        FoodItemView *itemv = [[[NSBundle mainBundle] loadNibNamed:@"FoodItemView" owner:self options:nil]
                               objectAtIndex:0];
        
        [itemv.button setTitle:foodg.name forState:UIControlStateNormal];
        
        UIImage *itemBG;
        switch ([foodg.state intValue]) {
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
        
        CGSize itemSize = [foodg.name sizeWithFont:itemv.button.titleLabel.font];
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
        [self.scrollView addSubview:itemv];
    }
    
    [self.scrollView setContentSize:CGSizeMake(contSize.width, locY)];
    
}

- (void) clean {
    for (UIView *uv in [self.scrollView subviews]) {
        [uv removeFromSuperview];
    }
}

@end
