#import "MediaPastableTextView.h"

@implementation MediaPastableTextView {
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame channel:(FlutterMethodChannel*)channel
{
    self = [super initWithFrame:frame];
    if(self){
        _channel = channel;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
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
        for(NSObject* image in pasteboard.images){
            // turn it into UIImagePNGRepresentation
            NSData *imageData = UIImagePNGRepresentation(image);
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
