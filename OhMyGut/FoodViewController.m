//
//  FoodViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/2/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "FoodViewController.h"
#import "Data.h"
#import "EditNotesViewController.h"

@interface FoodViewController ()

@end

@implementation FoodViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [self render];
}

- (void) render {
    self.titleLabel.text = self.food.name;
    self.stateControl.selectedSegmentIndex = [self.food.state intValue];
    self.textView.text = self.food.notes;
    
    NSMutableArray *items = [NSMutableArray array];
    for (NSString *dietID in DIETS_IDS) {
        int state = [[self.food valueForKey:dietID] boolValue] ? 0 : 2;
        NSDictionary *item = @{@"name":dietID,@"state":[NSNumber numberWithInt:state]};
        [items addObject:item];
    }
    
    self.scrollView.items = items;
    [self.scrollView render];

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
    [[Data shared] updateDailyFoods];
    NSError *error = nil;
    [[Data shared].managedObjectContext save:&error];
}

- (IBAction)onEdit:(id)sender {
    [self performSegueWithIdentifier:@"editnotes" sender:self.food];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    EditNotesViewController *evc = segue.destinationViewController;
    evc.food = self.food;
}



@end
