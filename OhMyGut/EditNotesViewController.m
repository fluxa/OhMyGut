//
//  EditNotesViewController.m
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/5/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import "EditNotesViewController.h"
#import "Data.h"

@interface EditNotesViewController () <UITextViewDelegate>

@end

@implementation EditNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titleLabel.text = self.food.name;
    self.textView.text = self.food.notes;
    [self.textView becomeFirstResponder];
}

- (IBAction)onDone:(id)sender {
    self.food.notes = self.textView.text;
    NSError *error;
    [[Data shared].managedObjectContext save:&error];
    [self.textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
