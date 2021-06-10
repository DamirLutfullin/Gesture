//
//  ViewController.swift
//  Gesture
//
//  Created by Damir L on 10.06.2021.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet var bananaPan: UIPanGestureRecognizer!
    @IBOutlet var monkeyPan: UIPanGestureRecognizer!
    
    private var chompPlayer: AVAudioPlayer?
    private var laughPlayer: AVAudioPlayer?
    
    func createPlayer(from filename: String) -> AVAudioPlayer? {
      guard let url = Bundle.main.url(
        forResource: filename,
        withExtension: "caf"
        ) else {
          return nil
      }
      var player = AVAudioPlayer()

      do {
        try player = AVAudioPlayer(contentsOf: url)
        player.prepareToPlay()
      } catch {
        print("Error loading \(url.absoluteString): \(error)")
      }

      return player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageViews = view.subviews.filter {
            $0 is UIImageView
        }
        for imageView in imageViews {
            let tapGesture = UITapGestureRecognizer(
                target: self,
                action: #selector(handleTap)
            )
            
            tapGesture.delegate = self
            imageView.addGestureRecognizer(tapGesture)
            
            tapGesture.require(toFail: monkeyPan)
            tapGesture.require(toFail: bananaPan)
            
            let tickleGesture = ​TickleGestureRecognizer(target: self, action: #selector(handleTickle))
            tickleGesture.delegate = self
            imageView.addGestureRecognizer(tickleGesture)
          
        }
        
        chompPlayer = createPlayer(from: "chomp")
        laughPlayer = createPlayer(from: "laugh")
    }
    
    @IBAction func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        
        gesture.setTranslation(.zero, in: view)
    }
    
    
    @IBAction func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.transform = gestureView.transform.scaledBy(
            x: gesture.scale,
            y: gesture.scale
        )
        gesture.scale = 1

    }
    
    @IBAction func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }
        gestureView.transform = gestureView.transform.rotated(
          by: gesture.rotation
        )
        gesture.rotation = 0
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        chompPlayer?.play()
    }
    
    @objc func handleTickle(_ gesture: UITapGestureRecognizer) {
        laughPlayer?.play()
    }
    
}

extension ViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
