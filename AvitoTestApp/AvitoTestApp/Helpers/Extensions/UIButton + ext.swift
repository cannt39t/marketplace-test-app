//
//  UIButton + ext.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 26.08.2023.
//

import UIKit

extension UIButton {
	
	func startAnimatingPressActions() {
		addTarget(self, action: #selector(animateDown), for: [.touchDown, .touchDragEnter])
		addTarget(self, action: #selector(animateUp), for: [.touchDragExit, .touchCancel, .touchUpInside, .touchUpOutside])
	}
	
	@objc private func animateDown(sender: UIButton) {
		animate(sender, transform: CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5))
		generateHapticFeedback(pattern: .success)
	}
	
	@objc private func animateUp(sender: UIButton) {
		animate(sender, transform: .identity)
	}
	
	private func animate(_ button: UIButton, transform: CGAffineTransform) {
		UIView.animate(withDuration: 0.3,
					   delay: 0,
					   usingSpringWithDamping: 0.5,
					   initialSpringVelocity: 3,
					   options: [.curveEaseInOut],
					   animations: {
			button.transform = transform
		}, completion: nil)
	}
	
	private func generateHapticFeedback(pattern: UINotificationFeedbackGenerator.FeedbackType) {
		if #available(iOS 10.0, *) {
			let feedbackGenerator = UINotificationFeedbackGenerator()
			feedbackGenerator.prepare()
			feedbackGenerator.notificationOccurred(pattern)
		}
	}
}
