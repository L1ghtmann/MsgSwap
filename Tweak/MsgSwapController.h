#import "Headers.h"
#import "MsgSwapFooter.h"

@interface MsgSwapController : UIViewController
+ (MsgSwapController*)sharedInstance;
- (MsgSwapFooter*)footer;
@end
