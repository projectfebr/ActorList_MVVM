//
//  ActorInfoDTO.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 22.06.2022.
//

import Foundation

typealias ActorInfoList = [ActorInfo]

struct ActorInfo: Codable {
    let charID: Int
    let name, birthday: String?
    let occupation: [String]?
    let img: String?
    let status: ActorStatus?
    let nickname: String?
    let appearance: [Int]?
    let portrayed: String
    let category: Category?
    let betterCallSaulAppearance: [Int]?

    enum CodingKeys: String, CodingKey {
        case charID = "char_id"
        case name, birthday, occupation, img, status, nickname, appearance, portrayed, category
        case betterCallSaulAppearance = "better_call_saul_appearance"
    }
}

enum ActorStatus: String, Codable {
    case alive = "Alive"
    case deceased = "Deceased"
    case presumedDead = "Presumed dead"
    case unknown = "Unknown"
}
