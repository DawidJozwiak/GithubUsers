//
//  ViewController.swift
//  Github Users
//
//  Cocoa Touch class created to present animation of fading github logo
//
//  Created by Dawid Jóźwiak on 4/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    //Setting the same imageview as on LaunchScreen
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        imageView.image = UIImage(named: "LaunchIcons")
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
    }
    
    //adding layout subview with image in center
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        //creating delay before animation
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
            self.executeOnce()
        })
    }
    //execute animation only once
    lazy var executeOnce: () -> Void = {
        self.animate()
        return {}
    }()
    
    //animate method used to create starting animation
    private func animate(){
        //start of an animation
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 1.75
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            self.imageView.frame = CGRect(x: -(diffX/2), y: diffY/2, width: size, height: size)
        })
        
        //changing channel alpha up to 0 to create "fading effect"
        UIView.animate(withDuration: 1, animations: {
            self.imageView.alpha = 0
            self.view.backgroundColor = .white
        }, completion: {done in
            if done{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
                    //change controller
                    let listViewController = ListViewController()
                    listViewController.modalTransitionStyle = .crossDissolve
                    listViewController.modalPresentationStyle = .fullScreen
                    self.present(listViewController, animated: false)
                })
            }
        })
    }
}

