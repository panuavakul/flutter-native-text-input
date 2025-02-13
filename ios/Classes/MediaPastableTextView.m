#import "MediaPastableTextView.h"

@implementation MediaPastableTextView {
    FlutterMethodChannel* _channel;
}

- (instancetype)initWithFrame:(CGRect)frame channel:(FlutterMethodChannel*)channel
{
    NSLog(@"Calling Constructor");
    self = [super initWithFrame:frame];
    if(self){
        _channel = channel;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))
        return YES;
    else
        return [super canPerformAction:action withSender:sender];
}

- (void)paste:(id)sender
{
    NSLog(@"IN HERE");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    // NSLog(@"%i", pasteboard.numberOfItems);
    // NSLog(@"%@", pasteboard.items);
    if (pasteboard.image) {
        NSLog(@"This is image");
        // If the file is GIF, we have to look for "com.compuserve.gif" and deal with it with data
        // For the rest of the images (and GIF for now), convert them to PNG and send them as base64

        // Try this out with 1 image first
        UIImage *image = pasteboard.image;
        // to Png
        NSData *imageData = UIImagePNGRepresentation(image);
        // Convert to FlutterStandardTypedData
        FlutterStandardTypedData *flutterData = [FlutterStandardTypedData typedDataWithBytes:imageData];
        // Send to Flutter
        [_channel invokeMethod:@"onImagesPasted" arguments:@{ @"data": flutterData }];
    } else {
        NSLog(@"This is NOT image");
        [super paste:sender];
    }
}

@end