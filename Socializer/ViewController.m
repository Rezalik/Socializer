//
//  ViewController.m
//  Socializer
//
//  Created by Alexey Ivanov on 09.04.14.
//  Copyright (c) 2014 Alexey Ivanov. All rights reserved.
//

#import "ViewController.h"

#import "Socializer.h"


typedef enum SocialButtonTags {
    SocialButtonTwitter,
    SocialButtonFacebook,
    SocialButtonVkontakte,
    SocialButtonGoogle
} SocialButtonTags;

@interface ViewController () <SocializerDelegate>

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Socializer sharedManager].delegate = self;
    
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateUI)];
    [self.navigationItem setRightBarButtonItem:updateButton];
    
	[self updateUI];
}

-(void)updateUI{
    NSLog(@"updating UI");
    if ([Socializer sharedManager].isAuthorizedAnySocial) {
        //set labels
        self.socialFullUserNameLabel.text =[[Socializer sharedManager] socialUsername];
        self.socialFullUserNameLabel.hidden = NO;
        self.socialIdentifierLabel.text =[NSString stringWithFormat:@"Authorized via %@",[[Socializer sharedManager]socialIdentificator]];
        self.socialIdentifierLabel.hidden = NO;
        self.socialTokenTextField.text = [[Socializer sharedManager] socialAccessToken];
        self.socialTokenTextField.hidden = NO;
        self.socialUserEmailLabel.text = [[Socializer sharedManager] socialUserEmail];
        self.socialUserEmailLabel.hidden = NO;
        //hide buttons
        self.twitterButton.hidden = YES;
        self.facebookButton.hidden = YES;
        self.googleButton.hidden = YES;
        self.vkButton.hidden = YES;
        self.logoutButton.hidden =NO;
    
    }else{
        //hide labels
        self.socialFullUserNameLabel.hidden = YES;
        self.socialIdentifierLabel.hidden = YES;
        self.socialTokenTextField.hidden = YES;
        self.socialUserEmailLabel.hidden = YES;
        //show buttons
        self.twitterButton.hidden = NO;
        self.facebookButton.hidden = NO;
        self.googleButton.hidden = NO;
        self.vkButton.hidden = NO;
        self.logoutButton.hidden = YES;
    }
    
}


- (IBAction)socialButtonPressed:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        switch (((UIButton*)sender).tag) {
            case SocialButtonTwitter:
                [[Socializer sharedManager] loginTwitter];
                break;
            case SocialButtonFacebook:
                [[Socializer sharedManager]  loginFacebook];
                break;
            case SocialButtonVkontakte:
                [[Socializer sharedManager]  loginVK];
                break;
            case SocialButtonGoogle:
                [[Socializer sharedManager]  loginGoogle];
            default:
                break;
        }
    }
}
- (IBAction)logoutButtonPressed:(id)sender {
    [[Socializer sharedManager] logOutFromCurrentSocial];
}


#pragma mark - SocializerDelegate methods
-(void)successAuthorizedFacebook{
    [self updateUI];
}
-(void)successAuthorizedGoogle{
    [self updateUI];
}
-(void)successAuthorizedTwitter{
    [self updateUI];
}

-(void)successAuthorizedVK{
    [self updateUI];
}
-(void)failureAuthorization{
    [self updateUI];
}

-(void)successLogout{
    NSLog(@"successLogout");
    [self updateUI];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
