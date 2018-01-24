//
//  UIViewControllerExt.swift
//  OnTheMap
//
//  Created by Colin Walsh on 1/24/18.
//  Copyright © 2018 Colin Walsh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissSelf() {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

