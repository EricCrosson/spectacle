#import "SpectacleAccessibilityElement.h"
#import "SpectacleWindowMover.h"

@implementation SpectacleWindowMover
{
  id<SpectacleWindowMoverProtocol> _innerWindowMover;
}

- (instancetype)initWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover
{
  if (self = [super init]) {
    _innerWindowMover = innerWindowMover;
  }

  return self;
}

+ (instancetype)newWithInnerWindowMover:(id<SpectacleWindowMoverProtocol>)innerWindowMover
{
  return [[self alloc] initWithInnerWindowMover:innerWindowMover];
}

#pragma mark -

- (CGRect)moveWindowRect:(CGRect)windowRect
           frameOfScreen:(CGRect)frameOfScreen
    visibleFrameOfScreen:(CGRect)visibleFrameOfScreen
  frontmostWindowElement:(SpectacleAccessibilityElement *)frontmostWindowElement
                  action:(SpectacleWindowAction)action
{
  CGRect previousWindowRect = [frontmostWindowElement rectOfElementWithFrameOfScreen:frameOfScreen];

  if (CGRectIsNull(previousWindowRect)) {
    return CGRectNull;
  }

  [frontmostWindowElement setRectOfElement:windowRect frameOfScreen:frameOfScreen];

  [_innerWindowMover moveWindowRect:windowRect
                      frameOfScreen:frameOfScreen
               visibleFrameOfScreen:visibleFrameOfScreen
             frontmostWindowElement:frontmostWindowElement
                             action:action];

  CGRect movedWindowRect = [frontmostWindowElement rectOfElementWithFrameOfScreen:frameOfScreen];

  if (MovingToThirdOfDisplay(action) && !CGRectContainsRect(windowRect, movedWindowRect)) {
    [frontmostWindowElement setRectOfElement:previousWindowRect frameOfScreen:frameOfScreen];

    return CGRectNull;
  }

  return movedWindowRect;
}

@end
