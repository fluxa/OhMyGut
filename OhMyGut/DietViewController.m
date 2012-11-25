//
//  DietViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//


#import "DietViewController.h"
#import "Food.h"
#import "FoodGroup.h"
#import "Data.h"
#import "FoodItemView.h"
#import "GroupViewController.h"

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
	
    NSArray *items = [[Data shared] getFoodGroups];
    self.scrollView.items = items;
    [self.scrollView render];
    [self.scrollView setClickBlock:^(NSManagedObject* obj){
        FoodGroup *fg = (FoodGroup*)obj;
        [self performSegueWithIdentifier:@"group" sender:fg];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    GroupViewController *gvc = segue.destinationViewController;
    gvc.foodGroup = sender;
}


@end
