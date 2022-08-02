//
//  ToastView.swift
//  Toast
//
//  Created by Bastiaan Jansen on 30/06/2021.
//

import Foundation
import UIKit

public class AppleToastView : UIView, ToastView {
    private let minHeight: CGFloat
    private let minWidth: CGFloat
    
    /// Set this if want to use specific color, or else it will according to background color's dark theme
    ///
    /// Please call it before calling `show()`
    var darkBackgroundColor: UIColor?
    private var isDarkOverride = false
    public override var backgroundColor: UIColor?{
        didSet{
            isDarkOverride = true
        }
    }
    
    private let child: UIView
    
    private var toast: Toast?
    
    public init(
        child: UIView,
        minHeight: CGFloat = 58,
        minWidth: CGFloat = 150
    ) {
        self.minHeight = minHeight
        self.minWidth = minWidth
        self.child = child
        super.init(frame: .zero)
        
        // set default
        backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)
        isDarkOverride = false
        self.layer.cornerRadius = frame.height / 2
        
        addSubview(child)
    }
    
    public func createView(for toast: Toast, topSpacing: CGFloat) {
        self.toast = toast
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight),
            widthAnchor.constraint(greaterThanOrEqualToConstant: minWidth),
            leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 10),
            trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -10),
            topAnchor.constraint(equalTo: superview.layoutMarginsGuide.topAnchor, constant: topSpacing),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])
        
        addSubviewConstraints()
        DispatchQueue.main.async {
            self.style()
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        UIView.animate(withDuration: 0.5) {
            self.style()
        }
    }
    
    private func style() {
        layoutIfNeeded()
        clipsToBounds = true
        if #available(iOS 12.0, *) {
            if let darkBackgroundColor = darkBackgroundColor {
                if traitCollection.userInterfaceStyle == .dark{
                    backgroundColor = darkBackgroundColor
                }
            }else{
                if traitCollection.userInterfaceStyle == .dark && !isDarkOverride{
                    backgroundColor = .toastDefaultDark
                }
            }
        }
        
        addShadow()
    }
    
    private func addSubviewConstraints() {
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            child.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            child.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            child.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25)
        ])
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension UIColor {
    class var toastDefaultDark: UIColor {
        UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.00)
    }
}
