//
//  ViewController.m
//  Socializer
//
//  Created by Alexey Ivanov on 09.04.14.
//  Copyright (c) 2014 Alexey Ivanov. All rights reserved.
//

#import "ViewController.h"

#import "Socializer.h"
#import "NSString+Additions.h"

typedef enum SocialButtonTags {
    SocialButtonTwitter,
    SocialButtonFacebook,
    SocialButtonVkontakte,
    SocialButtonGoogle
} SocialButtonTags;

@interface ViewController () <SocializerDelegate,UIActionSheetDelegate>

@end

@implementation ViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Socializer sharedManager].delegate = self;
    
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateUI)];
    [self.navigationItem setRightBarButtonItem:updateButton];
    //add observer for twitter accounts store
    if ([[Socializer sharedManager].socialIdFromDefaults isEqualToString:@"Twitter"]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_refreshTwitterAccounts) name:ACAccountStoreDidChangeNotification object:nil];
    }
    
    
	[self updateUI];
}

-(void)viewWillDisappear:(BOOL)animated{
    //remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                [self _refreshTwitterAccounts];
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
    NSLog(@"successAuthorizedTwitter");
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

#pragma mark - Twitter 
- (void)_refreshTwitterAccounts
{
    NSLog(@"Refreshing Twitter Accounts \n");
    
    if (![TWAPIManager isLocalTwitterAccountAvailable]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:@"You must add a Twitter account in Settings.app"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        [[Socializer sharedManager] obtainAccessToAccountsWithBlock:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    NSLog(@"GRANTED!");
                    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose an Account"
                                                                       delegate:self
                                                              cancelButtonTitle:nil
                                                         destructiveButtonTitle:nil
                                                              otherButtonTitles:nil];
                    for (ACAccount *account in [Socializer sharedManager].twitterAccounts) {
                        [sheet addButtonWithTitle:account.username];
                    }
                    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
                    [sheet showInView:self.view];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title" message:@"You were not granted access to the Twitter accounts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    NSLog(@"You were not granted access to the Twitter accounts.");
                }
            });
        }];
    }
}


#pragma mark - UIActionSheet Delegation methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [[Socializer sharedManager].twitterAPIManager performReverseAuthForAccount:[Socializer sharedManager].twitterAccounts[buttonIndex]
                                                                withHandler:^(NSData *responseData, NSError *error) {
            if (responseData) {
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                NSLog(@"Reverse Auth process returned: %@", responseStr);
                
                NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
                NSString *lined = [parts componentsJoinedByString:@"\n"];
                NSString *token = [responseStr stringBetweenString:@"oauth_token=" andString:@"&"];
                NSString *userId = [responseStr stringBetweenString:@"user_id=" andString:@"&"];
                NSString *screenName = [responseStr stringBetweenString:@"screen_name=" andString:@"&"];
                [Socializer sharedManager].socialIdentificator = kTwitterIdentifier;
                [Socializer sharedManager].socialAccessToken = token;
                [Socializer sharedManager].socialUserId = userId;
                [Socializer sharedManager].socialUsername = screenName;
                
                [[Socializer sharedManager] saveAuthUserDataToDefaults];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [self updateUI];
                });
            }
            else {
                NSLog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
            }
        }];
    }

}
#pragma mark - helpers


#pragma mark -didReceiveMemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
