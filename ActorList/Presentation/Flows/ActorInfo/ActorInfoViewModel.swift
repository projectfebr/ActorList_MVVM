//
//  ActorInfoModel.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 22.06.2022.
//

import Foundation

class ActorInfoViewModel {
    var actorInfo: Observable<ActorInfo?> = Observable(nil)

    func fetchActorInfo(withId id: Int, completion: @escaping VoidCallback) {
        NetworkManager.request(urlString: URLs.characters + "\(id)") { [weak self] result in
            guard let self = self else { return  }
            switch result {
            case .failure:
                break
            case .success(let data):
                self.actorInfo.value = self.parse(data: data)
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    private func parse(data: Data) -> ActorInfo? {
        let decoder = JSONDecoder()
        if let actorInfoList = try? decoder.decode(ActorInfoList.self, from: data) {
            return actorInfoList.first
        }
        return nil
    }
}
