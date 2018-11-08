//
//  MeetingListViewController.h
//  FaceShowApp
//
//  Created by SRT on 2018/11/7.
//  Copyright © 2018年 niuzhaowang. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshDelegate.h"

@interface MeetingListViewController : BaseViewController<RefreshDelegate>
- (instancetype)initWithClazsId:(NSString *)clazsId;
@end

