//
//  TabBarAnimationController.swift
//  bare-games
//
//  Created by Student on 04/08/23.
//

import Foundation

import UIKit

class TabBarAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        toView.frame = fromView.frame
        toView.transform = CGAffineTransform(translationX: fromView.frame.width, y: 0)
        
        containerView.addSubview(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView.transform = CGAffineTransform(translationX: -fromView.frame.width, y: 0)
            toView.transform = .identity
        }) { _ in
            fromView.transform = .identity
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
