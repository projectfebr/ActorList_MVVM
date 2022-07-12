//
//  ActorDTO.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 07.06.2022.
//

import Foundation

typealias ActorList = [ActorListElement]

struct ActorListElement: Codable {
    let charid: Int
    let name: String?
    let birthday: String?
    let occupation: [String]?
    let img: String?
    let status: ActorStatus?
    let nickname: String?
    let appearance: [Int]?
    let portrayed: String?
    let category: Category?
    let betterCallSaulAppearance: [Int]?

    enum CodingKeys: String, CodingKey {
        case charid = "char_id"
        case name, birthday, occupation, img, status, nickname, appearance, portrayed, category
        case betterCallSaulAppearance = "better_call_saul_appearance"
    }
}

enum Category: String, Codable {
    case betterCallSaul = "Better Call Saul"
    case breakingBad = "Breaking Bad"
    case breakingBadBetterCallSaul = "Breaking Bad, Better Call Saul"
}

