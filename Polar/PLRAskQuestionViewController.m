//
//  PLRAskQuestionViewController.m
//  Polar
//
//  Created by Derek Cuevas on 12/8/14.
//  Copyright (c) 2014 Derek Cuevas. All rights reserved.
//

#import "PLRAskQuestionViewController.h"

@interface PLRAskQuestionViewController ()
@property (strong, nonatomic) UILabel *placeholder;
@property (strong, nonatomic) NSString *placeholderText;
@end

@implementation PLRAskQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.questionTextView.delegate = self;
    self.placeholderText = @"In English, a special word order (verb–subject–object) is used to form yes–no questions, also known as polar questions...";
    
    CGRect frame = CGRectMake(5, 3, self.view.bounds.size.width - 5, 70);
    self.placeholder = [[UILabel alloc] initWithFrame:frame];
    
    self.placeholder.text = self.placeholderText;
    self.placeholder.numberOfLines = 0;
    self.placeholder.textColor = [UIColor lightGrayColor];
    [self.questionTextView addSubview:self.placeholder];
    [self.questionTextView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeholder.text = self.placeholderText;
    } else {
        self.placeholder.text = @"";
    }
}

@end
