//
//  LoadingBar.swift
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

import UIKit

@IBDesignable
class LoadingBar: UIView {

    // MARK: Constants

    struct Constants {
        static let maxFakePercentageLoadingValue = 95.0
        static let maxRandomPercentageRange = 15
    }

    // MARK: - Properties

    fileprivate let barLayer = CALayer()
    fileprivate var percent = 0.0
    fileprivate var isLoading = false

    @IBInspectable public var barColor: UIColor = UIColor.gray {
        didSet {
            barLayer.backgroundColor = barColor.cgColor
        }
    }

    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()

        barLayer.frame = bounds
        barLayer.backgroundColor = barColor.cgColor
        barLayer.opacity = 0
        layer.addSublayer(barLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        barLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        barLayer.bounds = bounds
    }

    // MARK: - Methods

    func startLoading() {
        isLoading = true
        percent = 0
        barLayer.opacity = 1.0
        barLayer.transform = CATransform3DMakeScale(0, 1, 1)

        animate()
    }

    func stopLoading() {
        isLoading = false

        guard let presentationLayer = barLayer.presentation() else { return }

        let oldTransform = presentationLayer.transform
        barLayer.removeAllAnimations()
        barLayer.transform = oldTransform

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.barLayer.opacity = 0
            self.barLayer.transform = CATransform3DMakeScale(0, 1, 1)
            self.barLayer.removeAllAnimations()
        }

        let finishLoadingAnimation = CABasicAnimation(keyPath: "transform")
        finishLoadingAnimation.fromValue = oldTransform
        finishLoadingAnimation.toValue = CATransform3DMakeScale(1, 1, 1)
        finishLoadingAnimation.duration = 0.5
        finishLoadingAnimation.fillMode = kCAFillModeForwards
        finishLoadingAnimation.isRemovedOnCompletion = false

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.beginTime = finishLoadingAnimation.duration
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        opacityAnimation.duration = 0.5
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = false

        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [finishLoadingAnimation, opacityAnimation]
        animationGroup.duration = finishLoadingAnimation.duration + opacityAnimation.duration
        animationGroup.fillMode = kCAFillModeForwards
        animationGroup.isRemovedOnCompletion = false

        barLayer.add(animationGroup, forKey: "barLoadingFinish")

        CATransaction.commit()
    }

    // MARK: - Helpers

    fileprivate func animate() {
        percent += Double(arc4random_uniform(UInt32(Constants.maxRandomPercentageRange))+1)
        if (percent >= Constants.maxFakePercentageLoadingValue) {
            return
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock {
            guard self.isLoading else { return }

            self.barLayer.removeAllAnimations()

            self.barLayer.transform = CATransform3DMakeScale(CGFloat(self.percent/100.0), 1, 1)
            self.animate()
        }

        let scaleAnimation = CABasicAnimation(keyPath: "transform")
        scaleAnimation.fromValue = barLayer.transform
        scaleAnimation.toValue =  CATransform3DMakeScale(CGFloat(percent/100.0), 1, 1)
        scaleAnimation.duration = 0.5
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.isRemovedOnCompletion = false
        barLayer.add(scaleAnimation, forKey: "barLoading")

        CATransaction.commit()
    }

    // MARK: Interface Builder

    override func prepareForInterfaceBuilder() {
        layer.sublayers?.removeAll()

        barLayer.frame = bounds
        barLayer.opacity = 1
        barLayer.backgroundColor = barColor.cgColor

        layer.addSublayer(barLayer)

        barLayer.transform = CATransform3DMakeScale(0.7, 1, 1)
    }

}
