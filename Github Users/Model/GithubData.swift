//
//  GithubData.swift
//  Github Users
//
//  Struct to parse json user
//
//  Created by Dawid Jóźwiak on 4/10/21.
//

import Foundation

//struct to parse json user
struct GithubData: Codable{
    let login: String
    let avatar_url: String
    //let url: String
}
