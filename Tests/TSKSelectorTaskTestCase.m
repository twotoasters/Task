//
//  TSKSelectorTaskTestCase.m
//  Task
//
//  Created by Jill Cohen on 11/5/14.
//  Copyright (c) 2014 Two Toasters, LLC.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TSKRandomizedTestCase.h"


@interface TSKSelectorTaskTestCase : TSKRandomizedTestCase

@property (nonatomic, assign) BOOL methodInvoked;
@property (nonatomic, strong) TSKTask *task;

- (void)testInit;
- (void)testMain;

@end


@implementation TSKSelectorTaskTestCase

- (void)testInit
{
    XCTAssertThrows(([[TSKSelectorTask alloc] initWithTarget:self selector:NULL]), @"NULL selector does not throw exception");
    XCTAssertThrows(([[TSKSelectorTask alloc] initWithTarget:nil selector:@selector(description)]), @"nil target does not throw exception");

    TSKSelectorTask *task = [[TSKSelectorTask alloc] initWithTarget:self selector:@selector(method:)];
    XCTAssertNotNil(task, @"returns nil");
    XCTAssertEqual(task.target, self, @"target not set propertly");
    XCTAssertEqual(task.selector, @selector(method:), @"method not set propertly");
    XCTAssertEqualObjects(task.name, [self defaultNameForTask:task], @"name not set to default");
    XCTAssertNil(task.graph, @"graph is non-nil");
    XCTAssertNil(task.prerequisiteTasks, @"prerequisiteTasks is non-nil");
    XCTAssertNil(task.dependentTasks, @"dependentTasks is non-nil");

    NSString *name = UMKRandomUnicodeString();
    task = [[TSKSelectorTask alloc] initWithName:name target:self selector:@selector(method:)];
    XCTAssertEqual(task.target, self, @"target not set propertly");
    XCTAssertEqual(task.selector, @selector(method:), @"method not set propertly");
    XCTAssertEqualObjects(task.name, name, @"name not set properly");
    XCTAssertNil(task.graph, @"graph is non-nil");
    XCTAssertNil(task.prerequisiteTasks, @"prerequisiteTasks is non-nil");
    XCTAssertNil(task.dependentTasks, @"dependentTasks is non-nil");
    XCTAssertEqual(task.state, TSKTaskStateReady, @"state not set to default");
}


- (void)testMain
{
    self.methodInvoked = NO;

    TSKSelectorTask *task = [[TSKSelectorTask alloc] initWithTarget:self selector:@selector(method:)];

    XCTAssertFalse(self.methodInvoked, @"selector called early");
    [task main];
    XCTAssertTrue(self.methodInvoked, @"selector not called");
    XCTAssertEqual(self.task, task, @"incorrect task parameter");
}


- (void)method:(TSKTask *)task
{
    self.methodInvoked = YES;
    self.task = task;
}

@end