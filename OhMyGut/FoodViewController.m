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
#import "DietItemRenderer.h"

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
    self.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"food_%d.jpg",self.food.foodid.intValue]];
    
    int i = 0;
    int posY = 0;
    for (Diet *diet in [[Data shared] getDiets]) {
        
        DietItemRenderer *d = [[[NSBundle mainBundle] loadNibNamed:@"DietItemRenderer" owner:self options:nil] objectAtIndex:0];
        d.diet = diet;
        d.state = [[self.food valueForKey:diet.dietid] boolValue] ? 1 : 0;
        
        if (i%2==0) {
            d.frame = CGRectMake(320/2 + 10, posY, d.frame.size.width, d.frame.size.height);
        } else {
            d.frame = CGRectMake(10, posY, d.frame.size.width, d.frame.size.height);
            posY += d.frame.size.height + 3;
        }
        
        [self.dietView addSubview:d];
        
        i++;
    }
    
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
