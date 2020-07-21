#import <UIKit/UIKit.h>

@interface UICollectionView (Private) 
@property (assign,nonatomic) id dataSource;    
@property (assign,nonatomic) id delegate;      
@end

@interface UILongPressGestureRecognizer (Private)
-(void)setView:(UIView *)arg1;
@end

@interface PKHostPlugIn : NSObject
@property (readonly) BOOL active; 
@end

@interface IMBalloonPlugin : NSObject 
@property (nonatomic,retain) PKHostPlugIn* plugin;   
@end

@interface CKBalloonPluginManager : NSObject
+(id)sharedInstance;
@property (nonatomic,readonly) NSArray * visibleDrawerPlugins;         
@end

@interface CKBrowserPluginCell : UICollectionViewCell
-(void)setSelected:(BOOL)arg1 ;
@property (nonatomic,retain) IMBalloonPlugin * plugin;    
-(void)setPlugin:(IMBalloonPlugin *)arg1 ; 
@end

@interface CKAppStripLayout : UICollectionViewLayout
@end

@interface CKBrowserSwitcherFooterView : UIView{
	//UICollectionView* _collectionView; 
	UIView* _visibleView;
	id _animator;
	UILongPressGestureRecognizer* _longPressRecognizer;
	UILongPressGestureRecognizer* _touchTracker;
}
@property (assign,nonatomic) id delegate;        
@property (assign,nonatomic) id dataSource;     
@property (assign,nonatomic) BOOL isMagnified;                                         
@property (assign,nonatomic) BOOL hideShinyStatus;                                     
@property (assign,nonatomic) BOOL showBorders;                 
@property (nonatomic,retain) CKAppStripLayout * appStripLayout;                     
@property (assign,nonatomic) BOOL minifiesOnSelection;                
@property (assign,nonatomic) BOOL isMinifyingOnTranscriptScroll;                 
@property (assign,nonatomic) double snapshotVerticalOffset;           
@end

@interface CKEntryViewButton : UIButton //: UIView (iOS13) -- : UIButton (iOS12)
@property (nonatomic,retain) UIButton * button; //iOS13
@end

@interface CKMessageEntryContentView : UIView
@end

@interface CKMessageEntryView : UIView
-(void)populateArrays;//custom method called later to allow for plugin arrays to populate
@property (nonatomic,retain) CKEntryViewButton * photoButton;  //camera
@property (nonatomic,retain) CKEntryViewButton * browserButton; //opens up appstrip
@property (nonatomic,retain) CKEntryViewButton * arrowButton;   //caret
@property (nonatomic,retain) CKBrowserSwitcherFooterView * appStrip;
@property (nonatomic,retain) UIView * buttonAndTextAreaContainerView; 
@property (nonatomic,retain) UIView * inputButtonContainerView; 
@property (nonatomic,retain) CKMessageEntryContentView * contentView; 
@end

