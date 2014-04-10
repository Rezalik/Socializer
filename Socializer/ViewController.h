//
//  ViewController.h
//  Socializer
//
//  Created by Alexey Ivanov on 09.04.14.
//  Copyright (c) 2014 Alexey Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *kVkontakteIdentifier;
extern NSString *kGoogleIdentifier;
extern NSString *kTwitterIdentifier;
extern NSString *kFacebookIdentifier;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *socialIdentifierLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialFullUserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialUserEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *socialTokenTextField;

//buttons
@property (weak, nonatomic) IBOutlet UIButton *vkButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *googleButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;



@end
