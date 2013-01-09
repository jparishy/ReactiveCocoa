//
//  RACSignal+BooleanOperators.h
//  ReactiveCocoa
//
//  Created by Julius Parishy on 1/9/13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RACSignal (BooleanOperators)

-(instancetype)not;
+(instancetype)not:(RACSignal *)signal;

-(instancetype)and:(id<NSFastEnumeration>)signals;
+(instancetype)and:(id<NSFastEnumeration>)signals;

-(instancetype)or:(id<NSFastEnumeration>)signals;
+(instancetype)or:(id<NSFastEnumeration>)signals;

-(instancetype)xor:(id<NSFastEnumeration>)signals;
+(instancetype)xor:(id<NSFastEnumeration>)signals;

@end
