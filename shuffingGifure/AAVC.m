//
//  AAVC.m
//  shuffingGifure
//
//  Created by 大麦 on 16/4/2.
//  Copyright © 2016年 lsp. All rights reserved.
//

#import "AAVC.h"
@interface AAVC ()

@end

@implementation AAVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    //    NSArray *imageArray = @[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"]];
    //    NSArray *imageArray = @[[UIImage imageNamed:@"1.jpg"]];
    
    
    NSArray *imageArray = @[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"]];
    [self.QQ dataSourceWithImageArray:imageArray andDelegate:self andTimeInterval:3.0];
    self.QQ.pageControl.hidden = NO;
    
    
//    PHShufflingFigureView *alv = [[PHShufflingFigureView alloc] initWithFrame:CGRectMake(0, 0, 120,100)];
//    [alv dataSourceWithImageArray:imageArray andDelegate:self andTimeInterval:0.0];
    
    
}
#pragma PHShufflingFigureDataSourceDelegate methods
-(void)clickimageViewIndex:(int)index
{
    NSLog(@"点击了%d",index);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
