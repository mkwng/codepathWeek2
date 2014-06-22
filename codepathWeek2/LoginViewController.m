//
//  LoginViewController.m
//  codepathWeek2
//
//  Created by Michael Wang on 6/21/14.
//  Copyright (c) 2014 mkwng. All rights reserved.
//

#import "LoginViewController.h"
#import "newsfeedViewController.h"
#import "PeopleViewController.h"
#import "MessagesViewController.h"
#import "NotificationsViewController.h"
#import "MoreViewController.h"


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
- (IBAction)tapGesture:(id)sender;
- (IBAction)editingChanged;



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
    

    
    self.loginButton.alpha=.5;
    [self.loginButton setEnabled:NO];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    
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
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"logging_in_button"] forState:UIControlStateDisabled];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"logging_in_button"] forState:UIControlStateNormal];

    [UIView
     animateWithDuration:1
     delay:1
     options:UIViewAnimationOptionCurveLinear
     animations:^{
         self.emptyLabel.alpha=0;
     }
     completion:^(BOOL finished) {
        if ([self.passwordTextField.text isEqualToString:@"password"])
            [self loginSuccess];
        else
            [self loginFail];
    }];


}

- (IBAction)tapGesture:(id)sender {
    [self.view endEditing:YES];
}



- (void) loginSuccess {
    
    UIViewController *feedVc = [[newsfeedViewController alloc] init];
    UIViewController *peopleVc = [[PeopleViewController alloc] init];
    UIViewController *messagesVc = [[MessagesViewController alloc] init];
    UIViewController *notificationsVc = [[NotificationsViewController alloc] init];
    UIViewController *moreVc = [[MoreViewController alloc] init];
    
    UINavigationController *feedNc = [[UINavigationController alloc] initWithRootViewController:feedVc];
    feedNc.navigationBar.barTintColor = [UIColor colorWithRed:.23 green:.35 blue:.60 alpha:1];
    feedNc.navigationBar.tintColor = [UIColor whiteColor];
    NSShadow *shadow = [[NSShadow alloc] init];
    NSDictionary *titleTextAttributes =
    @{
      NSFontAttributeName : [UIFont boldSystemFontOfSize:16],
      NSForegroundColorAttributeName : [UIColor whiteColor],
      NSShadowAttributeName : shadow
      };
    feedNc.navigationBar.titleTextAttributes = titleTextAttributes;

    
    
    feedNc.tabBarItem.title = @"News Feed";
    feedNc.tabBarItem.image = [UIImage imageNamed:@"tab_newsfeed"];
    peopleVc.tabBarItem.title = @"People";
    peopleVc.tabBarItem.image = [UIImage imageNamed:@"tab_people"];
    messagesVc.tabBarItem.title = @"Messages";
    messagesVc.tabBarItem.image = [UIImage imageNamed:@"nav_messengerglyph"];
    notificationsVc.tabBarItem.title = @"Notifications";
    notificationsVc.tabBarItem.image = [UIImage imageNamed:@"tab_notifications"];
    moreVc.tabBarItem.title = @"More";
    moreVc.tabBarItem.image = [UIImage imageNamed:@"tab_more"];

    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[feedNc,peopleVc,messagesVc,notificationsVc,moreVc];
    
    [self presentViewController:tabBarController animated:YES completion:nil];

    
    
    
//    feedVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    
//    [self presentViewController:feedVc animated:NO completion:nil];
}

- (void) loginFail {
    [self shakeLogin];
    [self.loginActivityIndicator stopAnimating];
    self.loginButton.enabled = YES;
    self.loginTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.signupLabel.alpha=1;
    self.emptyLabel.alpha=1;
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_button_disabled"] forState:UIControlStateDisabled];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"login_button_disabled"] forState:UIControlStateNormal];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Incorrect password" message:@"Please make sure you typed your password correctly." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
    
}

-(void)shakeLogin {
    
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.08];
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
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    [UIView animateWithDuration:animationDuration
     delay:0.0
     options:(animationCurve << 16)
     animations:^{
            CGRect containerFrame = self.containerView.frame;
            containerFrame.origin.y -= 40;
            self.containerView.frame = containerFrame;
            
            CGRect labelFrame = self.signupLabel.frame;
            labelFrame.origin.y -= 116;
            self.signupLabel.frame = labelFrame;
      }
     completion:nil
     ];

}

-(void)keyboardDidHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the keyboard height and width from the notification
    // Size varies depending on OS, language, orientation
//    CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    NSLog(@"Height: %f Width: %f", kbSize.height, kbSize.width);
    
    // Get the animation duration and curve from the notification
    NSNumber *durationValue = userInfo[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = durationValue.doubleValue;
    NSNumber *curveValue = userInfo[UIKeyboardAnimationCurveUserInfoKey];
    UIViewAnimationCurve animationCurve = curveValue.intValue;
    
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:(animationCurve << 16)
                     animations:^{
                         CGRect containerFrame = self.containerView.frame;
        containerFrame.origin.y += 40;
        self.containerView.frame = containerFrame;
        
        CGRect labelFrame = self.signupLabel.frame;
        labelFrame.origin.y += 116;
        self.signupLabel.frame = labelFrame;
                     } completion:nil ];

}

- (IBAction)editingChanged {
    if ([self.loginTextField.text length] != 0 && [self.passwordTextField.text length] != 0 ) {
        [self.loginButton setEnabled:YES];
        self.loginButton.alpha = 1;
    }
    else {
        [self.loginButton setEnabled:NO];
        self.loginButton.alpha = .5;
    }
}

@end
