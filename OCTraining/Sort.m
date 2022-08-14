//
//  Sort.m
//  OCTraining
//
//  Created by Kai on 2022/8/13.
//

#import <Foundation/Foundation.h>
#import "Sort.h"

@implementation Sort
+(void) swap:(__strong id *)a :(__strong id *)b {
    id tmp = *a;
    *a = *b;
    *b = tmp;
}
+(void) selectionSort:(__strong id *)objArray :(unsigned int)length :(SortBlock)less {
    //定义一个查询数组最小值的闭包函数
    unsigned int (^findMinValue_idx)(__strong id *objArray, unsigned int left, unsigned int right ,SortBlock less) = ^unsigned int(__strong id *objArray, unsigned int left, unsigned int right ,SortBlock less) {
        unsigned int minValue_idx = left;
        while (left < right) {
            if (less(objArray[left], objArray[minValue_idx])) minValue_idx = left;
            ++left;
        }
        return minValue_idx;
    };
    for (int i = 0, minValue_idx = 0; i < length; ++i) {
        minValue_idx = findMinValue_idx(objArray, i, length-1, less);
        [Sort swap:&objArray[i] :&objArray[minValue_idx]];
    }
}
+(void) quickSort:(__strong id*)objArray :(unsigned int)left :(unsigned int)right :(SortBlock)less {
    if (left >= right) return;
    unsigned int i = left;
    unsigned int j = right;
    //定义比较值，后续使得比该比较值小的值位于其左侧，比其大的值位于其右侧
    id standard = objArray[i];
    while (i < j) {
        while (i < j && less(standard, objArray[j])/*objArray[j] >= standard*/)
            --j;
        if (i < j)
            objArray[i] = objArray[j];
        while (i < j && less(objArray[i], standard)/*objArray[i] <= standard*/)
            ++i;
        if (i < j)
            objArray[j] = objArray[i];
        objArray[i] = standard;
    }
    [Sort quickSort:objArray :left :i-1 :less];
    [Sort quickSort:objArray :i+1 :right :less];
}
+(void) heapNodeProcessing:(__strong id *)objArray :(unsigned int)index :(unsigned int)length :(SortBlock)less {
    int left = 2*index + 1;
    int right = 2*index + 2;
    int maxValue_idx = index;
    
    //若有左节点且左节点的值更大，更新最大值的坐标
    if (left < length && less(objArray[maxValue_idx], objArray[left])) maxValue_idx = left;
    //若有右节点且左节点的值更大，更新最大值的坐标
    if (right < length && less(objArray[maxValue_idx], objArray[right])) maxValue_idx = right;
    if (maxValue_idx != index) {
        [Sort swap:&objArray[index] :&objArray[maxValue_idx]];
        //互换后子节点的值变了，若子节点也有自己的子节点，仍需再次调整
        [Sort heapNodeProcessing: objArray :maxValue_idx :length :less];
    };
}
+(void) buildMaxHeap:(__strong id *)objArray :(unsigned int)length :(SortBlock)less {
    for (int i = length/2 - 1; i >=0; --i) {
        //从最后一个非叶节点开始向前遍历，调整节点性质，使之成为大顶堆
        [Sort heapNodeProcessing:objArray :i :length :less];
    }
}
+(void) heapSort:(__strong id *)objArray :(unsigned int)length :(SortBlock)less {
    if (objArray == nil || length == 0) return;
    //构造大顶堆
    [Sort buildMaxHeap:objArray :length :less];
    for (int i = length-1; i > 0; --i) {
        //最大值置于尾部
        [Sort swap:&objArray[0] :&objArray[i]];
        //长度减一后用大顶堆的规则处理根部
        --length; [Sort heapNodeProcessing:objArray :0 :length :less];
    }
}

@end
