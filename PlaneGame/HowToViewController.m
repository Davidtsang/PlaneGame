//
//  HowToViewController.m
//  PlaneGame
//
//  Created by user on 15/3/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import "HowToViewController.h"
#import "ViewController.h"

@interface HowToViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation HowToViewController
- (IBAction)cancelAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.font =[UIFont fontWithName:kGameFontBold size:kAppFontLarge];
    
    self.textView.font = [UIFont fontWithName:kGameFont size:kAppFontSmall];
    
    self.textView.text =NSLocalizedString(@"1. Each stage have three planes in the map.\n2. Find and destroy them all, you win.\n3. Each round, the remaining planes will attack you, each plane  will make you lose a 1 point HP.\n4. HP to 0, the game is over.\n5. The plane hit the head (red dots), this plane will lose the ability\n to attack you.", nil);
    
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
