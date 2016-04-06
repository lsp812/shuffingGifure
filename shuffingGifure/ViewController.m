//
//  ViewController.m
//  shuffingGifure
//
//  Created by 大麦 on 16/4/2.
//  Copyright © 2016年 lsp. All rights reserved.
//

#import "ViewController.h"
#import "PHShufflingFigureView.h"
#import "AAVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self create];
}

-(void)create
{
    AAVC *vc = [[AAVC alloc]initWithNibName:@"AAVC" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
//    TestViewController *vc = [[TestViewController alloc]initWithNibName:@"TestViewController" bundle:nil];
//    [self presentViewController:vc animated:YES completion:nil];
}

@end
