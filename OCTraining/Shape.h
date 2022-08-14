//
//  Shape.h
//  OCTraining
//
//  Created by Kai on 2022/8/11.
//

#ifndef Shape_h
#define Shape_h

#define EPSILON 1e-7
#define EQUAL_FOR_DOUBLE(a, b) (fabs(a-b) < EPSILON)

//前向声明
@class MyPoint;

//定义一个闭包类型（进行几何变换）
typedef MyPoint* (^transformationBlock)(MyPoint*);

//定义一个协议，要求遵守者必须含有toString方法(方便打印信息)和customTransformation方法(能够进行几何变换)
@protocol MyBasicObject
-(NSString *) toString;
-(id) customTransformation: (transformationBlock) block;
@end

//定义一个基类遵守上述协议，且该基类已定义print方法（调用自身toString方法）和基本几何变换方法
@interface MyBasicObject : NSObject <MyBasicObject, NSCopying>
//指向父类的弱引用
@property(nonatomic, weak) MyBasicObject* parent;
-(instancetype) init;
-(instancetype) initWithParent: (MyBasicObject*) parent;
-(void) print;
-(instancetype) moveBy: (double)dx : (double)dy;
-(instancetype) rotateAroundOrigin: (double)angle;
-(instancetype) rotateAroundCertainPivot: (MyPoint*) pivot :(double)angle;
@end

//已存在Point结构体，故命名MyPoint类
@interface MyPoint: MyBasicObject {
@public
    double x;
    double y;
}
-(instancetype) init;
-(instancetype) initWithXandY: (double)x : (double)y;
-(instancetype) initWithOtherPoint: (MyPoint*) other;
-(BOOL) isEqualTo:(MyPoint *) other;
+(double) distanceBetweenTwoPoints: (MyPoint*) p1 : (MyPoint*) p2;
-(double) distanceBetweenOtherPoint: (MyPoint*) other;
-(double) distanceFromOrigin;
-(instancetype) moveBy: (double)dx : (double)dy;
-(instancetype) rotateAroundOrigin: (double)angle;
-(instancetype) rotateAroundCertainPivot: (MyPoint*) pivot :(double)angle;
-(NSString *) toString;
@end

@interface Vector : MyBasicObject
@property(atomic, copy) MyPoint* vecStartedFromOrigin;  //定义一个向量，用起点为原点的终点坐标表示
-(instancetype) init;
-(instancetype) initWithXandY: (double)x : (double)y;
-(instancetype) initWithPoint: (MyPoint*) point;
-(instancetype) initWithTwoPoints: (MyPoint*) head : (MyPoint*) tail;

-(instancetype) addWithOtherVector: (Vector*) other;
-(instancetype) subWithOtherVector: (Vector*) other;

-(BOOL) isEqualTo: (Vector*) other;

+(double) calLength: (double)dx : (double)dy;
-(double) getLength;

+(double) dotProduct: (double)x1 : (double)y1 : (double)x2 : (double)y2;
+(double) dotProductWithTwoVectors: (Vector*) v1 : (Vector*) v2;
-(double) dotProductWithOtherVector: (Vector*) other;

+(double) crossProductWithDirection: (double)x1 : (double)y1 : (double)x2 : (double)y2;
+(double) crossProductWithoutDirection: (double)x1 : (double)y1 : (double)x2 : (double)y2;
-(double) crossProductWithOtherVectorWithDirection: (Vector*) other;
-(double) crossProductWithOtherVectorWithoutDirection: (Vector*) other;
+(double) crossProductWithTwoVectorsWithDirection: (Vector*) v1 : (Vector*) v2;
+(double) crossProductWithTwoVectorsWithOutDirection: (Vector*) v1 : (Vector*) v2;

-(NSString *) toString;
@end


//定义一个几何图形协议，要求必须遵守者必须实现面积和周长两个方法和变换协议方法
@protocol Shape <NSObject>
@required
-(double) getArea;
-(double) getPerimeter;
@end

@interface Triangle: MyBasicObject <Shape>
@property(atomic, copy) MyPoint* p1; //对于点的操作必须是原子化的，否则可能造成多次变换或者变换顺序出错而产生错误
@property(atomic, copy) MyPoint* p2;
@property(atomic, copy) MyPoint* p3;
@property(atomic, copy) MyPoint* center;
-(BOOL) isTriangle;
-(instancetype) init;
-(instancetype) initWithPoints: (MyPoint*)p1 : (MyPoint*)p2 : (MyPoint*) p3;
-(double) getArea;
-(double) getPerimeter;
-(NSString *) toString;
@end

@interface Parallelogram : MyBasicObject <Shape>
@property(atomic, copy) MyPoint* ll;
@property(atomic, copy) MyPoint* lr;
@property(atomic, copy) MyPoint* tr;
@property(atomic, copy) MyPoint* tl;
@property(atomic, copy) MyPoint* center;
@property(nonatomic, copy) Vector* v1;
@property(nonatomic, copy) Vector* v2;
-(void) changeVectors;  // v1, v2会随着变换而改变
-(BOOL) isParallelogram;
-(instancetype) init;
-(instancetype) initWithPoints: (MyPoint*)ll : (MyPoint*)lr : (MyPoint*) tr : (MyPoint *) tl;
-(double) getArea;
-(double) getPerimeter;
-(NSString *) toString;
@end

@interface Rectangle : Parallelogram
-(BOOL) isRectangle;
-(instancetype) init;
-(instancetype) initWithPoints: (MyPoint*)ll : (MyPoint*)lr : (MyPoint*) tr : (MyPoint *) tl;
@end

@interface Circle: MyBasicObject <Shape>
@property(atomic, copy) MyPoint* center;
@property(nonatomic, assign, readonly) double radius;
-(BOOL) isCircle;
-(instancetype) init;
-(instancetype) initWithCenterAndRadius: (MyPoint*) center : (double) radius;
+(double) calArea: (double) radius;
+(double) calPerimeter: (double) radius;
-(double) getArea;
-(double) getPerimeter;
-(NSString *) toString;
@end

@interface ShapeSet : MyBasicObject
@property(atomic, copy) Triangle* triangle;
@property(atomic, copy) Rectangle* rectangle;
@property(atomic, copy) Circle* circle;
-(instancetype) init;
-(instancetype) initWithShapes: (Triangle*) triangle :(Rectangle*) rectangle :(Circle*) circle;
-(double) getAggregateArea;
-(double) getAggregatePerimeter;
-(NSString *) toString;
@end

#endif /* Shape_h */
