//
//  BackNavigationControllerAnimation.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 09.07.2022.
//

import Foundation
import QuartzCore

class BackNavigationTransition: CATransition {
    override init() {
        super.init()
        duration = 0.5
        type = .push
        subtype = .fromLeft
        timingFunction = CAMediaTimingFunction(name: .default)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
