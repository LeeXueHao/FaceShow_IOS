//
//  DownloaderEntity.h
//
//
//  Created by Lei Cai on 5/17/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DownloaderEntity : NSManagedObject

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * type;

@end
