#import <UIKit/UIKit.h>

//https://stackoverflow.com/a/5337804
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface PKHostPlugIn : NSObject
@end

@interface IMBalloonPlugin : NSObject 
@property (nonatomic,retain) PKHostPlugIn* plugin;   
@end

@interface IMBalloonAppExtension : NSObject
@property (nonatomic,retain) NSString* containingBundleIdentifier;   
@end

@interface CKBalloonPluginManager : NSObject
+(id)sharedInstance;
@property (nonatomic,readonly) NSArray * visibleDrawerPlugins;      
@end

@interface CKTranscriptCollectionViewController : UIViewController
@end

@interface CKBrowserPluginCell : UICollectionViewCell
@property (nonatomic,retain) IMBalloonPlugin * plugin;
-(void)setPlugin:(IMBalloonPlugin *)arg1;
@end

@interface CKAppStripLayout : UICollectionViewLayout
@end

@interface CKBrowserSwitcherFooterView : UIView
@property (assign,nonatomic) id delegate;        
@property (assign,nonatomic) id dataSource;     
@property (assign,nonatomic) BOOL isMagnified;                                         
@property (assign,nonatomic) BOOL hideShinyStatus;                                     
@property (assign,nonatomic) BOOL showBorders;                 
@property (nonatomic,retain) CKAppStripLayout * appStripLayout;                     
@property (assign,nonatomic) BOOL minifiesOnSelection;                
@property (assign,nonatomic) BOOL isMinifyingOnTranscriptScroll;                 
@property (assign,nonatomic) double snapshotVerticalOffset;        
-(UICollectionView*)collectionView;   
@end

@interface CKEntryViewButton : UIButton // UIView (iOS 13) || UIButton (iOS 12)
@property (nonatomic,retain) UIButton * button; // iOS 13
@end

@interface CKMessageEntryContentView : UIView
@end

@interface CKMessageEntryView : UIView
@property (nonatomic,retain) CKEntryViewButton * photoButton;  //camera
@property (nonatomic,retain) CKEntryViewButton * browserButton; //toggles appstrip
@property (nonatomic,retain) CKEntryViewButton * arrowButton;   //caret
@property (nonatomic,retain) CKBrowserSwitcherFooterView * appStrip;
@property (nonatomic,retain) UIView * buttonAndTextAreaContainerView; 
@property (nonatomic,retain) UIView * inputButtonContainerView; 
@property (nonatomic,retain) CKMessageEntryContentView * contentView; 
@end
