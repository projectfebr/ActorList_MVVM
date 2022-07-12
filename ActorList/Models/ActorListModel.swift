//
//  ActorListModel.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 08.06.2022.
//

import Foundation

class ActorListModel {
    var actorList = ActorList() {
        didSet {
            filteredActorList = actorList
        }
    }

    var filteredActorList = ActorList()

    var numberOfRows: Int {
        get {
            return filteredActorList.count
        }
    }

    var filterIsEmpty: Bool {
        get {
            return filteredActorList.isEmpty
        }
    }

    func fetchActorList(completion: @escaping VoidCallback) {
        NetworkManager.request(urlString: URLs.characters) { [weak self] result in
            guard let self = self else { return  }
            switch result {
            case .failure:
                if let mockData = ActorListMockData.json.data(using: .utf8) {
                    self.actorList = self.parse(data: mockData)
                }
            case .success(let data):
                self.actorList = self.parse(data: data)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }

    func filter(by query: String) {
        guard !query.isEmpty else {
            filteredActorList = actorList
            return
        }
        filteredActorList = actorList.filter { (item: ActorListElement) -> Bool in
            return item.name?.range(of: query, options: .caseInsensitive) != nil
        }
    }

    func reset() {
        filteredActorList = actorList
    }

    private func parse(data: Data) -> ActorList {
        let decoder = JSONDecoder()
        if let actors = try? decoder.decode(ActorList.self, from: data) {
            return actors
        }
        return ActorList()
    }
}
