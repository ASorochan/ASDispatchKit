//
//  ASDispatchQueue.h
//  ASDispatchKit
//
//  Created by Anatoly on 28.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ASDispatchQueueExecutionBlock)(void);

@interface ASDispatchQueue : NSObject




+(ASDispatchQueue*) mainQueue;
+(ASDispatchQueue*) globalQueue;
+(ASDispatchQueue*) highPriorityGlobalQueue;
+(ASDispatchQueue*) lowPriorityGlobalQueue;
+(ASDispatchQueue*) backgroundPriorityGlobalQueue;

-(instancetype) init;
-(instancetype) initSerial;
-(instancetype) initConcurrent;

-(instancetype) initWithLabel:(NSString*) label;
-(instancetype) initSerialWithLabel:(NSString*)label;
-(instancetype) initConcurrentWithLabel:(NSString*)label;


-(void) execute:(ASDispatchQueueExecutionBlock)block;

+(void) executeInMainQueue:(ASDispatchQueueExecutionBlock)block;
+(void) executeInBackgroundQueue:(ASDispatchQueueExecutionBlock)block;


-(NSString*) label;
-(dispatch_queue_t) dispatchQueue;


@end
