//
//  MainPageViewController.m
//  FaceShowApp
//
//  Created by niuzhaowang on 2017/9/13.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "MainPageViewController.h"

@interface MainPageViewController ()

@end

@implementation MainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIButton *b1 = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 50)];
    [b1 setTitle:@"button1" forState:UIControlStateNormal];
    [b1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b1 addTarget:self action:@selector(btn1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b1];
    
    UIButton *b2 = [[UIButton alloc]initWithFrame:CGRectMake(10, 100, 100, 50)];
    [b2 setTitle:@"button2" forState:UIControlStateNormal];
    [b2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b2 addTarget:self action:@selector(btn2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b2];
    
    UIButton *b3 = [[UIButton alloc]initWithFrame:CGRectMake(10, 200, 100, 50)];
    [b3 setTitle:@"button3" forState:UIControlStateNormal];
    [b3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b3 addTarget:self action:@selector(btn3Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b3];
    
    UIButton *b4 = [[UIButton alloc]initWithFrame:CGRectMake(10, 300, 100, 50)];
    [b4 setTitle:@"button4" forState:UIControlStateNormal];
    [b4 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b4 addTarget:self action:@selector(btn4Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:b4];
}

- (void)btn1Action {
    
}
- (void)btn2Action {
    
}
- (void)btn3Action {
    
}
- (void)btn4Action {
    
}

@end
