//
//  Gauge.m
//  GaugeDemo
//
//  Created by 海锋 周 on 12-3-27.
//  Copyright (c) 2012年 CJLU. All rights reserved.
//

#import "Gauge.h"
#import <QuartzCore/QuartzCore.h>
#define MAXOFFSETANGLE 120.0f
//#define POINTEROFFSET  90.0f
#define POINTEROFFSET  90.0f
#define MAXVALUE       120.0f
#define CELLMARKNUM    5
#define CELLNUM        12
#define GAUGESTRING    @"单位:信心/h"
//#define DEFLUATSIZE    300
#define DEFLUATSIZE    100


@interface Gauge (private)

- (CGFloat) parseToX:(CGFloat) radius Angle:(CGFloat)angle;
- (CGFloat) parseToY:(CGFloat) radius Angle:(CGFloat)angle;
- (CGFloat) transToRadian:(CGFloat)angel;
- (CGFloat) parseToAngle:(CGFloat) val;
- (CGFloat) parseToValue:(CGFloat) val;
- (void)setTextLabel:(NSInteger)labelNum;
- (void)setLineMark:(NSInteger)labelNum;
- (void) pointToAngle:(CGFloat) angle Duration:(CGFloat) duration;


@end

@implementation Gauge



@synthesize gaugeView,pointer,context;
@synthesize labelArray;
@synthesize reactArea;



//- (id)initWithFrame:(CGRect)frame isInner:(BOOL) isInner
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        //设置背景透明
//        [self setBackgroundColor:[UIColor clearColor]];
//        
//        scoleNum = DEFLUATSIZE/frame.size.width;
//        maxNum = MAXVALUE;
//        minNum = 0.0f;
//        minAngle = -MAXOFFSETANGLE;
//        maxAngle = MAXOFFSETANGLE;
//        gaugeValue = 0.0f;
//        gaugeAngle = -MAXOFFSETANGLE;
//        angleperValue = (maxAngle - minAngle)/(maxNum - minNum);
//        
//        gaugeView= [UIImage imageNamed:@"gaugeback.png"];
//        
//    
//        //添加指针
//        UIImage *_pointer = [UIImage imageNamed:@"pointer2.png"];
//        pointer = [[UIImageView alloc] initWithImage:_pointer];
//        pointer.layer.anchorPoint = CGPointMake(0.5, 0.78);
//        pointer.center = self.center;
//        pointer.transform = CGAffineTransformMakeScale(scoleNum, scoleNum);
//        self.isInner=isInner;
//        [self addSubview:pointer];
//        //设置文字标签
//        [self setTextLabel:CELLNUM];
//        //设置指针到0位置
//        pointer.layer.transform = CATransform3DMakeRotation([self transToRadian:-MAXOFFSETANGLE], 0, 0, 1);
//    }
//    
//    
//    return self;
//}
- (id)initWithFrame:(CGRect)frame isInner:(BOOL) isInner
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景透明
        [self setBackgroundColor:[UIColor brownColor]];
        
        scoleNum = DEFLUATSIZE/frame.size.width;
        maxNum = MAXVALUE;
        minNum = 0.0f;
        minAngle = -MAXOFFSETANGLE;
        maxAngle = MAXOFFSETANGLE;
        gaugeValue = 0.0f;
        gaugeAngle = -MAXOFFSETANGLE;
        angleperValue = (maxAngle - minAngle)/(maxNum - minNum);
        
        gaugeView= [UIImage imageNamed:@"gaugeback.png"];
        self.center=CGPointMake(frame.origin.x/2
                                , frame.origin.y/2);
        
        //添加指针
        UIImage *_pointer = [UIImage imageNamed:@"pointer2.png"];
        //=@0.3;
        pointer = [[UIImageView alloc] initWithImage:_pointer];
        //pointer.layer.anchorPoint = CGPointMake(0.5,0.78);
        pointer.backgroundColor=[UIColor grayColor];
        pointer.center = CGPointMake(self.frame.size.width/5+30, (self.frame.size.height/5)+30);
        pointer.transform = CGAffineTransformMakeScale(0.3, 0.3);
        reactArea=self.frame;
        self.isInner=isInner;
        [self addSubview:pointer];
        //设置文字标签
        [self setTextLabel:CELLNUM];
        //设置指针到0位置
       // pointer.layer.transform = CATransform3DMakeRotation([self transToRadian:-MAXOFFSETANGLE], 0, 0, 1);
    }
    
    
    return self;
}

/*
 * setTextLabel 绘制刻度值
 * @labelNum NSInteger 刻度值的数目
 */
-(void)setTextLabel:(NSInteger)labelNum
{
     labelArray = [NSMutableArray arrayWithCapacity:labelNum];
    
    CGFloat textDis = (maxNum - minNum)/labelNum;
    CGFloat angelDis = (maxAngle - minAngle)/labelNum;
//    CGFloat radius = (self.center.x - 75)*scoleNum;
     CGFloat radius = (self.frame.size.width- 75)*scoleNum;
    CGFloat currentAngle;
    CGFloat currentText = 0.0f;
   // CGPoint centerPoint = self.center;//TODO
    
    //NSLog(@" %@",reactArea);
//   
    CGPoint centerPoint = CGPointMake((self.frame.size.width/5)+30
                                      
                                      , (self.frame.size.height/5)+30
                                      
                                      );
    
    

    for(int i=0;i<=labelNum;i++)
    {
        //currentAngle = minAngle + i * angelDis - POINTEROFFSET;
        currentAngle = minAngle + i * angelDis - 90;
        currentText = minNum + i * textDis;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 , 50, 50)];
        label.autoresizesSubviews = YES;
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];

        label.textAlignment = UITextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%d",(int)currentText];
        label.font=[UIFont systemFontOfSize:15];

        NSInteger *lengthBase=1;
        
        if(self.isInner==YES){
            lengthBase=2;
        }
          label.center = CGPointMake(centerPoint.x+(int)lengthBase*[self parseToX:radius Angle:currentAngle],centerPoint.y+(int)lengthBase*[self parseToY:radius Angle:currentAngle]);
//        label.text = [NSString stringWithFormat:@"x%d Y%d", label.center .x, label.center.y ];
//        label.backgroundColor=[UIColor redColor];
        [labelArray addObject:label];
        [self addSubview:label];
        //break;
    }
    // 设置刻度表的名称
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 , 0 ,100, 40)];
    label.autoresizesSubviews = YES;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.text = GAUGESTRING;
    label.font=[UIFont systemFontOfSize:15];
    //label.center = CGPointMake(centerPoint.x,centerPoint.y*3/2);old
     label.center = CGPointMake(centerPoint.x,centerPoint.y);
    [self addSubview:label];    
}

/*
 * setLineMark 绘制刻度的标记
 * @labelNum NSInteger 刻度是数目
 */
-(void)setLineMark:(NSInteger)labelNum
{

    CGFloat angelDis = (maxAngle - minAngle)/labelNum;
    CGFloat radius = self.center.x;
    CGFloat currentAngle;
     CGPoint centerPoint = self.center;
//    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    CGPoint centerPoint = CGPointMake(self.frame.size.width/4, self.frame.size.height/4);
//    CGPoint centerPoint = CGPointMake((self.frame.size.width/5)+30, (self.frame.size.height/5)+30);
    scoleNum=3;
    for(int i=0;i<=labelNum;i++)
    {
        currentAngle = minAngle + i * angelDis - POINTEROFFSET;
        //给刻度标记绘制不同的颜色
        if(i>labelNum*2/3)
        {
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.8] CGColor]);
        }else if(i>labelNum*1/3){
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1 green:1 blue:0 alpha:0.8] CGColor]);
        }else{
            CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0 green:1 blue:0 alpha:0.8] CGColor]);
        }
        
        //绘制不同的长短的刻度
        if(i%5==0)
        {     
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextSetLineWidth(context, 3);
            CGContextStrokePath(context);   
            CGContextMoveToPoint(context,centerPoint.x+[self parseToX:radius-25*scoleNum Angle:currentAngle], centerPoint.y+[self parseToY:radius-25*scoleNum Angle:currentAngle]);
            CGContextAddLineToPoint(context,centerPoint.x+[self parseToX:radius-45*scoleNum Angle:currentAngle], centerPoint.y+[self parseToY:radius-45*scoleNum Angle:currentAngle]);
            // CGContextAddLineToPoint(context,centerPoint.x+[self parseToX:radius-65*scoleNum Angle:currentAngle], centerPoint.y+[self parseToY:radius-65*scoleNum Angle:currentAngle]);
        }else{
            CGContextSetLineWidth(context, 2);
            CGContextSetLineCap(context, kCGLineCapSquare);
            CGContextStrokePath(context); 
            CGContextMoveToPoint(context,centerPoint.x+[self parseToX:radius-25*scoleNum Angle:currentAngle], centerPoint.y+[self parseToY:radius-25*scoleNum Angle:currentAngle]);
//            CGContextAddLineToPoint(context,centerPoint.x+[self parseToX:radius-40*scoleNum Angle:currentAngle], centerPoint.y+[self parseToY:radius-40*scoleNum Angle:currentAngle]);
              CGContextAddLineToPoint(context,centerPoint.x+[self parseToX:radius-25*scoleNum Angle:currentAngle], centerPoint.y+[self parseToY:radius-25*scoleNum Angle:currentAngle]);
        }
    }
}

/*
 * setGaugeValue 移动到某个数值
 * @value CGFloat 移动到的数值
 * @isAnim BOOL   是否执行动画
 */
-(void)setGaugeValue:(CGFloat)value animation:(BOOL)isAnim
{
    CGFloat tempAngle = [self parseToAngle:value];
    gaugeValue = value;
    //设置转动时间和转动动画
    if(isAnim){
        [self pointToAngle:tempAngle Duration:0.6f];
    }else
    {
        [self pointToAngle:tempAngle Duration:0.0f];
    }
}
-(void)UpdateUI{
    [self setNeedsDisplay];
}
/*
 * pointToAngle 按角度旋转
 * @angel CGFloat 角度
 * @duration CGFloat 动画执行时间
 */
- (void) pointToAngle:(CGFloat) angle Duration:(CGFloat) duration
{
    CAKeyframeAnimation *anim=[CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
    NSMutableArray *values=[NSMutableArray array]; 
    anim.duration = duration;
    anim.autoreverses = NO;
    anim.fillMode = kCAFillModeForwards;
    anim.removedOnCompletion= NO;
    pointer.transform = CGAffineTransformMakeScale(0.3, 0.3);
    CGFloat distance = angle/10;
    //设置转动路径，不能直接用 CABaseAnimation 的toValue，那样是按最短路径的，转动超过180度时无法控制方向
    int i = 1;
    for(;i<=10;i++){
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*i)], 0, 0, 1)]];
        }
    //添加缓动效果
     [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i))], 0, 0, 1)]];
     [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i-2))], 0, 0, 1)]];     
     [values addObject:[NSValue valueWithCATransform3D:CATransform3DRotate(CATransform3DIdentity, [self transToRadian:(gaugeAngle+distance*(i-1))], 0, 0, 1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(
                                                                             
                                                                             0.3, 0.3, 0.3)]];
    
    anim.values=values;
    [pointer.layer setSublayerTransform:(CATransform3DMakeScale(0.3, 0.3, 0.3))];
    [pointer.layer addAnimation:anim forKey:@"cubeIn"];
    
    gaugeAngle = gaugeAngle+angle;
    
}

/*
 * parseToX 角度转弧度
 * @angel CGFloat 角度
 */
-(CGFloat)transToRadian:(CGFloat)angel
{
    return angel*M_PI/180;
}




/*
 * parseToX 根据角度，半径计算X坐标
 * @radius CGFloat 半径  
 * @angle  CGFloat 角度
 */
- (CGFloat) parseToX:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*cos(tempRadian);
}

/*
 * parseToY 根据角度，半径计算Y坐标
 * @radius CGFloat 半径  
 * @angle  CGFloat 角度
 */
- (CGFloat) parseToY:(CGFloat) radius Angle:(CGFloat)angle
{
    CGFloat tempRadian = [self transToRadian:angle];
    return radius*sin(tempRadian);
}

/*
 * parseToAngle 根据数据计算需要转动的角度
 * @val CGFloat 要移动到的数值
 */
-(CGFloat) parseToAngle:(CGFloat) val
{
	//异常的数据
	if(val<minNum){
		return minNum;
	}else if(val>maxNum){
		return maxNum;
	}
	CGFloat temp =(val-gaugeValue)*angleperValue;
	return temp;
}

/*
 * parseToValue 根据角度计算数值
 * @val CGFloat 要移动到的角度
 */
-(CGFloat) parseToValue:(CGFloat) val
{
	CGFloat temp=val/angleperValue;
	CGFloat temp2=maxNum/2+temp;
	if(temp2>maxNum){
		return maxNum;
	}else if(temp2<maxNum){
		return maxNum;
	}
	return temp2;
}

- (void)drawRect:(CGRect)rect 
{
    //获取上下文
    context = UIGraphicsGetCurrentContext();
    //设置背景透明
    CGContextSetFillColorWithColor(context,self.backgroundColor.CGColor);
	CGContextFillRect(context, rect);
    //绘制仪表背景    
    [[self gaugeView ]drawInRect:self.bounds];
    //绘制刻度
    [self setLineMark:CELLNUM*CELLMARKNUM];
		
	CGContextStrokePath(context);
}

@end
