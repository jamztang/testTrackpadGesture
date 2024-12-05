//
//  TrackpadInteraction.swift
//  testTrackpadGesture
//
//  Created by James Tang on 8/5/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

protocol TrackpadInteractionDelegate: AnyObject {
    func trackpadDidCancelScrolling(_ interaction: TrackpadInteraction)
    func trackpadDidStartScrolling(_ interaction: TrackpadInteraction)
    func trackpad(_ interaction: TrackpadInteraction, didPan: UIPanGestureRecognizer)
}

class TrackpadInteraction: NSObject, UIInteraction {
    var view: UIView?
    weak var delegate: TrackpadInteractionDelegate?
    private let panGestureRecognizer: UIPanGestureRecognizer
    private let hoverGestureRecognizer: UIHoverGestureRecognizer
    private(set) var state: State = .stoppedScrolling {
        didSet {
            if oldValue != state {
                if case .pendingStopScrolling(let timer) = oldValue {
                    timer.invalidate()
                }
                print("TTT \(state)")
            }
        }
    }

    enum State: Equatable {
        case startedScrolling
        case pendingStopScrolling(Timer)
        case stoppedScrolling
        case cancelledScrolling

        var description: String {
            switch self {
            case .startedScrolling: "startedScrolling"
            case .pendingStopScrolling: "pendingStopScrolling"
            case .stoppedScrolling: "stoppedScrolling"
            case .cancelledScrolling: "cancelledScrolling"
            }
        }

        mutating func handle(_ gesture: UIHoverGestureRecognizer) {
            switch self {
            case .pendingStopScrolling(let timer):
                timer.invalidate()
                self = .startedScrolling
            default:
                break
            }
        }

        mutating func handle(_ gesture: UIPanGestureRecognizer) {
            switch gesture.state {
            case .ended:
                self = .startedScrolling
                break
            case .possible, .changed, .began:
                break
            case .cancelled, .failed:
                self = .cancelledScrolling
            @unknown default:
                break
            }
        }
        func handle(_ event: UIEvent) -> DeferredAction {
            switch (event.type, event.subtype) {
            case (.scroll, .none):
                if case .startedScrolling = self {
                    return .stop(after: 0.2)
                }
            default:
                break
            }
            return .none
        }

        func shouldBegin(_ gestureType: GestureType) -> Bool {
            if gestureType == .hover {
                if case .startedScrolling = self {
                    return true
                } else {
                    return false
                }
            }
            return true
        }

        enum DeferredAction {
            case none
            case stop(after: TimeInterval)
        }
    }

    override init() {

        panGestureRecognizer = UIPanGestureRecognizer()
        hoverGestureRecognizer = UIHoverGestureRecognizer()
        super.init()

        panGestureRecognizer.delegate = self
        panGestureRecognizer.allowedScrollTypesMask = .all
        let allowedTypes: [NSNumber] = [NSNumber(value: UITouch.TouchType.indirect.rawValue), NSNumber(value: UITouch.TouchType.indirectPointer.rawValue)]
        panGestureRecognizer.allowedTouchTypes = allowedTypes

        hoverGestureRecognizer.allowedTouchTypes = allowedTypes
        hoverGestureRecognizer.delegate = self
    }

    func willMove(to view: UIView?) {
        self.view = view
    }

    func didMove(to view: UIView?) {
        self.view = view
        panGestureRecognizer.addTarget(self, action: #selector(handlePanGestureRecognizer))
        view?.addGestureRecognizer(panGestureRecognizer)
        hoverGestureRecognizer.addTarget(self, action: #selector(handleHoverGestureRecognizer))
        view?.addGestureRecognizer(hoverGestureRecognizer)
    }

    @objc func handlePanGestureRecognizer(_ gesture: UIPanGestureRecognizer) {
        state.handle(gesture)
    }

    @objc func handleHoverGestureRecognizer(_ gesture: UIHoverGestureRecognizer) {
        state.handle(gesture)
    }

}

extension UIGestureRecognizer.State: CustomStringConvertible {
    public var description: String {
        switch self {
        case .began: return "began"
        case .cancelled: return "cancelled"
        case .possible: return "possible"
        case .ended: return "ended"
        case .recognized: return "recognized"
        case .failed: return "failed"
        case .changed: return "changed"
        @unknown default:
            return "unknown"
        }
    }
}

extension TrackpadInteraction: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive event: UIEvent) -> Bool {
        switch state.handle(event) {
        case .none:
            break
        case let .stop(after: timeInterval):
            guard case .startedScrolling = state else {
                return true
            }
            let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] timer in
                guard timer.isValid else { return }
                self?.state = .stoppedScrolling
                timer.invalidate()
            }
            state = .pendingStopScrolling(timer)
        }
        return true
    }
}

enum GestureType {
    case unknown
    case pan
    case hover
}

extension UIGestureRecognizer {
    var gestureType: GestureType {
        switch self {
        case is UIHoverGestureRecognizer: .hover
        case is UIPanGestureRecognizer: .pan
        default: .unknown
        }
    }
}

extension CGPoint {
    func divided(by scale: CGFloat) -> CGPoint {
        CGPoint(x: x / scale, y: y / scale)
    }
}
