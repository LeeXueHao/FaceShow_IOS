//
//  UITableView+TemplateLayoutHeaderView.m
//  TrainApp
//
//  Created by 郑小龙 on 16/11/24.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "UITableView+TemplateLayoutHeaderView.h"
#import <objc/runtime.h>
@implementation UITableView (TemplateLayoutHeaderView)
- (__kindof UITableViewHeaderFooterView *)yx_templateHeaderForReuseIdentifier:(NSString *)identifier {
    NSAssert(identifier.length > 0, @"Expect a valid identifier - %@", identifier);
    
    NSMutableDictionary<NSString *, __kindof UITableViewHeaderFooterView *> *templateHeaderByIdentifiers = objc_getAssociatedObject(self, _cmd);
    if (!templateHeaderByIdentifiers) {
        templateHeaderByIdentifiers = @{}.mutableCopy;
        objc_setAssociatedObject(self, _cmd, templateHeaderByIdentifiers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    UITableViewHeaderFooterView *templateHeader = templateHeaderByIdentifiers[identifier];
    
    if (!templateHeader) {
        templateHeader = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
        NSAssert(templateHeader != nil, @"Cell must be registered to table view for identifier - %@", identifier);
        templateHeader.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        templateHeaderByIdentifiers[identifier] = templateHeader;
    }
    return templateHeader;
}

- (CGFloat)yx_heightForHeaderWithIdentifier:(NSString *)identifier configuration:(void (^)(id header))configuration {
    if (!identifier) {
        return 0;
    }
    
    UITableViewHeaderFooterView *templateLayoutHeader = [self yx_templateHeaderForReuseIdentifier:identifier];
    [templateLayoutHeader prepareForReuse];
    if (configuration) {
        configuration(templateLayoutHeader);
    }
    
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    CGSize fittingSize = CGSizeZero;
    if (contentViewWidth > 0) {
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:templateLayoutHeader.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        [templateLayoutHeader.contentView addConstraint:widthFenceConstraint];
        fittingSize = [templateLayoutHeader.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [templateLayoutHeader.contentView removeConstraint:widthFenceConstraint];
    }
    if (self.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingSize.height += 1.0 / [UIScreen mainScreen].scale;
    }
    return fittingSize.height;
}

@end
