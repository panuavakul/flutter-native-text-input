#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaPastableTextView : UITextView

- (instancetype)initWithFrame:(CGRect)frame channel:(FlutterMethodChannel*)channel;

@end

NS_ASSUME_NONNULL_END
