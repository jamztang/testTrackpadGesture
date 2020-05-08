//
//  ViewController.swift
//  testTrackpadGesture
//
//  Created by James Tang on 8/5/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

class TrackingView: UIView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        Swift.print("TTT touchBegin")
    }
}

class ViewController: UIViewController {

    @IBOutlet var textView: UITextView!
    let trackpadInteraction: TrackpadInteraction = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        view.addInteraction(trackpadInteraction)
        trackpadInteraction.delegate = self
    }

}

extension ViewController: TrackpadInteractionDelegate {

    func trackpad(_ interaction: TrackpadInteraction, didPan: UIPanGestureRecognizer) {
        Swift.print("TTT velocity \(didPan.state) \(didPan.velocity(in: nil)) \(didPan.translation(in: nil))")
    }

    func trackpadDidCancelPan(_ interaction: TrackpadInteraction) {
        Swift.print("TTT trackpadDidCancelPan")
    }
}

