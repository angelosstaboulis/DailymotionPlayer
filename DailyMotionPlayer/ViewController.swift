//
//  ViewController.swift
//  DailyMotionPlayer
//
//  Created by Angelos Staboulis on 7/7/23.
//

import UIKit
import DailymotionPlayerSDK
class ViewController: UIViewController,UITextFieldDelegate {
    private lazy var playerViewController: DMPlayerViewController = {
        let controller = DMPlayerViewController(parameters: [:])
        controller.delegate = self
        return controller
    }()
    var isPlaying = false
    var getPosition = 0.0
    @IBOutlet var playerVideoView: UIView!
    @IBOutlet var txtURL: UITextField!
    @IBOutlet var btnPlay: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initVideoPlayer()
        setupPlayButton()
        setupTextField()
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func btnPlay(_ sender: Any) {
        togglePlayButton()
        
    }
    
    func togglePlayButton(){
        if isPlaying == false {
            btnPlay.setTitle("Stop Video", for: .normal)
            isPlaying = true
            playerViewController.play()
        }else{
            isPlaying = false
            btnPlay.setTitle("Start Video", for: .normal)
            playerViewController.pause()
            playerViewController.seek(to: getPosition)
        }
    }
    
}
extension ViewController:DMPlayerViewControllerDelegate{
    func player(_ player: DMPlayerViewController, didReceiveEvent event: PlayerEvent)
    {
        switch event{
            
        case .timeEvent(let name, let position):
            getPosition = position
        default:break
            
        }
    }
    
    func player(_ player: DMPlayerViewController, openUrl url: URL) {
        
    }
    
    func playerDidInitialize(_ player: DMPlayerViewController) {
        
    }
    
    func player(_ player: DMPlayerViewController, didFailToInitializeWithError error: Error) {
        
    }
    
    
}
extension ViewController{
    
    func initVideoPlayer(){
        playerViewController.view.frame = CGRect(x: (UIScreen.main.bounds.width / 2.0)-60, y: playerViewController.view.bounds.maxY+60, width: 300, height: 650)
        playerVideoView.addSubview(playerViewController.view)
        playerVideoView.bringSubviewToFront(playerViewController.view)
    }
    func setupTextField(){
        txtURL.layer.borderWidth = 1
        txtURL.layer.borderColor = UIColor.black.cgColor
        txtURL.delegate = self
    }
    func setupPlayButton(){
        btnPlay.backgroundColor = .gray
        btnPlay.layer.cornerRadius = 12
        btnPlay.setTitle("Play Video", for: .normal)
    }
    func exportID()->String{
        let urlString = txtURL.text
        let urlArray = urlString!.components(separatedBy: "/")
        let idArray = String(describing:urlArray[urlArray.count-1])
        let id = idArray.components(separatedBy: "?")
        return id[0]
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text!.count > 0 {
            playerViewController.load(videoId:exportID(), params: nil) {
                
            }
            playerViewController.play()
            isPlaying = true
            btnPlay.setTitle("Stop Video", for: .normal)
        }
    }
    
}
