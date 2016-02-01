//
//  ViewController.m
//  GaugeDemo
//
//  Created by 海锋 周 on 12-3-27.
//  Copyright (c) 2012年 CJLU. All rights reserved.
//

#import "ViewController.h"
#import "Gauge.h"
@implementation ViewController
@synthesize test1,test2,sl,button;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSInteger scaleNum=1;
	// Do any additional setup after loading the view, typically from a nib.
    test1 = [[Gauge alloc]initWithFrame:CGRectMake(200, 400, 100,100) isInner:YES];
    test1.backgroundColor=[UIColor redColor];
    [self.view addSubview:test1];
    
//    
    test2= [[Gauge alloc]initWithFrame:CGRectMake(500, 400, 100,100) isInner:YES];
    test2.backgroundColor=[UIColor yellowColor];
   
     [self.view addSubview:test2];
    
    
}
- (IBAction)StateChange:(id)sender {
    
   BOOL  isInnerBool= [((UISwitch *)sender) isOn];

    [test1 removeFromSuperview];
    test1 = [[Gauge alloc]initWithFrame:CGRectMake(200, 400, 100,100) isInner:YES];
    test1.backgroundColor=[UIColor redColor];
     [self.view addSubview:test1];
  

}

-(IBAction)sliderChange:(id)sender
{
    [test1 setGaugeValue:sl.value animation:NO];
    [test2 setGaugeValue:sl.value animation:NO];
     [button setTitle:[NSString stringWithFormat:@"%d",(int)sl.value] forState:UIControlStateNormal]; 
}



CGPoint originalLocation;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    originalLocation = [touch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.view];
    CGRect frame = self.view.frame;
    frame.origin.x += currentLocation.x-originalLocation.x;
    frame.origin.y += currentLocation.y-originalLocation.y;
    self.view.frame = frame;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =  [touches anyObject];
    if(touch.tapCount == 1)
    {
        [self performSelector:@selector(setBackground:) withObject:[UIColor blueColor] afterDelay:2];
        self.view.backgroundColor = [UIColor redColor];
    }
}
-(void)setBackground:(UIColor *)color{
self.view.backgroundColor = color;
}
-(IBAction)change :(id)sender
{
    int tmp = rand()%120;
    [test1 setGaugeValue:tmp animation:YES];
    [test2 setGaugeValue:tmp animation:YES];
    [button setTitle:[NSString stringWithFormat:@"%d",tmp] forState:UIControlStateNormal]; 
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
