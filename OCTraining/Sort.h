//
//  Sort.h
//  OCTraining
//
//  Created by Kai on 2022/8/13.
//

#ifndef Sort_h
#define Sort_h

typedef BOOL (^SortBlock)(id obj1, id obj2);

@interface Sort : NSObject
+(void) swap:(__strong id*)a :(__strong id*)b;

+(void) selectionSort:(__strong id*)objArray :(unsigned int)length :(SortBlock) less;
+(void) quickSort: (__strong id*)objArray :(unsigned int)left :(unsigned int)right :(SortBlock) less;

+(void) heapNodeProcessing: (__strong id*)objArray :(unsigned int)index :(unsigned int)length
    :(SortBlock) less;
+(void) buildMaxHeap: (__strong id*)objArray :(unsigned int)length :(SortBlock) less;
+(void) heapSort: (__strong id*)objArray :(unsigned int)length :(SortBlock) less;
@end

#endif /* Sort_h */
