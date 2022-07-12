//
//  TableViewCellExtensions.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 03.06.2022.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var identifier : String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}
