//
//  GithubModel.swift
//  Github Users
//
// Struct from github user api /(nickname)
//
//  Created by Dawid Jóźwiak on 4/10/21.
//

import Foundation
import UIKit

//struct from github user api /(nickname)
struct GithubUserData: Codable{
    var public_repos: Int
}
