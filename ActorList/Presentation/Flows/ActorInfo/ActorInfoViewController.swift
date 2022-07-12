//
//  ActorInfoViewController.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 22.06.2022.
//

import UIKit
import Kingfisher

class ActorInfoViewController: UIViewController {
    let actorInfoModel = ActorInfoModel()
    let actorId: Int

    @IBOutlet weak var actorImageView: UIImageView!

    @IBOutlet weak var activity: UIActivityIndicatorView! {
        didSet {
            activity.startAnimating()
        }
    }

    @IBOutlet weak var mainInfoStackView: UIStackView! {
        didSet {
            mainInfoStackView.isHidden = true
        }
    }

    @IBOutlet weak var detailsInfoStackView: UIStackView! {
        didSet {
            detailsInfoStackView.isHidden = true
        }
    }

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!

    init(actorId: Int) {
        self.actorId = actorId
        super.init(nibName: nil, bundle: nil)
    }

    init?(actorId: Int, coder: NSCoder) {
        self.actorId = actorId
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        actorInfoModel.fetchActorInfo(withId: actorId, completion: updateViews)
    }

    private func updateViews() {
        guard let actorInfo = actorInfoModel.actorInfo else {
            activity.stopAnimating()
            return
        }
        navigationItem.title = actorInfoModel.actorInfo?.name

        if let imgUrl = actorInfoModel.actorInfo?.img {
            let processor = actorImageView.getStyledImageProcessor(size: actorImageView.bounds)
            actorImageView.loadFrom(URLAddress: imgUrl, with: processor)
        }

        nameLabel.text = actorInfo.portrayed
        birthdayLabel.text = actorInfo.birthday
        occupationLabel.text = actorInfo.occupation?.joined(separator: ", ")
        nicknameLabel.text = actorInfo.nickname
        categoryLabel.text = actorInfo.category?.rawValue
        statusLabel.text = actorInfo.status?.rawValue
        mainInfoStackView.isHidden = false
        detailsInfoStackView.isHidden = false

        activity.stopAnimating()
    }
}
