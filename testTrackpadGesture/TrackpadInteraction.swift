//
//  TrackpadInteraction.swift
//  testTrackpadGesture
//
//  Created by James Tang on 8/5/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

protocol TrackpadInteractionDelegate: class {
    func trackpadDidTap(_ interaction: TrackpadInteraction)
    func trackpad(_ interaction: TrackpadInteraction, didPan: UIPanGestureRecognizer)
}

class TrackpadInteraction: NSObject, UIInteraction {
    var view: UIView?
    weak var delegate: TrackpadInteractionDelegate?
    private let panGestureRecognizer: UIPanGestureRecognizer
    private let scrollView: UIScrollView

    override init() {
//        panGestureRecognizer = .init()

        scrollView = UIScrollView(frame: CGRect.zero)

        // allow bounce so it enables the scroll events regardless of it's contentSize
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = true

        // set zoom scale so scrollView initialize it's pinchGesture for those two finger trackpad events
        scrollView.minimumZoomScale = 0.99
        scrollView.maximumZoomScale = 1.0

        panGestureRecognizer = scrollView.panGestureRecognizer

        super.init()
        scrollView.delegate = self

        panGestureRecognizer.minimumNumberOfTouches = 2
        panGestureRecognizer.allowedScrollTypesMask = .continuous
        let allowedTypes: [NSNumber] = [NSNumber(value: UITouch.TouchType.indirect.rawValue), NSNumber(value: UITouch.TouchType.indirectPointer.rawValue)]
        panGestureRecognizer.allowedTouchTypes = allowedTypes
    }

    func willMove(to view: UIView?) {
        self.view = view
    }

    func didMove(to view: UIView?) {
        self.view = view
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureRecognizer(_:)))
        view?.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handlePanGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        Swift.print("TTT gesture \(String(reflecting: gesture.state))")
        delegate?.trackpad(self, didPan: gesture)
    }

}

extension TrackpadInteraction: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.trackpadDidTap(self)
    }
}
