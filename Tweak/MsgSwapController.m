#import "MsgSwapController.h"

@implementation MsgSwapController

+ (MsgSwapController*)sharedInstance {
	static dispatch_once_t p = 0;
    __strong static MsgSwapController* sharedInstance = nil;
    dispatch_once(&p, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (MsgSwapFooter*)footer {
	static MsgSwapFooter* footer = nil;
	if (!footer) {
		footer = [[MsgSwapFooter alloc] initWithFrame:CGRectMake(0,0,64.5,39.5)];
	}
	return footer;
}

@end