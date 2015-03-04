//
//  ShareViewController.m
//  WakeMe
//
//  Created by Connecting Pixels on 01/07/13.
//
//

#import "ShareViewController.h"
#import <Twitter/TWTweetComposeViewController.h>
#import <Social/Social.h>


#import <Accounts/Accounts.h>

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize fbGraph;

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
    [GPPShare sharedInstance].delegate = self;
    if (![GPPSignIn sharedInstance].authentication ||
        ![[GPPSignIn sharedInstance].scopes containsObject:
          kGTLAuthScopePlusLogin]) {
        }
}

-(void)loginFromFB
{
    /*Facebook Application ID*/
    NSString *client_id = @"155964377892948";
    
    //alloc and initalize our FbGraph instance
    self.fbGraph = [[FbGraph alloc] initWithFbClientID:client_id];
    
    //begin the authentication process.....
    [self.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:)
                              andExtendedPermissions:@"user_photos,email,user_hometown"];
}
-(void)fbGraphCallback:(id)sender
{
    if ( (self.fbGraph.accessToken == nil) || ([self.fbGraph.accessToken length] == 0) ) {
		
        //restart the authentication process.....
		[self.fbGraph authenticateUserWithCallbackObject:self andSelector:@selector(fbGraphCallback:)
                                  andExtendedPermissions:@"email"];
		
	}
    else {
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        [params setObject:@"Hi you will love your alarm clock with this cool app." forKey:@"message"];
//        [params setObject:@"link" forKey:@"type"];
//        [params setObject:@"http://yoursite.com" forKey:@"link"];
//        [params setObject:@"Link description" forKey:@"description"];
                
        [self.fbGraph doGraphPost:@"me/feed" withPostVars:params];
    }
}
- (IBAction)sharingOptions:(id)sender {
    
    if([sender tag] == 0)
    {
        //fb
        if(VERSION >= 6.0)
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                
                [controller setInitialText:@"Hi you will love your alarm clock with this cool app."];
                //            [controller addURL:[NSURL URLWithString:@"http://www.appcoda.com"]];
                //            [controller addImage:[UIImage imageNamed:@"socialsharing-facebook-image.jpg"]];
                
                [self presentViewController:controller animated:YES completion:Nil];
            }
        }
        else
        {
            [self loginFromFB];
        }
    }
    else if([sender tag] == 1)
    {
        //twitter
        if(VERSION >= 6.0)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:@"Hi you will love your alarm clock with this cool app."];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
        }
        else
        {
            if ([TWTweetComposeViewController canSendTweet])
            {
                TWTweetComposeViewController *tweetSheet = [[[TWTweetComposeViewController alloc] init] autorelease];
                [tweetSheet setInitialText:@"Hi you will love your alarm clock with this cool app."];
                [self presentModalViewController:tweetSheet animated:YES];
            }
        }
    }
    else
    {
        //gplus
        
        [GPPShare sharedInstance].delegate = self;
        id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];

//        NSString *inputURL = @"http://google.com";
//        NSURL *urlToShare = [inputURL length] ? [NSURL URLWithString:inputURL] : nil;
//        if (urlToShare) {
//            [shareBuilder setURLToShare:urlToShare];
//        }
        
        [shareBuilder setPrefillText:@"Hi you will love your alarm clock with this cool app."];
        [shareBuilder open];
    }
}

- (void)finishedSharing:(BOOL)shared {
    NSString *text = shared ? @"Success" : @"Canceled";
    NSLog(@"%@",text);
}
- (IBAction)done:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
