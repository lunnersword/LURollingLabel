//
//  LURollingLabel.h
//  LURollingLabel
//
//  Created by 永超 沈 on 5/17/16.
//  Copyright © 2016 永超 沈. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for LURollingLabel.
FOUNDATION_EXPORT double LURollingLabelVersionNumber;

//! Project version string for LURollingLabel.
FOUNDATION_EXPORT const unsigned char LURollingLabelVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <LURollingLabel/PublicHeader.h>


@interface LURollingLabel : UIView

@property (nonatomic, strong) NSArray<NSString *> *texts;
@property (nonatomic, strong) NSArray<NSAttributedString *> *attributedTexts;
@property (nonatomic, assign) CGFloat rollSpeed; //default is 77;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, assign) CGFloat innerGap;
@property (nonatomic, assign) NSUInteger repeatCount;
@property (nonatomic, assign) BOOL rollingAnyway;

@property (nonatomic, readonly) BOOL isRolling;

- (void)start;

@end