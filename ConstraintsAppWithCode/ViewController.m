//
//  ViewController.m
//  ConstraintsAppWithCode
//
//  Created by Алексей on 28.06.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    BOOL isRedViewSmall;
    BOOL isBlueViewSmall;
}

@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIButton *redViewButton;
@property (weak, nonatomic) IBOutlet UIButton *blueViewButton;

@property (strong, nonatomic) NSMutableArray *sharedConstraints;
@property (strong, nonatomic) NSMutableArray *compactConstraints;
@property (strong, nonatomic) NSMutableArray *regularConstraints;

@property (weak, nonatomic) NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) NSLayoutConstraint *widthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isRedViewSmall = NO;
    isBlueViewSmall = NO;
    
    [self.redViewButton addTarget:nil action:@selector(redViewButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.blueViewButton addTarget:nil action:@selector(blueViewButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self addConstraints];
}

- (void)redViewButtonTapped {
    
    CGFloat metrics;
    CGFloat constant;
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        metrics = self.view.bounds.size.height;
    } else {
        metrics = self.view.bounds.size.width;
    }
    
    if (isRedViewSmall) {
        constant = 0;
        isRedViewSmall = NO;
    } else if (!isRedViewSmall && isBlueViewSmall) {
        constant = -metrics / 3;
        isRedViewSmall = YES;
        isBlueViewSmall = NO;
    } else {
        constant = -metrics / 3;
        isRedViewSmall = YES;
    }
    
    self.heightConstraint.constant = constant;
    self.widthConstraint.constant = constant;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
    
}

-(void)blueViewButtonTapped {
    
    CGFloat metrics;
    CGFloat constant;
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        metrics = self.view.bounds.size.height;
    } else {
        metrics = self.view.bounds.size.width;
    }
    
    if (isBlueViewSmall) {
        constant = 0;
        isBlueViewSmall = NO;
    } else if (!isBlueViewSmall && isRedViewSmall) {
        constant = metrics / 3;
        isBlueViewSmall = YES;
        isRedViewSmall = NO;
    } else {
        constant = metrics / 3;
        isBlueViewSmall = YES;
    }
    
    self.heightConstraint.constant = constant;
    self.widthConstraint.constant = constant;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

-(void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    
    if (newCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
        [NSLayoutConstraint deactivateConstraints:self.regularConstraints];
        
        CGFloat constant = 0;
        
        if (isRedViewSmall) {
            constant -=  self.view.bounds.size.width / 3;
        } else if (isBlueViewSmall) {
            constant +=  self.view.bounds.size.width / 3;
        }
        
        self.heightConstraint.constant = constant;
    } else {
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
        [NSLayoutConstraint deactivateConstraints:self.compactConstraints];
    }
}

-(void)addConstraints {
    self.redView.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueView.translatesAutoresizingMaskIntoConstraints = NO;
    self.redViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueViewButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    _compactConstraints = [[NSMutableArray alloc] init];
    _sharedConstraints = [[NSMutableArray alloc] init];
    _regularConstraints = [[NSMutableArray alloc] init];
    
    // Buttons constraints
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.redViewButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.redView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.redViewButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.redView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueViewButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.blueView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueViewButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.blueView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    // Views shared constraints
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:40]];
    
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:40]];
    
    [self.sharedConstraints addObject: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.blueView attribute:NSLayoutAttributeBottom multiplier:1 constant:40]];
    
    // Views constraints in compact width
    [self.compactConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.redView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.compactConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redView attribute:NSLayoutAttributeBottom multiplier:1 constant:40]];
    
    [self.compactConstraints addObject: [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.compactConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    _heightConstraint = [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.blueView attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.compactConstraints addObject: self.heightConstraint];
    
    // Views constraints in regular width
    [self.regularConstraints addObject: [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.regularConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self.regularConstraints addObject: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.blueView attribute:NSLayoutAttributeTrailing multiplier:1 constant:40]];
    
    [self.regularConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.redView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    [self.regularConstraints addObject: [NSLayoutConstraint constraintWithItem:self.blueView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.redView attribute:NSLayoutAttributeTrailing multiplier:1 constant:40]];
    
    _widthConstraint = [NSLayoutConstraint constraintWithItem:self.redView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.blueView attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.regularConstraints addObject: self.widthConstraint];
    
    [NSLayoutConstraint activateConstraints:self.sharedConstraints];
    
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        [NSLayoutConstraint activateConstraints:self.compactConstraints];
    } else {
        [NSLayoutConstraint activateConstraints:self.regularConstraints];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
