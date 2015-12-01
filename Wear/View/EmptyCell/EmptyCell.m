//
//  EmptyCell.m
//  Wear
//
//  Created by 孙恺 on 15/10/11.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "EmptyCell.h"
#import "SKChromatography.h"

@implementation EmptyCell

- (void)awakeFromNib {
    // Initialization code
//    [self insertTransparentGradientWithColor:self.backgroundColor alphaStart:self.alpha];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Transparent Gradient Layer
- (void) insertTransparentGradientWithColor:(UIColor *)color alphaStart:(CGFloat)alphaStart {
    UIColor *colorOne = [UIColor colorWithRed:(33/255.0)  green:(33/255.0)  blue:(33/255.0)  alpha:0.0];
    UIColor *colorTwo = [color colorWithAlphaComponent:alphaStart];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorTwo.CGColor, colorOne.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:alphaStart];
    NSArray *locations = [NSArray arrayWithObjects:stopTwo, stopOne, nil];
    
    //crate gradient layer
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = self.bounds;
    
    [self.layer insertSublayer:headerLayer atIndex:0];
}

@end
