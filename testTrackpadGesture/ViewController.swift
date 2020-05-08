//
//  ViewController.swift
//  testTrackpadGesture
//
//  Created by James Tang on 8/5/2020.
//  Copyright © 2020 James Tang. All rights reserved.
//

import UIKit

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
    func trackpadDidPan(_ panGesture: UIPanGestureRecognizer) {
        Swift.print("TTT velocity \(panGesture.velocity(in: nil)) \(panGesture.translation(in: nil))")

    }
}

