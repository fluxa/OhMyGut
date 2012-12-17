//
//  LeftViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/12/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "LeftViewController.h"
#import "DietViewController.h"
#import "SXsViewController.h"
#import "DietSettingsViewController.h"

@interface LeftViewController ()
{
    UINavigationController *_mainVC;
    SXsViewController *_sxsVC;
    DietSettingsViewController *_dietsVC;
}

@end

@implementation LeftViewController

@synthesize deckVC = _deckVC;

- (void) setDeckVC:(IIViewDeckController *)deckVC {
    _deckVC = deckVC;
    
    //init main
    _deckVC.centerController = [self mainVC];
}

- (UINavigationController*) mainVC {
    if (_mainVC == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        DietViewController *mainVC = [sb instantiateViewControllerWithIdentifier:@"MainVC"];
        _mainVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
        _mainVC.navigationBarHidden = YES;
    }
    return _mainVC;
}

- (SXsViewController*) sxsVC {
    if(_sxsVC == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _sxsVC = [sb instantiateViewControllerWithIdentifier:@"SXsVC"];
    }
    return _sxsVC;
}

- (DietSettingsViewController*) dietsVC {
    if (_dietsVC == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _dietsVC = [sb instantiateViewControllerWithIdentifier:@"DietsVC"];
    }
    return _dietsVC;
}

- (IBAction)onEating:(id)sender {
    UINavigationController *mainVC = [self mainVC];
    [mainVC popToRootViewControllerAnimated:NO];
    DietViewController *dvc = (DietViewController*)mainVC.topViewController;
    dvc.renderEating = YES;
    self.deckVC.centerController = nil;
    self.deckVC.centerController = mainVC;
    [self.deckVC closeLeftViewAnimated:YES];
}

- (IBAction)onNotEating:(id)sender {
    UINavigationController *mainVC = [self mainVC];
    [mainVC popToRootViewControllerAnimated:NO];
    DietViewController *dvc = (DietViewController*)mainVC.topViewController;
    dvc.renderEating = NO;
    self.deckVC.centerController = nil;
    self.deckVC.centerController = mainVC;
    [self.deckVC closeLeftViewAnimated:YES];
}

- (IBAction)onDiets:(id)sender {
    self.deckVC.centerController = nil;
    self.deckVC.centerController = [self dietsVC];
    [self.deckVC closeLeftViewAnimated:YES];
}

- (IBAction)onSymptoms:(id)sender {
    self.deckVC.centerController = nil;
    self.deckVC.centerController = [self sxsVC];
    [self.deckVC closeLeftViewAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
