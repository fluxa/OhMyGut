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

@property (nonatomic,assign) BOOL renderEating;

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
    if ([[Data shared].diets count] == 0) {
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
    for (FoodGroup *fg in [[Data shared] getFoodGroups]) {
        NSArray *dupla = [filtered objectForKey:fg.gid];
        //0 yeah can
        //1 cannot
        if (self.renderEating) {
            if ([dupla[0] count] > 0) {
                [items addObject:fg];
            }
        } else {
            if ([dupla[1] count] > 0) {
                [items addObject:fg];
            }
        }
    }
    self.scrollView.items = items;
    [self.scrollView render];
    [self.scrollView setOnItemClick:^(NSManagedObject* obj){
        FoodGroup *fg = (FoodGroup*)obj;
        [self performSegueWithIdentifier:@"group" sender:fg];
    }];
    
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

@end
