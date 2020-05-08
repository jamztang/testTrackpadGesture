//
//  TrackpadInteraction.swift
//  testTrackpadGesture
//
//  Created by James Tang on 8/5/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

protocol TrackpadInteractionDelegate: class {
    func trackpadDidPan(_ panGesture: UIPanGestureRecognizer)
}

class TrackpadInteraction: NSObject, UIInteraction {
    var view: UIView?
    weak var delegate: TrackpadInteractionDelegate?
    private let panGestureRecognizer: UIPanGestureRecognizer

    override init() {
        panGestureRecognizer = .init()
        super.init()
        panGestureRecognizer.allowedScrollTypesMask = .continuous
        let allowedTypes: [NSNumber] = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
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
        delegate?.trackpadDidPan(gesture)
    }

}
