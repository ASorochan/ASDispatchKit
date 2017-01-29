//
//  ASDispatchGroup.m
//  ASDispatchKit
//
//  Created by Anatoly on 29.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

#import "ASDispatchGroup.h"



@interface ASDispatchGroup()
@property(nonatomic, strong) dispatch_group_t dispatchGroup;

@end

@implementation ASDispatchGroup


-(instancetype) init {
    self = [super init];
    if (self) {
        self.dispatchGroup = dispatch_group_create();
    }
    return self;
}
/*!
 Explicitly indicates that a block has entered the group.
 @see dispatch_group_enter() for more information.
*/
-(void) enter {
    dispatch_group_enter(self.dispatchGroup);
}
/*!
 Explicitly indicates that a block in the group has completed.
 @see dispatch_group_leave() for more information.
 */
-(void) leave {
    dispatch_group_leave(self.dispatchGroup);
}
/*!
 Waits forever for the previously submitted blocks in the group to complete.
 @see dispatch_group_wait() for more information.
 */
-(void) wait {
    dispatch_group_wait(self.dispatchGroup, DISPATCH_TIME_FOREVER);
}
/*!
 Schedules a block object to be submitted to a queue when a group
 of previously submitted block objects have completed.
 @see dispatch_group_notify() for more information.
 
*/
-(void) notifyInQueue:(ASDispatchQueue*)queue execute:(ASDispatchQueueExecutionBlock)block {
    
    dispatch_group_notify(self.dispatchGroup, [queue dispatchQueue] , block);
}



@end
