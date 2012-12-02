//
//  GroupViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 11/25/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "GroupViewController.h"
#import "Data.h"
#import "FoodViewController.h"

@interface GroupViewController ()

@end

@implementation GroupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.titleLabel.text = self.foodGroup.name;
    
    int duplaIndex = self.renderEating ? 0 : 1;
    NSArray *foods = [[[[Data shared] getFilteredFoodGroups] objectForKey:self.foodGroup.gid] objectAtIndex:duplaIndex];
    self.scrollView.items = foods;
    __block GroupViewController *safeSelf = self;
    self.scrollView.onItemClick = ^(NSManagedObject *item){
        [safeSelf performSegueWithIdentifier:@"food" sender:item];
    };
    [self.scrollView render];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FoodViewController *fvc = segue.destinationViewController;
    fvc.renderEating = self.renderEating;
    fvc.food = sender;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
