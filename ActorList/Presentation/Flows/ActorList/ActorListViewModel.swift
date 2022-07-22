//
//  ActorListModel.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 08.06.2022.
//

import Foundation

class ActorListViewModel {
    var filteredActors: Observable<ActorList> = Observable(ActorList())

    var numberOfRows: Int {
        get {
            return filteredActors.value.count
        }
    }
    var filterIsEmpty: Bool {
        get {
            return filteredActors.value.isEmpty
        }
    }

    private var actors = ActorList() {
        didSet {
            filteredActors.value = actors
        }
    }

    func fetchActorList() {
        NetworkManager.request(urlString: URLs.characters) { [weak self] result in
            guard let self = self else { return  }
            switch result {
            case .failure:
                if let mockData = ActorListMockData.json.data(using: .utf8) {
                    self.actors = self.parse(data: mockData)
                }
            case .success(let data):
                self.actors = self.parse(data: data)
            }
        }
    }

    func filter(by query: String) {
        guard !query.isEmpty else {
            filteredActors.value = actors
            return
        }
        filteredActors.value = actors.filter { (item: ActorListElement) -> Bool in
            return item.name?.range(of: query, options: .caseInsensitive) != nil
        }
    }

    func reset() {
        filteredActors.value = actors
    }

    private func parse(data: Data) -> ActorList {
        let decoder = JSONDecoder()
        if let actors = try? decoder.decode(ActorList.self, from: data) {
            return actors
        }
        return ActorList()
    }
}
