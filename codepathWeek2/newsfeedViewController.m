//
//  newsfeedViewController.m
//  codepathWeek2
//
//  Created by Michael Wang on 6/21/14.
//  Copyright (c) 2014 mkwng. All rights reserved.
//

#import "newsfeedViewController.h"

@interface newsfeedViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *feedScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *feedActivityIndicator;



- (void)loadFeed;
@end

@implementation newsfeedViewController

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
    
    self.feedScrollView.alpha = 0;
    self.navigationItem.title = @"News Feed";
    
    // Configure the left button
    //    UIImage *leftButtonImage = [[UIImage imageNamed:@"leftButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:leftButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(onLeftButton:)];
    //    self.navigationItem.leftBarButtonItem = leftButton;
    
    // Configure the right button
        UIImage *rightButtonImage = [[UIImage imageNamed:@"navBar_DivebarIcon_Highlighted_pre_ios_7"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithImage:rightButtonImage style:UIBarButtonItemStylePlain target:self action:nil];
        self.navigationItem.rightBarButtonItem = rightButton;
    
    
    [self performSelector:@selector(loadFeed) withObject:nil afterDelay:3];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFeed
{
    self.feedScrollView.alpha = 1;
    [self.feedActivityIndicator stopAnimating];
    
}

@end
