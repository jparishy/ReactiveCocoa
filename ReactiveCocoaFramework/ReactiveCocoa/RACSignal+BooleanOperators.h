//
//  RACSignal+BooleanOperators.h
//  ReactiveCocoa
//
//  Created by Julius Parishy on 1/9/13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (BooleanOperators)

+(instancetype)foldLatestValues:(id<NSFastEnumeration>)signals initialValue:(id)initialValue combine:(id(^)(id running, id next))combine;

-(instancetype)not;
+(instancetype)not:(RACSignal *)signal;

-(instancetype)and:(id)signalOrSignals;
+(instancetype)and:(id)signalOrSignals;

-(instancetype)or:(id)signalOrSignals;
+(instancetype)or:(id)signalOrSignals;

-(instancetype)xor:(id)signalOrSignals;
+(instancetype)xor:(id)signalOrSignals;

@end
