//
//  RACSignalBooleanOperatorsSpec.m
//  ReactiveCocoa
//
//  Created by Julius Parishy on 1/9/13.
//  Copyright (c) 2013 GitHub, Inc. All rights reserved.
//

#import "RACSignal.h"
#import "RACSubject.h"
#import "RACSignal+BooleanOperators.h"

#import "RACUnit.h"

SpecBegin(RACSignalBooleanOperators)

describe(@"foldLatestValues:initialValue:combine: RACSignal class method", ^{

    it(@"should send 8 when folding 5 and 3", ^{
    
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *folded = [RACSignal foldLatestValues:@[ first, second ] initialValue:@0 combine:^id(id running, id next) {
        
            return @([running integerValue] + [next integerValue]);
        }];
        
        [first sendNext:@5];
    
        [folded subscribeNext:^(id x) {
        
            expect(x).to.equal(@8);
        }];
        
        [second sendNext:@3];
    });
});

describe(@"not RACSignal class method", ^{
    
    __block RACSubject *signal;

    it(@"should send NO when given YES", ^{
    
        RACSignal *notYesSignal = [RACSignal not:signal];
        
        [notYesSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [signal sendNext:@YES];
    });
    
    it(@"should send YES when given NO", ^{
    
        RACSignal *notNoSignal = [RACSignal not:signal];
        
        [notNoSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [signal sendNext:@NO];
    });
});

describe(@"not RACSignal instance method", ^{
    
    __block RACSubject *signal;
    
    before(^{
        signal = [RACSubject subject];
    });
    
    it(@"should send NO when given YES", ^{
        
        RACSignal *notYesSignal = [signal not];
        
        [notYesSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [signal sendNext:@YES];
    });
    
    it(@"should send YES when given NO", ^{
        
        RACSignal *notNoSignal = [signal not];
        
        [notNoSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [signal sendNext:@NO];
    });
});

describe(@"and RACSignal class method", ^{
    
    it(@"should send YES when given YES and YES", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [RACSignal and:@[ first, second ]];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [first sendNext:@YES];
        [second sendNext:@YES];
    });
    
    it(@"should send NO when given YES and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [RACSignal and:@[ first, second]];
        
        [first sendNext:@YES];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [second sendNext:@NO];
    });
});

describe(@"and RACSignal instance method", ^{
    
    it(@"should send YES when given YES and YES", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [first and:@[ second ]];
        
        [first sendNext:@YES];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [second sendNext:@YES];
    });
    
    it(@"should send NO when given YES and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [first and:@[ second ]];
        
        [first sendNext:@YES];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [second sendNext:@NO];
    });
});

describe(@"or RACSignal class method", ^{
    
    it(@"should send YES when given YES and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [RACSignal or:@[ first, second]];
        
        [first sendNext:@YES];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [second sendNext:@NO];
    });
    
    it(@"should send NO when given NO and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [RACSignal or:@[ first, second]];
        
        [first sendNext:@NO];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [second sendNext:@NO];
    });
});

describe(@"or RACSignal instance method", ^{

    it(@"should send YES when given YES and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [first or:@[ second ]];
        
        [first sendNext:@YES];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [second sendNext:@NO];
    });
    
    it(@"should send NO when given NO and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        RACSignal *andFirstSecond = [first or:@[ second ]];
        
        [first sendNext:@NO];
        
        [andFirstSecond subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [second sendNext:@NO];
    });
});

describe(@"xor RACSignal class method", ^{
    
    __block RACSignal *xorSignal;
    
    it(@"should send NO when given YES and YES", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        xorSignal = [first xor:@[ second ]];
        
        [first sendNext:@YES];
        
        [xorSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [second sendNext:@YES];
    });
    
    it(@"should send NO when given NO and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        xorSignal = [first xor:@[ second ]];
        
        [first sendNext:@NO];
        
        [xorSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [second sendNext:@NO];
    });
    
    it(@"should send YES when given YES and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        xorSignal = [first xor:@[ second ]];
        
        [first sendNext:@YES];
        
        [xorSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [second sendNext:@NO];
    });
    
    it(@"should send YES when given NO and YES", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        
        xorSignal = [first xor:@[ second ]];
        
        [first sendNext:@NO];
        
        [xorSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [second sendNext:@YES];
    });
    
    it(@"should send YES when given NO, YES, and NO", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        RACSubject *third = [RACSubject subject];
        
        xorSignal = [first xor:@[ second, third ]];
        
        [first sendNext:@NO];
        [second sendNext:@YES];
        
        [xorSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@YES);
        }];
        
        [third sendNext:@NO];
    });
    
    it(@"should send NO when given NO, YES, and YES", ^{
        
        RACSubject *first = [RACSubject subject];
        RACSubject *second = [RACSubject subject];
        RACSubject *third = [RACSubject subject];
        
        xorSignal = [first xor:@[ second, third ]];
        
        [first sendNext:@NO];
        [second sendNext:@YES];
        
        [xorSignal subscribeNext:^(id x) {
            
            expect(x).to.equal(@NO);
        }];
        
        [third sendNext:@YES];
    });
});

SpecEnd
