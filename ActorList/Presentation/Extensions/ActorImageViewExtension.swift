//
//  ExtensionUIImageView.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 07.06.2022.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {    
    func loadFrom(URLAddress: String, with processor: ImageProcessor) {
        kf.indicatorType = .activity
        guard let url = URL(string: URLAddress) else { return }
        kf.setImage(with: url, options: [.transition(.fade(0.2)), .processor(processor)])
    }

    func getStyledImageProcessor(size: CGRect, cornerRadius: CGFloat = 8, mode: Kingfisher.ContentMode = .aspectFill, anchor: CGPoint = CGPoint(x: 0, y: 0)) -> ImageProcessor {
        return ResizingImageProcessor(referenceSize: CGSize(width: size.width, height: size.height), mode: mode) |> CroppingImageProcessor(size: CGSize(width: size.width, height: size.height), anchor: anchor) |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
    }
}

