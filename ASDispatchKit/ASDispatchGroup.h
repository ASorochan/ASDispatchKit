//
//  ASDispatchGroup.h
//  ASDispatchKit
//
//  Created by Anatoly on 29.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASDispatchQueue.h"

@interface ASDispatchGroup : NSObject


-(void) enter;
-(void) leave;
-(void) wait;
-(void) notifyInQueue:(ASDispatchQueue*)queue execute:(ASDispatchQueueExecutionBlock)block;


@end
