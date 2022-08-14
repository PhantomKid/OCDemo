#  Objective-C语言基础训练示例

**这是一个非常小的练习性质的oc项目demo，在这个项目中练习了property关键词、Block和容器、三种不稳定排序（选择排序、快速排序、堆排序）的使用**

## 项目结构
    |———— README.md
    |———— OCTraining
            |———— main.m
            |———— Shape.h
            |———— Shape.m
            |———— Sort.h
            |———— Sort.m

## 项目逻辑介绍
1. main: 主函数入口，测试代码和展示功能
2. Shape: 几何图形类
    ```mermaid
    graph TD
        A(MyBasicObject) --> B{MyPoint}
        B --> C(Vector)
        B --> D(Triangle)
        B --> E(Parallelogram)
        C --> E(Parallelogram)
        E --> F(Rectangle)
        B --> G(Circle)
    ```
3. Sort: 三种排序方法（选择排序、快速排序、堆排序）

### 知识点对应体现
- property: 
    1. MyBasicObject中的指向父类parent的指针为weak类型
    2. Circle中半径radius为nonatomic、assign和readonly类型
    3. Triangle、Rectangle等几何图形中的点属性均为atomic、copy类型
- Block:
    1. 对几何图形的变换操作是通过Block传递的
    2. 对非标量变量的排序规则是通过Block定义的
- 三种不稳定排序方法在Sort中已经给出
