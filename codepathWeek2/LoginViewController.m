//
//  LoginViewController.m
//  codepathWeek2
//
//  Created by Michael Wang on 6/21/14.
//  Copyright (c) 2014 mkwng. All rights reserved.
//

#import "LoginViewController.h"
#import "FeedViewController.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *emptyLabel;

@property (weak, nonatomic) IBOutlet UIView *loginContainerView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *signupLabel;

- (IBAction)onLogin:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    self.loginButton.alpha=.75;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    
    [self.view endEditing:YES];
    [self.loginActivityIndicator startAnimating];
    self.loginButton.enabled = NO;
    self.loginTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.signupLabel.alpha=.75;

    [UIView
     animateWithDuration:1
     delay:1
     options:UIViewAnimationOptionCurveLinear
     animations:^{
         self.emptyLabel.alpha=0;
     }
     completion:^(BOOL finished) {
        if ([self.loginTextField.text isEqualToString:@"hello"] && [self.passwordTextField.text isEqualToString:@"password"])
            [self loginSuccess];
        else
            [self loginFail];
    }];


}



- (void) loginSuccess {
    UIViewController *feedVc = [[FeedViewController alloc] init];
    feedVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:feedVc animated:YES completion:nil];
}

- (void) loginFail {
    [self shakeLogin];
    [self.loginActivityIndicator stopAnimating];
    self.loginButton.enabled = YES;
    self.loginTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.signupLabel.alpha=1;
    self.emptyLabel.alpha=1;
}

-(void)shakeLogin {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.06];
    [shake setRepeatCount:3];
    [shake setAutoreverses:YES];
    [shake setFromValue:[NSValue valueWithCGPoint:
                         CGPointMake(self.loginContainerView.center.x - 12,self.loginContainerView.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                       CGPointMake(self.loginContainerView.center.x + 12, self.loginContainerView.center.y)]];
    [self.loginContainerView.layer addAnimation:shake forKey:@"position"];
}



- (void)keyboardDidShow:(NSNotification *)notification
{
    [UIView animateWithDuration:.6 animations:^{
        CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y -= 40;
        self.containerView.frame = containerFrame;
        
        CGRect labelFrame = self.signupLabel.frame;
        labelFrame.origin.y -= 116;
        self.signupLabel.frame = labelFrame;
    }];

}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.6 animations:^{
        CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y += 40;
        self.containerView.frame = containerFrame;
        
        CGRect labelFrame = self.signupLabel.frame;
        labelFrame.origin.y += 116;
        self.signupLabel.frame = labelFrame;
    }];

}

@end
