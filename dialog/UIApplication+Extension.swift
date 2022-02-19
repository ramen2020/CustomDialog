//
//  UIApplication+Extension.swift
//  dialog
//
//  Created by 宮本光直 on 2022/02/18.
//

import Foundation
import SwiftUI

extension UIApplication {
    public func getTopViewController() -> UIViewController? {
        guard let window = UIApplication.shared
                .connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first else {
            return nil
        }

        window.makeKeyAndVisible()

        guard let rootViewController = window.rootViewController else {
            return nil
        }

        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }

        return topController
  }

    public func dismissModalView() {
        UIApplication.shared.getTopViewController()?.dismiss(animated: true, completion: nil)
    }
}
