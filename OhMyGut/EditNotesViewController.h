//
//  EditNotesViewController.h
//  OhMyGut
//
//  Created by Juan-Manuel Fluxá on 12/5/12.
//  Copyright (c) 2012 Fluxa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface EditNotesViewController : UIViewController

@property (nonatomic,strong) Food *food;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,weak) IBOutlet UITextView *textView;

@end
