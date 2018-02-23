//
//  Functions.swift
//  StoreSearch
//
//  Created by Christian on 2/23/18.
//  Copyright © 2018 Gridstone. All rights reserved.
//

import UIKit

func isLandscapeOrientation () -> Bool {
    let orientation = UIApplication.shared.statusBarOrientation
    if  orientation == .landscapeLeft || orientation == .landscapeRight{
        return true
    }
    return false
}
