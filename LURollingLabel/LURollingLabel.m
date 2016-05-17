//
//  LURollingLabel.m
//  CoreAnimationTest
//
//  Created by 永超 沈 on 5/13/16.
//  Copyright © 2016 永超 沈. All rights reserved.
//

#import "LURollingLabel.h"

@interface LURollingLabel ()

@property (nonatomic, readonly) BOOL needRolling;
@property (nonatomic, strong) NSMutableArray<UILabel *> *labels;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation LURollingLabel (CircleArray)

- (UILabel *)getLabel {
    UILabel *label = self.labels.firstObject;
    [self.labels removeObjectAtIndex:0];
    [self.labels addObject:label];
    return label;
}

@end

@implementation LURollingLabel

@synthesize textColor = _textColor;
@synthesize textFont = _textFont;

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _rollSpeed = 77;
        _innerGap = 20.0;
        _edgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        //        self.leftView = [UIView new];
        //        self.leftView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        self.rightView = [UIView new];
        //        self.rightView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //        [self addSubview:self.leftView];
        //        [self addSubview:self.rightView];
        self.scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.scrollView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suspend)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startRolling:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    self.leftView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //    self.rightView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)start {
    
    if (self.needRolling) {
        self.scrollView.scrollEnabled = NO;
        __weak typeof (self) weakSelf = self;
        [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
            [label.layer removeAllAnimations];
            [weakSelf addAnimationToLabel:label];
        }];
        //        [self addLabelsToRollingView];
        //        [self rollingTheLabels];
    }
}

//- (void)rollingTheLabels {
////    CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
////    moveAnimation.duration = self.frame.size.width / self.rollSpeed;
////    moveAnimation.values = @[@0.0, @(-self.frame.size.width)];
////    moveAnimation.repeatCount = self.repeatCount == 0 ? NSUIntegerMax : self.repeatCount;
////    moveAnimation.calculationMode = kCAAnimationLinear;
////    moveAnimation.delegate = self;
////    [self.leftView.layer addAnimation:moveAnimation forKey:@"rolling"];
////    [self.rightView.layer addAnimation:moveAnimation forKey:@"rolling"];
//    CGRect originRight = self.rightView.frame;
//    [UIView animateWithDuration:self.frame.size.width / self.rollSpeed animations:^{
//        CGRect leftFrame = self.leftView.frame;
//        leftFrame.origin.x = leftFrame.origin.x - leftFrame.size.width;
//        self.leftView.frame = leftFrame;
//        CGRect rightFrame = self.rightView.frame;
//        rightFrame.origin.x = rightFrame.origin.x - rightFrame.size.width;
//        self.rightView.frame = rightFrame;
//    } completion:^(BOOL success) {
//        self.leftView.frame = originRight;
//        [self switchLeftAndRight];
//        [self addLabelsToRightView:0];
//        [self rollingTheLabels];
//    }];
//
//}



//- (void)switchLeftAndRight {
//    UIView *left = self.leftView;
//    self.leftView = self.rightView;
//    self.rightView = left;
//}


//
//- (void)addLabelsToRollingView {
//    [self addLabelsToLeftView];
//    UIView *lastView = (UIView *)self.leftView.subviews.lastObject;
//    CGFloat offsetX = lastView.frame.origin.x + lastView.frame.size.width - self.leftView.frame.size.width + self.innerGap;
//    [self addLabelsToRightView:offsetX];
//}
//
//- (void)addLabelsToLeftView {
//    CGFloat offsetX = 0.0;
//    [self.leftView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    while ((self.leftView.frame.size.width - offsetX) > 0) {
//        UILabel *label = [self getLabel];
//        CGRect frame = label.frame;
//        frame.origin.x = offsetX;
//        label.frame = frame;
//        [label sizeToFit];
//        [self.leftView addSubview:label];
//        offsetX += self.innerGap + label.frame.size.width;
//    }
//}
//
//- (void)addLabelsToRightView:(CGFloat)offsetX {
//    [self.rightView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    while (offsetX < self.rightView.frame.size.width) {
//        UILabel *label = [self getLabel];
//        CGRect frame = label.frame;
//        frame.origin.x = offsetX;
//        label.frame = frame;
//        [label sizeToFit];
//        [self.rightView addSubview:label];
//        offsetX += self.innerGap + label.frame.size.width;
//    }
//}

- (void)stop {
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        [label.layer removeAllAnimations];
    }];
    self.scrollView.scrollEnabled = YES;
}

- (void)suspend {
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        CFTimeInterval pausedTime = [label.layer convertTime:CACurrentMediaTime() toLayer:nil];
        label.layer.speed = 0.0;
        label.layer.timeOffset = pausedTime;
        //        CGPoint position = ((CALayer *)label.layer.presentationLayer).position;
        //        label.layer.position = position;
    }];
    //self.scrollView.scrollEnabled = YES;
}

- (void)startRolling:(UIGestureRecognizer *)swipe {
    [self resume];
}

- (void)resume {
    self.scrollView.scrollEnabled = NO;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        CFTimeInterval pausedTime = [label.layer timeOffset];
        label.layer.speed = 1.0;
        label.layer.timeOffset = 0.0;
        label.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [label.layer convertTime:CACurrentMediaTime() toLayer:nil] - pausedTime;
        label.layer.beginTime = timeSincePause;
    }];
    
}

- (BOOL)isRolling {
    BOOL __block isRolling = NO;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        if ([label.layer animationForKey:@"rolling"] && label.layer.speed != 0.0) {
            isRolling = YES;
        }
    }];
    return isRolling;
}

- (void)addAnimationToLabel:(UILabel *)label {
    CAKeyframeAnimation *frameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    CGFloat prefix = label.frame.origin.x;
    CGFloat width = label.frame.size.width;
    CGPoint lastPoint = [(NSValue *)[self getLabelOriginXsAndWidths].lastObject CGPointValue];
    CGFloat suffix = lastPoint.x + lastPoint.y - prefix - width;
    CGFloat length = prefix + width + suffix + self.innerGap;
    frameAnimation.keyTimes = @[@0.0, @((prefix + width)/ length), @((prefix + width)/ length), @1.0];
    frameAnimation.duration = length / self.rollSpeed;
    frameAnimation.values = @[@0.0, @(-prefix - width), @(suffix + self.innerGap), @0.0];
    frameAnimation.repeatCount = self.repeatCount == 0 ? NSUIntegerMax : self.repeatCount;
    frameAnimation.calculationMode = kCAAnimationLinear;
    frameAnimation.fillMode = kCAFillModeBackwards;
    [label.layer addAnimation:frameAnimation forKey:@"rolling"];
    
}

//- (void)moveLabelToLeft:(UILabel *)label {
//    CGFloat prefix = label.frame.origin.x;
//    CGFloat width = label.frame.size.width;
//    CGPoint lastPoint = [(NSValue *)[self getLabelOriginXsAndWidths].lastObject CGPointValue];
//    CGFloat suffix = lastPoint.x + lastPoint.y - prefix - width;
//    CGFloat length = prefix + width + suffix + width + self.innerGap;
//    [UIView animateWithDuration:(prefix + width)/length animations:^{
//        CGRect frame = label.frame;
//        frame.origin.x = label.frame.origin.x - (prefix + width);
//        label.frame = frame;
//    } completion:^{
//        label.frame.origin.x =
//    }]
//}

- (BOOL)needRolling {
    NSArray<NSValue *> *widths = [self getLabelOriginXsAndWidths];
    if (widths && widths.count > 0) {
        CGPoint point =  [(NSValue *)widths.lastObject CGPointValue];
        CGFloat width = point.x + point.y;
        if (width > self.frame.size.width) {
            if (self.rollingAnyway) {
                return YES;
            }
            for (NSValue *value in widths) {
                point = [value CGPointValue];
                if (width - point.y + self.innerGap < self.frame.size.width) {
                    return NO;
                }
            }
            return YES;
        }
    }
    return NO;
}


- (NSArray<NSValue *> *)getLabelOriginXsAndWidths {
    NSMutableArray *array = [NSMutableArray array];
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        CGPoint point;
        point.x = label.frame.origin.x;
        point.y = label.frame.size.width;
        NSValue *value = [NSValue valueWithCGPoint:point];
        [array addObject:value];
    }];
    return array.copy;
}

- (void)updateContents {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.labels removeAllObjects];
    CGFloat __block offsetx = 0;
    if (self.attributedTexts && self.attributedTexts.count > 0) {
        __weak typeof(self) weakSelf = self;
        [self.attributedTexts enumerateObjectsUsingBlock:^(NSAttributedString *_Nonnull text, NSUInteger index, BOOL *stop) {
            UILabel *label = [weakSelf getLabelWithText:nil attributedText:text];
            label.frame = CGRectMake(offsetx, weakSelf.edgeInsets.top, 0, 0);
            [label sizeToFit];
            [weakSelf.labels addObject:label];
            //[weakSelf.leftView addSubview:label];
            [weakSelf.scrollView addSubview:label];
            offsetx += weakSelf.innerGap + label.bounds.size.width;
        }];
    } else {
        __weak typeof (self) weakSelf = self;
        [self.texts enumerateObjectsUsingBlock:^(NSString * _Nonnull text, NSUInteger index, BOOL *stop) {
            UILabel *label = [weakSelf getLabelWithText:text attributedText:nil];
            label.frame = CGRectMake(offsetx, weakSelf.edgeInsets.top, 0, 0);
            [label sizeToFit];
            [weakSelf.labels addObject:label];
            //[weakSelf.leftView addSubview:label];
            [weakSelf.scrollView addSubview:label];
            offsetx += weakSelf.innerGap + label.bounds.size.width;
        }];
    }
    self.scrollView.contentSize = CGSizeMake(offsetx, self.scrollView.frame.size.height);
    
}

- (UILabel *)getLabelWithText:(NSString *)text attributedText:(NSAttributedString *)attrText {
    UILabel *label = [UILabel new];
    if (attrText) {
        label.attributedText = attrText;
        
    } else {
        label.text = text;
    }
    label.font = self.textFont;
    label.textColor = self.textColor;
    return label;
    
}

- (void)updateLabelColors {
    __weak typeof (self) weakSelf = self;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        label.textColor = weakSelf.textColor;
    }];
}

- (void)updateLabelFonts {
    __weak typeof (self) weakSelf = self;
    [self.labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger index, BOOL *stop) {
        label.font = weakSelf.textFont;
    }];
}

- (UIColor *)textColor {
    return [UIColor blackColor];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self updateLabelColors];
}

- (UIFont *)textFont {
    return [UIFont systemFontOfSize:15];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self updateLabelFonts];
}

- (void)setTexts:(NSArray<NSString *> *)texts {
    _texts = texts;
    [self updateContents];
}

- (void)setAttributedTexts:(NSArray<NSAttributedString *> *)attributedTexts {
    [self updateContents];
}

- (NSMutableArray<UILabel *> *)labels {
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
    }
    return _scrollView;
}


@end