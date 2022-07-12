//
//  KingfisherExtension.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 23.06.2022.
//

import Foundation
import Kingfisher

extension ImageProcessor {
    static func getStyledImageProcessor(size: CGSize, cornerRadius: CGFloat = 8, mode: ContentMode = .aspectFill) -> ImageProcessor {
        return ResizingImageProcessor(referenceSize: CGSize(width: size.width, height: size.height), mode: mode) |> CroppingImageProcessor(size: CGSize(width: size.width, height: size.height)) |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
    }
}
