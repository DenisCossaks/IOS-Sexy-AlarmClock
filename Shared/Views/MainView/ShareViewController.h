//
//  ShareViewController.h
//  WakeMe
//
//  Created by Connecting Pixels on 01/07/13.
//
//

#import <UIKit/UIKit.h>
#import "FbGraph.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface ShareViewController : UIViewController<GPPShareDelegate>

@property (nonatomic, retain) FbGraph *fbGraph;

- (IBAction)sharingOptions:(id)sender;
- (IBAction)done:(id)sender;
@end
