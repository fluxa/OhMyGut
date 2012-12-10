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
#import "FoodViewController.h"

@interface DietViewController ()

@property (nonatomic,assign) BOOL renderEating;
@property (nonatomic,assign) BOOL renderAll;

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
	self.renderEating = YES;
    if ([[Data shared].myDiets count] == 0) {
        [self performSegueWithIdentifier:@"settings" sender:nil];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self renderView];
}

- (void) renderView {
    
    if (self.renderEating) {
        self.titleLabel.text = @"What I'm eating";
        [self.renderButton setTitle:@"NOT" forState:UIControlStateNormal];
    } else {
        self.titleLabel.text = @"What I'm NOT eating";
        [self.renderButton setTitle:@"YES" forState:UIControlStateNormal];
    }
    
    NSMutableDictionary *filtered = [[Data shared] getFilteredFoodGroups];
    NSMutableArray *items = [NSMutableArray array];
    int duplaIndex = self.renderEating ? 0 : 1;
    
    for (FoodGroup *fg in [[Data shared] getFoodGroups]) {
        NSArray *dupla = [filtered objectForKey:fg.gid];
        //0 yeah can
        //1 cannot
        if (self.renderEating) {
            if ([dupla[duplaIndex] count] > 0) {
                [items addObject:fg];
            }
        } else {
            if ([dupla[duplaIndex] count] > 0) {
                [items addObject:fg];
            }
        }
    }
    
    if (self.renderAll) {
        //render foods in groups
        NSMutableArray *foods = [NSMutableArray array];
        for (FoodGroup *fg in items) {
            NSArray *fs = [[[[Data shared] getFilteredFoodGroups] objectForKey:fg.gid] objectAtIndex:duplaIndex];
            [foods addObjectsFromArray:fs];
        }
        self.scrollView.items = foods;
        [self.scrollView render];
        [self.scrollView setOnItemClick:^(NSManagedObject* obj){
            Food *food = (Food*)obj;
            [self performSegueWithIdentifier:@"food" sender:food];
        }];
    } else {
        //render just groups
        self.scrollView.items = items;
        [self.scrollView render];
        [self.scrollView setOnItemClick:^(NSManagedObject* obj){
            FoodGroup *fg = (FoodGroup*)obj;
            [self performSegueWithIdentifier:@"group" sender:fg];
        }];
    }
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"group"]) {
        GroupViewController *gvc = segue.destinationViewController;
        gvc.renderEating = self.renderEating;
        gvc.foodGroup = sender;
    } else if ([segue.identifier isEqualToString:@"food"]) {
        FoodViewController *fvc = segue.destinationViewController;
        fvc.food = sender;
    }
    
}

- (IBAction)onSettings:(id)sender {
    [self performSegueWithIdentifier:@"settings" sender:nil];
}

- (IBAction)onRender:(id)sender {
    
    self.renderEating = !self.renderEating;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [self renderView];
    }];
}

- (IBAction)onRenderAll:(id)sender {
    self.renderAll = !self.renderAll;
    [self.renderAllButton setTitle:self.renderAll ? @"Groups" : @"Foods" forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [self renderView];
    }];
}

@end
