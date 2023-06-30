//
//  SPAlertView.swift
//  pulse-mvvm
//
//  Created by Bahdan Piatrouski on 13.06.23.
//

import Foundation
import SPAlert

extension SPAlertView {
    static var loadingAlert: SPAlertView = {
        let alert = SPAlertView(title: "", preset: .spinner)
        alert.dismissByTap = false
        return alert
    }()
}
