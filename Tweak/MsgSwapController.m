
#import "MsgSwapController.h"

@implementation MsgSwapController

+ (MsgSwapController*)sharedInstance {
	static dispatch_once_t p = 0;
    __strong static MsgSwapController* sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (MsgSwapFooter*)footer {
	static MsgSwapFooter* footer = nil;
	if (!footer) {
		footer = [[MsgSwapFooter alloc] initWithFrame:CGRectMake(0,0,64.5,39.5)];
	}
	return footer;
}

@end