//
//  UIViewController.swift
//  pulse-mvvm
//
//  Created by Bahdan Piatrouski on 14.06.23.
//

import UIKit

extension UIViewController {
    func configureNavigationController(title: String? = nil) -> UINavigationController {
        if let title {
            self.navigationItem.title = title
        }
        
        let navigationController = UINavigationController(rootViewController: self)
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
