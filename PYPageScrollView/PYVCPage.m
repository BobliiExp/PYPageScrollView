//
//  PYVCPage.m
//  PYPageScrollView
//
//  Created by Bob Lee on 2018/4/6.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYVCPage.h"

@interface PYVCPage ()

@property (weak, nonatomic) IBOutlet UILabel *labDesc;

@end

@implementation PYVCPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)updateDesc:(NSString*)desc {
    self.labDesc.text = desc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
