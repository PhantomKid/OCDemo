//
//  main.m
//  OCTraining
//
//  Created by Kai on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import "Shape.h"
#import "Sort.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyPoint *p1, *p2, *p3, *p4;
        p1 = [[MyPoint alloc] initWithXandY:0.0 :0.0];
        p2 = [[MyPoint alloc] initWithXandY:2.0 :0.0];
        p3 = [[MyPoint alloc] initWithXandY:2.0 :3.0];
        p4 = [[MyPoint alloc] initWithXandY:0.0 :3.0];
        Triangle *triangle = nil;
        Rectangle *rectangle = nil;
        @try {
            triangle = [[Triangle alloc] initWithPoints:p1 :p2 :p3];
        } @catch (NSException *exception) {
            if ([[exception name] isEqualToString:@"不构成三角形"]) {
                NSLog(@"%@", [exception name]);
            } else {
                NSLog(@"Unknown Error");
            }
        }
        @try {
            rectangle = [[Rectangle alloc] initWithPoints:p1 :p2 :p3 :p4];
        } @catch (NSException *exception) {
            if ([[exception name] isEqualToString:@"不构成平行四边形"]) {
                NSLog(@"%@", [exception name]);
            } else if ([[exception name] isEqualToString:@"不构成矩形"]) {
                NSLog(@"%@", [exception name]);
            } else {
                NSLog(@"Unknown Error");
            }
        }
        Circle *circle = [[Circle alloc] initWithCenterAndRadius:p4 :2.0];
        ShapeSet *shapeSet = [[ShapeSet alloc] initWithShapes:triangle :rectangle :circle];
        
        transformationBlock block = ^MyPoint* (MyPoint* p) {
            [p moveBy:1.0 :2.0];
            [p rotateAroundOrigin:M_PI/3];
            [p moveBy:3.0 :4.0];
            return p;
        };
        
        [shapeSet print];
        [shapeSet.triangle customTransformation:block];
        [shapeSet print];
        NSLog(@"%lf", [shapeSet getAggregateArea]);
    }
    return 0;
}


// ---------------------------- SortTest ---------------------------- //
/*MyPoint *points[10];
 int i;
 for (i = 0; i < 10; ++i) {
     points[i] = [[MyPoint alloc] initWithXandY:i :7-i];
 }
 for (i = 0; i < 10; ++i) {
     NSLog(@"points[%d]: %@", i, [points[i] toString]);
 }
 SortBlock less = ^BOOL (MyPoint *p1, MyPoint *p2) {
     double d1 = [p1 distanceFromOrigin];
     double d2 = [p2 distanceFromOrigin];
     if (!EQUAL_FOR_DOUBLE(d1, d2)) {
         return d1 < d2;
     }
     return p1->x < p2->x;
 };
 // [Sort quickSort:points :0 :9 :less];
 // [Sort heapSort:points :9 :less];
 [Sort selectionSort:points :9 :less];
 for (i = 0; i < 10; ++i) {
     NSLog(@"points[%d]: %@", i, [points[i] toString]);
 }*/
