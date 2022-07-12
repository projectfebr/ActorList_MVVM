//
//  ActorTableViewCell.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 29.05.2022.
//

import UIKit
import Kingfisher

class ActorTableViewCell: UITableViewCell {
    @IBOutlet weak var actorImageView: UIImageView! {
        didSet {
            actorImageView.image = nil
        }
    }

    @IBOutlet weak var actorNameLabel: UILabel! {
        didSet {
            actorNameLabel.text = nil
        }
    }

    func configure(for actor: ActorListElement ) {
        if let urlImage = actor.img {
            let processor = actorImageView.getStyledImageProcessor(size: actorImageView.bounds, anchor: CGPoint(x: 0, y: -10))
            actorImageView.loadFrom(URLAddress: urlImage, with: processor)
        }
        actorNameLabel.text = actor.name
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        actorImageView.image = nil
        actorNameLabel.text = nil
    }
}
