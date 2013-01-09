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

/*
 * This does not belong here.
 * Will remove or move it later.
 */
+(instancetype)foldLatestValues:(id<NSFastEnumeration>)signals initialValue:(id)initialValue combine:(id(^)(id running, id next))combine
{
    __block RACSubject *foldSignal = [RACSubject subject];
    
    [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *latestSignalValues) {
        
        id runningValue = initialValue;
        
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

-(instancetype)and:(id)signalOrSignals
{
    if([signalOrSignals conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        NSMutableArray *allSignals = [NSMutableArray arrayWithObject:self];
        for(RACSignal *signal in signalOrSignals)
            [allSignals addObject:signal];
        
        return [self.class and:allSignals];
    }
    else
    {
        return [self and:@[ signalOrSignals ]];
    }
}

+(instancetype)and:(id)signalOrSignals
{
    if([signalOrSignals conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        return [RACSignal foldLatestValues:signalOrSignals initialValue:@YES combine:^id(id running, id next) {
        
            return @([running boolValue] && [next boolValue]);
        }];
    }
    else
    {
        return [self and:@[ signalOrSignals ]];
    }
}

-(instancetype)or:(id)signalOrSignals
{
    if([signalOrSignals conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        NSMutableArray *allSignals = [NSMutableArray arrayWithObject:self];
        for(RACSignal *signal in signalOrSignals)
            [allSignals addObject:signal];
        
        return [self.class or:allSignals];
    }
    else
    {
        return [self or:@[ signalOrSignals]];
    }
}

+(instancetype)or:(id)signalOrSignals
{
    if([signalOrSignals conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        return [RACSignal foldLatestValues:signalOrSignals initialValue:@NO combine:^id(id running, id next) {
            
            return @([running boolValue] || [next boolValue]);
        }];
    }
    else
    {
        return [self or:@[ signalOrSignals ]];
    }
}

-(instancetype)xor:(id)signalOrSignals
{
    if([signalOrSignals conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        NSMutableArray *allSignals = [NSMutableArray arrayWithObject:self];
        for(RACSignal *signal in signalOrSignals)
            [allSignals addObject:signal];

        return [self.class xor:allSignals];
    }
    else
    {
        return [self xor:@[ signalOrSignals ]];
    }
}

+(instancetype)xor:(id)signalOrSignals
{
    if([signalOrSignals conformsToProtocol:@protocol(NSFastEnumeration)])
    {
        return [RACSignal foldLatestValues:signalOrSignals initialValue:@NO combine:^id(id running, id next) {
            
            return @([running boolValue] != [next boolValue]);
        }];
    }
    else
    {
        return [self xor:@[ signalOrSignals ]];
    }
}

@end
