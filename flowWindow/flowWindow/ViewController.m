//
//  ViewController.m
//  flowWindow
//
//  Created by mincj on 2017/4/13.
//  Copyright © 2017年 mincj. All rights reserved.
//

#import "ViewController.h"
#import "CFlowViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 50)];
    [btn setTitle:@"next" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nextVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)nextVC:(id)sender{
    CFlowViewController* vc = [[CFlowViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
