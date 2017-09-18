//
//  ClassMomentCell.h
//  FaceShowApp
//
//  Created by 郑小龙 on 2017/9/14.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassMomentCell : UITableViewCell
- (void)reloadName:(NSString *)nameString
       withComment:(NSString *)commentString
          withLast:(BOOL)isLast;
@end
