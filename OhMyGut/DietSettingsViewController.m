//
//  DietSettingsViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/1/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "DietSettingsViewController.h"
#import "DietItem.h"
#import "Data.h"
#import "AppDelegate.h"

@interface DietSettingsViewController ()

@end

@implementation DietSettingsViewController

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
    
    int posY = 0;
    for (Diet *diet in [[Data shared] getDiets]) {
        DietItem *item = [[[NSBundle mainBundle] loadNibNamed:@"DietItem" owner:self options:nil] objectAtIndex:0];
        item.dietID = diet.dietid;
        CGRect f = CGRectMake(0, posY, 320, 60);
        item.frame = f;
        [self.scrollView addSubview:item];
        posY += 5 + 60;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onLeftButton:(id)sender {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app toggleLeftPanel];
}

@end
