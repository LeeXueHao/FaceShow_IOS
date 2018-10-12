//
//  CertificateCell.h
//  FaceShowApp
//
//  Created by SRT on 2018/9/22.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineCertiRequest_Item_userCertList;
@interface CertificateCell : UITableViewCell
@property (nonatomic, strong) MineCertiRequest_Item_userCertList *elements;
@property (nonatomic, assign) BOOL isLastRow;
- (void)setPointHidden;
@end

