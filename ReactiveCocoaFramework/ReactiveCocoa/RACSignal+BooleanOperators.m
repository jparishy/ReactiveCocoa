//
//  RACSignal+BooleanOperators.m
//  ReactiveCocoa
//
//  Created by Julius Parishy on 1/9/13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACSignal+BooleanOperators.h"

#import "RACStream.h"
#import "RACSignal+Operations.h"

@implementation RACSignal (BooleanOperators)

+(instancetype)fold:(id<NSFastEnumeration>)signals withStart:(id)start combine:(id(^)(id running, id next))combine
{
    __block RACSubject *foldSignal = [RACSubject subject];
    
    [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *latestSignalValues) {
        
        id runningValue = start;
        
        for(RACSignal *nextValue in latestSignalValues)
        {
            runningValue = combine(runningValue, nextValue);
        }
        
        [foldSignal sendNext:runningValue];
        
    } error:^(NSError *error) {
        
        [foldSignal sendError:error];
    } completed:^{
        
        [foldSignal sendCompleted];
    }];
    
    return foldSignal;
}

-(instancetype)not
{
    return [self map:^id(id value) {
        return @(![value boolValue]);
    }];
}

+(instancetype)not:(RACSignal *)signal
{
    return [signal not];
}

-(instancetype)and:(id<NSFastEnumeration>)signals
{
    NSMutableArray *allSignals = [NSMutableArray arrayWithObject:self];
    for(RACSignal *signal in signals)
        [allSignals addObject:signal];
    
    return [self.class and:allSignals];
}

+(instancetype)and:(id<NSFastEnumeration>)signals
{
    return [RACSignal fold:signals withStart:@YES combine:^id(id running, id next) {
    
        return @([running boolValue] && [next boolValue]);
    }];
}

-(instancetype)or:(id<NSFastEnumeration>)signals
{
    NSMutableArray *allSignals = [NSMutableArray arrayWithObject:self];
    for(RACSignal *signal in signals)
        [allSignals addObject:signal];
    
    return [self.class or:allSignals];
}

+(instancetype)or:(id<NSFastEnumeration>)signals
{
    return [RACSignal fold:signals withStart:@NO combine:^id(id running, id next) {
        
        return @([running boolValue] || [next boolValue]);
    }];
}

-(instancetype)xor:(id<NSFastEnumeration>)signals
{
    NSMutableArray *allSignals = [NSMutableArray arrayWithObject:self];
    for(RACSignal *signal in signals)
        [allSignals addObject:signal];
    
    return [self.class xor:allSignals];
}

+(instancetype)xor:(id<NSFastEnumeration>)signals
{
    return [RACSignal fold:signals withStart:@NO combine:^id(id running, id next) {
        
        return @([running boolValue] != [next boolValue]);
    }];
}

@end
