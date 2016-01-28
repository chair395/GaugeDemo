//
//  ViewController.h
//  GaugeDemo
//
//  Created by 海锋 周 on 12-3-27.
//  Copyright (c) 2012年 CJLU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Gauge.h"
@interface ViewController : UIViewController
{
    IBOutlet UISlider *sl;
    IBOutlet UIButton *button;
}
@property (strong, nonatomic) IBOutlet UISwitch *SwitchBtn;
@property (nonatomic,retain) Gauge *test;
@property (nonatomic,retain)  IBOutlet UISlider *sl;
@property (nonatomic,retain)  IBOutlet UIButton *button;
-(IBAction)change :(id)sender;
@end
