//
//  MainTabBarViewController.swift
//  bare-games
//
//  Created by Student on 04/08/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    let tabBarControllerDelegate = TabBarControllerDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = tabBarControllerDelegate
        
    }
    
}


class TabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    let animationController = TabBarAnimationController()

    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animationController
    }
}
