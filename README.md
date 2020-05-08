Trying to detect touch on trackpad on iOS

https://goodnotes.atlassian.net/browse/V5IOSCS-853

Current implementation attempted to use UIScrollView.panGestureRecognizer
which seemed to be setup differently than stock UIPanGestureRecognizer.

While scrolling and touch on the trackpad, gesture.state should turn to `cancelled`.

Both two finger and one finger touch works correctly on Mac, but on iPadOS, only two finger touch works.

