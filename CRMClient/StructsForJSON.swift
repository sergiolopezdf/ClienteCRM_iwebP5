//
//  StructsForJSON.swift
//  CRMClient
//
//  Created by Sergio López on 21/11/2017.
//  Copyright © 2017 UPM. All rights reserved.
//

import Foundation

struct Salesmen : Codable {
    let id: Int
    let login: String
    let fullname: String
    let isAdmin: Bool
    let isSalesman: Bool
    let phone1: String?
    let phone2: String?
    let email1: String?
    let email2: String?
    let notes: String?
    let PhotoId: Int?
    let Photo: Photo?
}

struct Photo: Codable {
    let id: Int
    let url: String
    let mime: String
}
