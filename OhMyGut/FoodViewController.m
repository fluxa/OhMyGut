//
//  FoodViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/2/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "FoodViewController.h"
#import "Data.h"

@interface FoodViewController ()

@end

@implementation FoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.titleLabel.text = self.food.name;
    self.stateControl.selectedSegmentIndex = [self.food.state intValue];
    self.textView.text = self.food.notes;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onBack:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onValueChanged:(id)sender {
    self.food.state = [NSNumber numberWithInt:self.stateControl.selectedSegmentIndex];
    NSError *error = nil;
    [[Data shared].managedObjectContext save:&error];
}


@end
