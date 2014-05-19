Socializer
==========
Socializer is an iOS class for easy authorization and getting user data (access token,user name, user id, email) from vk.com, Google+, Facebook, Twitter.
## Adding to your project
 Open your project in Xcode, drag and drop onto your project (use the 'Product Navigation view' in xcode). Make sure to select Copy items when asked if you extracted the code archive outside of your project.
+ 'Socializer.h & .m'
+ 'ABOAuthCore folder'
+ 'TWSignedRequest.h & .m'
+ 'NSString+Additions.h & .m'
+ 'TWAPIManager.h & .m'

##Set up project
### Get developer app keys 
Follow step by step guides for integration each social network 
- Vk.com  https://vk.com/dev/ios_sdk
- Facebook https://developers.facebook.com/docs/ios/getting-started
- Google plus https://developers.google.com/+/mobile/ios/getting-started
- Twitter auth use reverse auth by Sean Cook https://github.com/seancook/TWReverseAuthExample, so all you have to do is just create new app in dev.twitter.com, add Social.framework and make sure that you copied 'ABOAuthCore folder','TWSignedRequest.h & .m','NSString+Additions.h & .m','TWAPIManager.h & .m'

###Set appID and secrets 
- Set "kTwitterAPIKey" and "kTwitterAPISecret" in 'TWSignedRequest.m'
- Set "kGoogleClientID", "kGoogleClientSecret", kKeychainItemName, kVKAppId, kFacebookAppID in 'Socializer.m' (:18-:27 lines)

#Usage
Include Socializer wherever you need it with #import "Socializer.h". 
####SocialDelegate methods
- (void)successAuthorizedVK;
- (void)successAuthorizedFacebook;
- (void)successAuthorizedGoogle;
- (void)successAuthorizedTwitter;
- (void)successLogout;
- (void)failureAuthorization;

####Login methods
- (void)loginVK;
- (void)loginTwitterAccountAtIndex:(NSInteger)index;
- (void)loginFacebook;
- (void)loginGoogle;

