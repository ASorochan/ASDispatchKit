//
//  ASDispatchQueue.m
//  ASDispatchKit
//
//  Created by Anatoly on 28.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

#import "ASDispatchQueue.h"


static ASDispatchQueue* mainQueue;
static ASDispatchQueue *globalQueue;
static ASDispatchQueue *highPriorityGlobalQueue;
static ASDispatchQueue *lowPriorityGlobalQueue;
static ASDispatchQueue *backgroundPriorityGlobalQueue;



@interface ASDispatchQueue()

@property(nonatomic, strong) dispatch_queue_t dispatchQueue;
@property(nonatomic, strong) NSString* label;
@property(nonatomic, assign) BOOL isConcurrent;

@end


@implementation ASDispatchQueue


+(void)initialize {
    
    if (self == [ASDispatchQueue class]) {
        mainQueue = [[ASDispatchQueue alloc] initWithGCDQueue:dispatch_get_main_queue()];
        
        globalQueue = [[ASDispatchQueue alloc] initWithGCDQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
        
        highPriorityGlobalQueue = [[ASDispatchQueue alloc] initWithGCDQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
        
        lowPriorityGlobalQueue = [[ASDispatchQueue alloc] initWithGCDQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
        
        backgroundPriorityGlobalQueue = [[ASDispatchQueue alloc] initWithGCDQueue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@>", self.label];
}

#pragma mark - Class Methods
/*!
 Returns the serial dispatch queue associated with the application’s main thread.
 
 @return The main queue. This queue is created automatically on behalf of the main thread before main is called.
 @see dispatch_get_main_queue()
 */
+(ASDispatchQueue*) mainQueue {
    return mainQueue;
}
/*!
 Returns the default priority global concurrent queue.
 
 @return Default priority global queue.
 @see dispatch_get_global_queue()
 */
+(ASDispatchQueue*) globalQueue {
    return globalQueue;
}

/*!
 Returns the high priority global concurrent queue.
 
 @return High priority global queue.
 @see dispatch_get_global_queue()
 */

+(ASDispatchQueue*) highPriorityGlobalQueue {
    return highPriorityGlobalQueue;
}

/*!
 Returns the low priority global concurrent queue.
 
 @return Low priority global queue.
 @see dispatch_get_global_queue()
 */

+(ASDispatchQueue*) lowPriorityGlobalQueue {
    return lowPriorityGlobalQueue;
}

/*!
 Returns the background priority global concurrent queue.
 
 @return Background priority global queue.
 @see dispatch_get_global_queue()
 */

+(ASDispatchQueue*) backgroundPriorityGlobalQueue {
    return backgroundPriorityGlobalQueue;
}

#pragma mark - Initialization

/*!
 Initializes a new serial queue.
 @return An initialized object.
 @see dispatch_queue_create()
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString* label = [self defaultQueueLabel];
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.label = label;
    }
    return self;
}

/*!
 Initializes a new serial queue.
 @return An initialized object.
 @see dispatch_queue_create()
 */

-(instancetype) initSerial {
    self = [super init];
    if (self) {
        NSString* label = [self defaultQueueLabel];
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.label = label;
    }
    return self;
}

/*!
 Initializes a new concurrent queue.
 @return An initialized object.
 @see dispatch_queue_create()
 */

-(instancetype) initConcurrent {
    self = [super init];
    if (self) {
        NSString* label = [self defaultQueueLabel];
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.label = label;
    }
    return self;
}

/*!
 Initializes a new serial queue with specified label.
 
 @b Listing 1
 @code
 ASDispatchQueue* queue = [[ASDispatchQueue alloc] initWithLabel:@"com.YOUR-COMPANY-IDENTIFIER"];
 @endcode
 @return An initialized object.
 @see dispatch_queue_create()
 */

-(instancetype) initWithLabel:(NSString*) label {
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.label = label;
    }
    return self;
}

/*!
 Initializes a new serial queue with specified label.
 
 @b Listing 1
 @code
 ASDispatchQueue* queue = [[ASDispatchQueue alloc] initSerialWithLabel:@"com.YOUR-COMPANY-IDENTIFIER"];
 @endcode
 @return An initialized object.
 @see dispatch_queue_create()
 */

-(instancetype) initSerialWithLabel:(NSString*)label {
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.label = label;
    }
    return self;
}

/*!
 Initializes a new concurrent queue with specified label.
 
 @b Listing 1
 @code
 ASDispatchQueue* queue = [[ASDispatchQueue alloc] initConcurrentWithLabel:@"com.YOUR-COMPANY-IDENTIFIER"];
 @endcode
 @return An initialized object.
 @see dispatch_queue_create()
 */

-(instancetype) initConcurrentWithLabel:(NSString*)label {
    self = [super init];
    if (self) {
        self.dispatchQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_CONCURRENT);
        self.label = label;
    }
    return self;
}

/*!
 Executes asynchronously in specified queue.
 @b Then
 @code
 dispatch_async(dispatch_queue_create("com.YOUR-COMPANY-IDENTIFIER", DISPATCH_QUEUE_CONCURRENT), ^{
    //Some execution.
 });
 @endcode
 @b Now
 @code 
 ASDispatchQueue* queue = [[ASDispatchQueue alloc] initConcurrentWithLabel:@"com.YOUR-COMPANY-IDENTIFIER"];
 [queue execute:^{
    //Some execution.
 }];
 @endcode
 @see dispatch_async()
 */

-(void) execute:(ASDispatchQueueExecutionBlock)block {
    dispatch_async(self.dispatchQueue, block);
}

/*!
 Executes asynchronously in main queue.
 
 @b Then
 @code
 dispatch_async(dispatch_get_main_queue(), ^{
    //Some execution.
 });
 @endcode
 @b Now
 @code
 [[ASDispatchQueue mainQueue] execute:^{
    //Some execution.
 }];
 @endcode
 @see dispatch_async()
 */
+(void) executeInMainQueue:(ASDispatchQueueExecutionBlock)block {
    dispatch_async(mainQueue.dispatchQueue, block);
}

/*!
 Executes asynchronously in background queue.
 
 @b Then
 @code
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    //Some execution.
 });
 @endcode
 @b Now
 @code
 [ASDispatchQueue executeInBackgroundQueue:^{
    //Some execution.
 }];
 @endcode
 @see dispatch_async()
 */

+(void) executeInBackgroundQueue:(ASDispatchQueueExecutionBlock)block {
    dispatch_async(backgroundPriorityGlobalQueue.dispatchQueue, block);
}
/*!
 Returns label for specified queue.
 @return Label for specified queue.
 */
-(NSString*) label {
    return self.label;
}
/*!
 Returns dispatch queue.
 @return Dispatch queue.
 @warning Do not use this method.
 */
-(dispatch_queue_t) dispatchQueue {
    return self.dispatchQueue;
}

#pragma mark - Private API

-(instancetype) initWithGCDQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (self) {
        self.dispatchQueue = queue;
        self.label = @(dispatch_queue_get_label(queue));
    }
    return self;
}

-(NSString*) defaultQueueLabel {
    NSUInteger timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString* label = [NSString stringWithFormat:@"ASDispatchQueue : %zd", timestamp];
    return label;
}

@end
