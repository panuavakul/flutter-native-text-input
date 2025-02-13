#import "MediaPastableTextView.h"

@implementation MediaPastableTextView {
    FlutterMethodChannel* _channel;
    NSNumber* _maxImagesPasted;
    NSNumber* _alwayEnablePaste;
}

- (instancetype)initWithFrame:(CGRect)frame
                      channel:(FlutterMethodChannel*)channel
                    arguments:(id _Nullable)args
{
    self = [super initWithFrame:frame];
    if(self){
        _channel = channel;
        _maxImagesPasted = args[@"maxImagesPasted"];
        _alwayEnablePaste = args[@"alwayEnablePaste"];
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    if ((action == @selector(paste:)) && (_alwayEnablePaste.boolValue))
        // Always show the paste button
        return YES;
    else
        // Leave the rest to default behavior
        return [super canPerformAction:action withSender:sender];
}

- (void)paste:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // Only Check the first image if it's an image
    if (pasteboard.image) {
        NSArray *data = [NSArray array];

        // Max number of images that should be sent to Flutter
        NSUInteger maxImagesPasted = [_maxImagesPasted isKindOfClass:[NSNull class]] ? pasteboard.images.count : [_maxImagesPasted integerValue];
        for (NSUInteger index = 0; index < maxImagesPasted; index++) {
            // turn it into UIImagePNGRepresentation
            NSData *imageData = UIImagePNGRepresentation(pasteboard.images[index]);
            // Convert to FlutterStandardTypedData
            FlutterStandardTypedData *flutterData = [FlutterStandardTypedData typedDataWithBytes:imageData];
            // Add to the array
            data = [data arrayByAddingObject:flutterData];
        }

        [_channel invokeMethod:@"onImagesPasted" arguments:@{ @"data": data }];
    } else {
        [super paste:sender];
    }
}

@end
