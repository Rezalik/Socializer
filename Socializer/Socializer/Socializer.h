//
//  Socializer.h
//  Socializer
//
//  Created by Alexey Ivanov on 09.04.14.
//  Copyright (c) 2014 Alexey Ivanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "VKSdk.h"
#import "TWAPIManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>



extern NSString* kVKAppId;
extern NSString* kFacebookAppID;

//NSUserDefault keys
extern NSString* kSocializerAuthDict;
extern NSString* kSocializerSocialAccessToken;
extern NSString* kSocializerSocialIdentifier;
extern NSString* kSocializerSocialUserID;
extern NSString* kSocializerSocialUserFullName;
extern NSString* kSocializerSocialUserEmail;

//Social Identifiers
extern NSString *kVkontakteIdentifier;
extern NSString *kGoogleIdentifier;
extern NSString *kTwitterIdentifier;
extern NSString *kFacebookIdentifier;


@protocol SocializerDelegate <NSObject>
- (void)successAuthorizedVK;
- (void)successAuthorizedFacebook;
- (void)successAuthorizedGoogle;
- (void)successAuthorizedTwitter;

- (void)successLogout;
- (void)failureAuthorization;
@end


@interface Socializer : NSObject
@property (weak, nonatomic) id <SocializerDelegate> delegate;

@property (readonly,getter = isAuthorizedAnySocial) BOOL authorizedAnySocial;
@property (nonatomic,strong) NSString *socialAccessToken;
@property (nonatomic,strong) NSString *socialUserId;
@property (nonatomic,strong) NSString *socialUsername;
@property (nonatomic,strong) NSString *socialUserEmail;
@property (nonatomic,strong) NSString *socialIdentificator;
@property (nonatomic,strong) NSString *socialUserAvatar;
@property (nonatomic,strong) ACAccountStore *accountStore;
@property (nonatomic,strong) ACAccount *twitterAccount;
@property (nonatomic,strong)  FBSession *fbSession;
@property (nonatomic,strong)  GPPSignIn *googleSignIn;
@property (nonatomic, strong) TWAPIManager *twitterAPIManager;
@property (nonatomic,strong) NSArray* twitterAccounts;


//Singleton
+ (Socializer*)sharedManager;

//Log IN methods
-(void)loginVK;
-(void)loginTwitterAccountAtIndex:(NSInteger)index;
-(void)loginFacebook;
-(void)loginGoogle;

- (void)obtainAccessToAccountsWithBlock:(void (^)(BOOL))block;
//Log OUT methods
-(void)logOutFromCurrentSocial;


//Local storage manager
- (NSString*)socialTokenFromDefaults;
- (NSString*)socialIdFromDefaults;
- (NSString*)socialUserEmailFromDefaults;
- (NSString*)socialUserNameFromDefaults;
- (NSString*)socialUserIdFromDefaults;

- (void)saveAuthUserDataToDefaults;
- (void)removeAuthDataFromDefaults;

@end
