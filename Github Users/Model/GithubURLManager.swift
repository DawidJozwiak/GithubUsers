//
//  GithubURLManager.swift
//  Github Users
//
//  Created by Dawid Jóźwiak on 4/10/21.
//

import Foundation
import UIKit

protocol GithubURLManagerDelegate{
    func didUpdateGithub(manager: GithubURLManager , githubUserData: GithubUserModel)
    func didUpdateRepo(manager:GithubURLManager, repNum: Int)
}

struct GithubURLManager{
    //URL with apikey already inserted in
    //APPLE REQUIRES HTTPS!!!
    
    
    
    var delegate: GithubURLManagerDelegate?
    
    func performRequest(apiNumber: Int){
        //Create URL
        if let url = URL(string: "https://api.github.com/users?since=\(apiNumber)&per_page=30"){
            //Creating session
            let session = URLSession(configuration: .default)
            //Giving session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    //Convert data to string
                    //self is needed in here
                    parseJSON(usersData: safeData)
                }
            }
            //Fourth Start the task
            task.resume()
        }
    }
    
    
    func performRequestRepo(nickname: String) -> Data{
        var dataUser = Data()
        //Create URL
        if let url = URL(string: "https://api.github.com/users/\(nickname)"){
            //Creating session
            let session = URLSession(configuration: .default)
            //Giving session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    dataUser = safeData
                    
                }
                
            }
            //Fourth Start the task
            task.resume()
        }
         return dataUser
    }
    
    
    
    
    //Parse JSON to decoded data
    func parseJSON(usersData: Data){
        let decoder = JSONDecoder()
        do{
            //decode data
            var nickArray: [String]
            nickArray = []
            var imgArray: [String]
            imgArray = []
            let decodedData = try decoder.decode([GithubData].self, from: usersData)
            //decodedData.forEach{
            for (index, element) in decodedData.enumerated() {
                nickArray.append(element.login)
                imgArray.append(element.avatar_url)
                
            }
            
            let github = GithubUserModel(name: nickArray, imageURL: imgArray)
           self.delegate?.didUpdateGithub(manager: self, githubUserData: github)
        }
        catch{
            print(error)
        }
    }
    
    func parseJSONRepo(nickName: String) {
 
            if let url = URL(string: "https://api.github.com/users/\(nickName)"){
                //Creating session
                let session = URLSession(configuration: .default)
                //Giving session a task
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let safeData = data{

                        let num = prepareObject(repoData: safeData)
                        self.delegate?.didUpdateRepo(manager: self, repNum: num)
                    }
                    
                }
                //Fourth Start the task
                task.resume()
            }

        }
    
     
    
    func prepareObject(repoData: Data) -> Int{
       
        var x: Int = 0
        let decoder = JSONDecoder()
        do{
        let decodedData1 = try decoder.decode(GithubUserData.self, from: repoData)
        x = decodedData1.public_repos
     /*
        repoArray.append(decodedData1.public_repos)
        
        
        let userArray = GithubUserModel(name: nickArray, imageURL: imgArray, numberOfRepos: repoArray)
    
        
        //  let log = decodedData.loginValue of type 'GithubData' has no subscript
        //let githubUser = GithubModel(userNickname: [decodedData.login], userImage: [decodedData.avatar_url])
        
        self.delegate?.didUpdateGithub(manager: self, githubUserData: userArray)
*/
        }
        
        catch{
            print(error)
        
    }
        return x
    }
    
}


