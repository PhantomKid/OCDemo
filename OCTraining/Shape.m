//
//  Shape.m
//  OCTraining
//
//  Created by Kai on 2022/8/11.
//

#import <Foundation/Foundation.h>
#import "Shape.h"

#define INITBEFORECOPY(TYPE) TYPE *obj = [[TYPE allocWithZone:zone] init]

@implementation MyBasicObject : NSObject
-(instancetype) init {
    _parent = nil;
    return self;
}
-(instancetype) initWithParent:(MyBasicObject *)parent {
    self.parent = parent;
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(MyBasicObject);
    return obj;
}
-(NSString *) toString {
    return @"MyBasicObject";
}
-(void) print {
    NSLog(@"%@", [self toString]);
}
-(instancetype) customTransformation: (transformationBlock) block {
    NSLog(@"MyBasicObject");
    return self;
}
-(instancetype) moveBy:(double)dx :(double)dy {
    transformationBlock block = ^MyPoint* (MyPoint *p) {
        return [p moveBy:dx :dy];
    };
    [self customTransformation:block];
    return self;
}
-(instancetype) rotateAroundOrigin:(double)angle {
    transformationBlock block = ^MyPoint* (MyPoint *p) {
        double x1 = p->x*cos(angle) - p->y*sin(angle);
        double y1 = p->x*sin(angle) + p->y*cos(angle);
        p->x = x1;
        p->y = y1;
        return p;
    };
    [self customTransformation:block];
    return self;
}
-(instancetype) rotateAroundCertainPivot:(MyPoint *)pivot :(double)angle {
    transformationBlock block = ^MyPoint* (MyPoint *p) {
        [p moveBy:-pivot->x :-pivot->y];
        [self rotateAroundOrigin:angle];
        [p moveBy:pivot->x :pivot->y];
        return p;
    };
    [self customTransformation:block];
    return self;
}
@end

@implementation MyPoint: MyBasicObject
-(instancetype) init {
    self = [super init];
    x = 0;
    y = 0;
    return self;
}
-(instancetype) initWithXandY:(double)x :(double)y {
    self = [super init];
    self->x = x;
    self->y = y;
    return self;
}
-(instancetype) initWithOtherPoint:(MyPoint *)other {
    self = [super init];
    self->x = other->x;
    self->y = other->y;
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(MyPoint);
    obj->x = self->x;
    obj->y = self->y;
    return obj;
}
-(BOOL) isEqualTo:(MyPoint *) other {
    return EQUAL_FOR_DOUBLE(self->x, other->x) && EQUAL_FOR_DOUBLE(self->y, other->y);
}
+(double) distanceBetweenTwoPoints:(MyPoint *)p1 :(MyPoint *)p2 {
    return sqrt((p1->x-p2->x)*(p1->x-p2->x)+(p1->y-p2->y)*(p1->y-p2->y));
}
-(double) distanceBetweenOtherPoint:(MyPoint *)other {
    return [MyPoint distanceBetweenTwoPoints:self :other];
}
-(double) distanceFromOrigin {
    return sqrt(x*x + y*y);
}
-(instancetype) customTransformation: (transformationBlock) block {
    MyPoint *transformedSelf = block(self);
    self->x = transformedSelf->x;
    self->y = transformedSelf->y;
    return self;
}
-(instancetype) moveBy: (double)dx : (double)dy {
    self->x += dx;
    self->y += dy;
    return self;
}
-(instancetype) rotateAroundOrigin: (double)angle {
    double x1 = x*cos(angle) - y*sin(angle);
    double y1 = x*sin(angle) + y*cos(angle);
    x = x1;
    y = y1;
    return self;
}
-(instancetype) rotateAroundCertainPivot:(MyPoint *)pivot :(double)angle {
    [self moveBy:-pivot->x :-pivot->y];
    [self rotateAroundOrigin:angle];
    [self moveBy:pivot->x :pivot->y];
    return self;
}
-(NSString *) toString {
    NSString *str = [[NSString alloc] initWithFormat:@"点(%lf,%lf)", self->x, self->y];
    return str;
}
@end

@implementation Vector: MyBasicObject
-(instancetype) init {
    self = [super init];
    _vecStartedFromOrigin = [[MyPoint alloc] init];
    return self;
}
-(instancetype) initWithXandY:(double)x :(double)y {
    self = [super init];
    _vecStartedFromOrigin = [[MyPoint alloc] initWithXandY:x :y];
    return self;
}
-(instancetype) initWithPoint:(MyPoint *)point {
    self = [super init];
    _vecStartedFromOrigin = [[MyPoint alloc] initWithOtherPoint:point];
    return self;
}
-(instancetype) initWithTwoPoints:(MyPoint *)head :(MyPoint *)tail {
    self = [super init];
    _vecStartedFromOrigin = [[MyPoint alloc] initWithXandY: tail->x - head->x :tail->y - head->y];
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(Vector);
    obj.vecStartedFromOrigin = self.vecStartedFromOrigin;
    return obj;
}
-(instancetype) addWithOtherVector:(Vector *)other {
    _vecStartedFromOrigin->x += other->_vecStartedFromOrigin->x;
    _vecStartedFromOrigin->y += other->_vecStartedFromOrigin->y;
    return self;
}
-(instancetype) subWithOtherVector:(Vector *)other {
    _vecStartedFromOrigin->x -= other->_vecStartedFromOrigin->x;
    _vecStartedFromOrigin->y -= other->_vecStartedFromOrigin->y;
    return self;
}
-(BOOL) isEqualTo:(Vector *)other {
    return [self->_vecStartedFromOrigin isEqualTo:other->_vecStartedFromOrigin];
}
+(double)calLength:(double)dx :(double)dy {
    return sqrt(dx*dx + dy*dy);
}
-(double)getLength {
    return [Vector calLength:_vecStartedFromOrigin->x :_vecStartedFromOrigin->y];
}
+(double)dotProduct:(double)x1 :(double)y1 :(double)x2 :(double)y2 {
    return x1*x2 + y1*y2;
}
+(double)dotProductWithTwoVectors:(Vector *)v1 :(Vector *)v2 {
    return [Vector dotProduct:
            v1->_vecStartedFromOrigin->x :
            v1->_vecStartedFromOrigin->y :
            v2->_vecStartedFromOrigin->x :
            v2->_vecStartedFromOrigin->y];
}
-(double)dotProductWithOtherVector:(Vector *)other {
    return [Vector dotProductWithTwoVectors:self :other];
}
+(double)crossProductWithDirection:(double)x1 :(double)y1 :(double)x2 :(double)y2 {
    return x1*y2 - x2*y1;
}
+(double)crossProductWithoutDirection:(double)x1 :(double)y1 :(double)x2 :(double)y2 {
    return fabs(x1*y2 - x2*y1);
}
+(double)crossProductWithTwoVectorsWithDirection:(Vector *)v1 :(Vector *)v2 {
    return [Vector crossProductWithDirection:
            v1->_vecStartedFromOrigin->x :
            v1->_vecStartedFromOrigin->y :
            v2->_vecStartedFromOrigin->x :
            v2->_vecStartedFromOrigin->y];
}
+(double)crossProductWithTwoVectorsWithOutDirection:(Vector *)v1 :(Vector *)v2 {
    return fabs([Vector crossProductWithTwoVectorsWithDirection:v1 :v2]);
}
-(double)crossProductWithOtherVectorWithDirection:(Vector *)other {
    return [Vector crossProductWithTwoVectorsWithDirection:self :other];
}
-(double)crossProductWithOtherVectorWithoutDirection:(Vector *)other {
    return fabs([self crossProductWithOtherVectorWithoutDirection:other]);
}
-(instancetype) customTransformation:(transformationBlock)block {
    [_vecStartedFromOrigin customTransformation:block];
    return self;
}
-(NSString *)toString {
    NSString *str = [[NSString alloc] initWithFormat:
                     @"向量(%lf, %lf)", self->_vecStartedFromOrigin->x, self->_vecStartedFromOrigin->y];
    return str;
}
@end

@implementation Triangle: MyBasicObject
-(BOOL) isTriangle {
    return [self getArea] > EPSILON;
}
-(instancetype) init {
    self = [super init];
    _p1 = [[MyPoint alloc] init];
    _p2 = [[MyPoint alloc] init];
    _p3 = [[MyPoint alloc] init];
    _center = [[MyPoint alloc] initWithXandY:
               (_p1->x + _p2->x + _p3->x) / 3 :
               (_p1->y + _p2->y + _p3->y) / 3];
    return self;
}
-(instancetype) initWithPoints:(MyPoint *)p1 :(MyPoint *)p2 :(MyPoint *)p3 {
    self = [super init];
    self.p1 = p1;
    self.p2 = p2;
    self.p3 = p3;
    self.center = [[MyPoint alloc] initWithXandY:
               (_p1->x + _p2->x + _p3->x) / 3 :
               (_p1->y + _p2->y + _p3->y) / 3];
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(Triangle);
    obj.p1 = self.p1;
    obj.p2 = self.p2;
    obj.p3 = self.p3;
    obj.center = self.center;
    return obj;
}
-(double)getArea {
    return [Vector crossProductWithoutDirection:
            _p2->x - _p1->x :
            _p2->y - _p1->y :
            _p3->x - _p1->x :
            _p3->y - _p1->y];
}
-(double)getPerimeter {
    Vector *line1, *line2, *line3;
    line1 = [[Vector alloc] initWithTwoPoints:_p1 :_p2];
    line2 = [[Vector alloc] initWithTwoPoints:_p2 :_p3];
    line3 = [[Vector alloc] initWithTwoPoints:_p3 :_p1];
    return [line1 getLength] + [line2 getLength] + [line3 getLength];
}
-(instancetype) customTransformation:(transformationBlock)block {
    double x1, x2, x3, y1, y2, y3;
    x1 = _p1->x - _center->x;
    x2 = _p2->x - _center->x;
    x3 = _p3->x - _center->x;
    y1 = _p1->y - _center->y;
    y2 = _p2->y - _center->y;
    y3 = _p3->y - _center->y;
    [_center customTransformation:block];
    _p1->x = _center->x + x1;
    _p2->x = _center->x + x2;
    _p3->x = _center->x + x2;
    _p1->y = _center->x + y1;
    _p2->y = _center->x + y2;
    _p3->y = _center->x + y2;
    return self;
}
-(NSString *) toString {
    NSString *str = [[NSString alloc] initWithFormat:
                     @"三角形: %@, %@, %@", [_p1 toString], [_p2 toString], [_p3 toString]];
    return str;
}
@end

@implementation Parallelogram : MyBasicObject
-(BOOL) isParallelogram {
    Vector *v3 = [[Vector alloc] initWithTwoPoints:_tl :_tr];
    Vector *v4 = [[Vector alloc] initWithTwoPoints:_ll :_tl];
    return [_v1 isEqualTo:v3] && [_v2 isEqualTo:v4];
}
-(void) changeVectors {
    _v1 = [[Vector alloc] initWithTwoPoints:_ll :_lr];
    _v2 = [[Vector alloc] initWithTwoPoints:_lr :_tr];
}
-(instancetype) init {
    self = [super init];
    _ll = [[MyPoint alloc] init];
    _lr = [[MyPoint alloc] init];
    _tr = [[MyPoint alloc] init];
    _tl = [[MyPoint alloc] init];
    [self changeVectors];
    _center = [[MyPoint alloc] initWithXandY: 0.5*(_ll->x + _lr->x)
                                            : 0.5*(_lr->y + _tr->y)];
    return self;
}
-(instancetype) initWithPoints:(MyPoint *)ll :(MyPoint *)lr :(MyPoint *)tr :(MyPoint *)tl {
    self = [super init];
    self.ll = ll;
    self.lr = lr;
    self.tr = tr;
    self.tl = tl;
    [self changeVectors];
    self.center = [[MyPoint alloc] initWithXandY: 0.5*(_ll->x + _lr->x)
                                            : 0.5*(_lr->y + _tr->y)];
    if (![self isParallelogram]) {
        NSException *exc = [NSException exceptionWithName:@"不构成平行四边形" reason:@"两对边向量不都相等" userInfo:nil];
        [self print];
        @throw(exc);
    }
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(Parallelogram);
    obj.ll = self.ll;
    obj.lr = self.lr;
    obj.tr = self.tr;
    obj.tl = self.tl;
    obj.v1 = self.v1;
    obj.v2 = self.v2;
    obj.center = self.center;
    return self;
}
-(double) getArea {
    return [Vector crossProductWithTwoVectorsWithOutDirection:_v1 :_v2];
}
-(double) getPerimeter {
    return 2 * ([_v1 getLength] + [_v2 getLength]);
}
-(instancetype) customTransformation:(transformationBlock)block {
    double x1, x2, x3, x4, y1, y2, y3, y4;
    x1 = _ll->x - _center->x;
    x2 = _lr->x - _center->x;
    x3 = _tr->x - _center->x;
    x4 = _tl->x - _center->x;
    y1 = _ll->y - _center->y;
    y2 = _lr->y - _center->y;
    y3 = _tr->y - _center->y;
    y4 = _tl->y - _center->y;
    [_center customTransformation:block];
    _ll->x = _center->x + x1;
    _lr->x = _center->x + x2;
    _tr->x = _center->x + x3;
    _tl->x = _center->x + x4;
    _ll->y = _center->y + y1;
    _lr->y = _center->y + y2;
    _tr->y = _center->y + y3;
    _tl->y = _center->y + y4;
    [self changeVectors];
    return self;
}
-(NSString *) toString {
    NSString *str = [[NSString alloc] initWithFormat:
        @"平行四边形: %@, %@, %@, %@", [_ll toString], [_lr toString], [_tr toString], [_tl toString]];
    return str;
}
@end

@implementation Rectangle: Parallelogram
-(BOOL) isRectangle {
    return [self isParallelogram] && [Vector dotProductWithTwoVectors:super.v1 :super.v2] == 0;
}
-(instancetype) init {
    self = [super init];
    return self;
}
-(instancetype) initWithPoints:(MyPoint *)ll :(MyPoint *)lr :(MyPoint *)tr :(MyPoint *)tl
{
    self = [super initWithPoints:ll :lr :tr :tl];
    if (![self isRectangle]) {
        NSException *exc = [NSException exceptionWithName:@"不构成矩形" reason:@"构成平行四边形但无直角" userInfo:nil];
        @throw(exc);
    }
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(Rectangle);
    obj.ll = self.ll;
    obj.lr = self.lr;
    obj.tr = self.tr;
    obj.tl = self.tl;
    obj.v1 = self.v1;
    obj.v2 = self.v2;
    obj.center = self.center;
    return self;
}
-(instancetype) customTransformation:(transformationBlock)block {
    [super customTransformation:block];
    if (![self isRectangle]) {
        NSException *exc = [NSException exceptionWithName:@"不构成矩形" reason:@"构成平行四边形但无直角" userInfo:nil];
        @throw(exc);
    }
    return self;
}
-(NSString *) toString {
    NSString *str = [[NSString alloc] initWithFormat:@"矩形: %@, %@, %@, %@", [super.ll toString], [super.lr toString], [super.tr toString], [super.tl toString]];
    return str;
}
@end

@implementation Circle: MyBasicObject
-(BOOL) isCircle {
    return _radius > EPSILON;
}
-(instancetype) init {
    self = [super init];
    _center = [[MyPoint alloc] init];
    _radius = 0.0;
    return self;
}
-(instancetype) initWithCenterAndRadius:(MyPoint *)center :(double)radius {
    self.center = center;
    _radius = radius;
    if (![self isCircle]) {
        NSException *exc = [NSException exceptionWithName:@"圆形" reason:@"半径非正" userInfo:nil];
        @throw(exc);
    }
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(Circle);
    obj.center = self.center;
    _radius = self.radius;
    return self;
}
+(double) calArea:(double)radius {
    return radius * radius * M_PI;
}
+(double) calPerimeter:(double)radius {
    return 2 * radius * M_PI;
}
-(double) getArea {
    return [Circle calArea:_radius];
}
-(double) getPerimeter {
    return [Circle calPerimeter:_radius];
}
-(NSString *) toString {
    NSString *str = [[NSString alloc] initWithFormat:@"圆: %@, 半径:%lf", [_center toString], _radius];
    return str;
}
-(instancetype) customTransformation:(transformationBlock)block {
    [_center customTransformation:block];
    return self;
}
@end

@implementation ShapeSet :MyBasicObject
-(instancetype) init {
    self = [super init];
    _triangle = [_triangle initWithParent:self];
    _rectangle = [_rectangle initWithParent:self];
    _circle = [_circle initWithParent:self];
    return self;
}
-(instancetype) initWithShapes:(Triangle *)triangle :(Rectangle *)rectangle :(Circle *)circle {
    self = [super init];
    self.triangle = triangle; _triangle = [_triangle initWithParent:self];
    self.rectangle = rectangle; _rectangle = [_rectangle initWithParent:self];
    self.circle = circle; _circle = [_circle initWithParent:self];
    return self;
}
-(instancetype) copyWithZone:(NSZone *)zone {
    INITBEFORECOPY(ShapeSet);
    obj.triangle = self.triangle;
    obj.rectangle = self.rectangle;
    obj.circle = self.circle;
    return self;
}
-(double) getAggregateArea {
    return [_triangle getArea] + [_rectangle getArea] + [_circle getArea];
}
-(double) getAggregatePerimeter {
    return [_triangle getPerimeter] + [_rectangle getPerimeter] + [_rectangle getPerimeter];
}
-(instancetype) customTransformation:(transformationBlock)block {
    [_triangle customTransformation:block];
    [_rectangle customTransformation:block];
    [_circle customTransformation:block];
    return self;
}
-(NSString*) toString {
    NSString *str = [[NSString alloc] initWithFormat:@"%@, %@, %@", [_triangle toString], [_rectangle toString], [_circle toString]];
    return str;
}
@end
