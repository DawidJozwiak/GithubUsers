//
//  ListViewController.swift
//  Github Users
//
//  Controller that handles GithubURLManager delegates and tableviews
//
//  Created by Dawid Jóźwiak on 4/10/21.
//


import UIKit

class ListViewController: UIViewController{
    
    //Class variables to store values passed by delegate
    var nickname = [String]()
    var image = [String]()
    var repoNum = Int()
    
    //Number of github user's ID that is beginning of the range - default set to 0
    var urlNum = 0
    
    //buttons used to navigate through users
    let resultButton = UIButton()
    let refreshButton = UIButton()
    let backButton = UIButton()
    
    //alert variable set to animate "please wait"
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    //Object of class GithubURLManager created to manage delegates
    var githubUser = GithubURLManager()
    
    //Tableview that presents users
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting delegate and performing request
        githubUser.delegate = self
        self.githubUser.performRequest(apiNumber: self.urlNum)
        
        //setting delegate to obtain tableview methods
        tableView.dataSource = self
        tableView.delegate = self
        //add tableview and 2 buttons
        self.view.addSubview(self.tableView)
        addResultButtonView()
        addRefreshButtonView()
    }
    
    //method that presents loading alert
    private func loading(_ time: Double){
        DispatchQueue.main.async {
            let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
            loadingIndicator.hidesWhenStopped = true
            loadingIndicator.style = UIActivityIndicatorView.Style.medium
            loadingIndicator.startAnimating();
            self.alert.view.addSubview(loadingIndicator)
            self.present(self.alert, animated: true, completion: nil)
            self.tableView.reloadData()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+time, execute:{
            self.tableView.reloadData()
            self.alert.dismiss(animated: true, completion: {  })
        })
    }
    
    //execute once used in cell to prevent loading from being called 30 times(once for each cell)
    lazy var executeOnce: () -> Void = {
        loading(2.0)
        return {}
    }()
    
}

//MARK: - UITableView related methods

extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    //subview with tableview
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.allowsSelection = true
        tableView.allowsSelection = true
    }
    
    //refresh table method
    private func refreshTableView(){
        tableView.reloadData()
    }
    
    //method that triggers when user press on the row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.githubUser.parseJSONRepo(nickName: self.nickname[indexPath.row])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let alert = UIAlertController(title: "User:" + self.nickname[indexPath.row], message: "Number of Repositories: " + String(self.repoNum), preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        }
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //dissmiss alert method
    internal func dismissAlert() {         if let vc = self.presentedViewController, vc is UIAlertController {             dismiss(animated: false, completion: nil)         }     }
    
    //tableview method that returns number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nickname.count
    }
    
    //setting cells titles and images
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      

        cell.imageView?.downloaded(from: self.image[indexPath.row])
        cell.textLabel?.text = self.nickname[indexPath.row]
        cell.detailTextLabel?.text = ">"
        
        //load it once instead of 30 times
        executeOnce()
        
        return cell
        
    }

    
}

//MARK: - Button Management related methods
extension ListViewController{
    //Add Next Button
    private func addResultButtonView() {
        resultButton.backgroundColor = .black
        resultButton.setTitle("Next", for: .normal)
        resultButton.setTitleColor(.white, for: .normal)
        resultButton.addTarget(self, action: #selector(didButtonClick), for: .touchUpInside)
        tableView.addSubview(resultButton)
        
        // set position
        resultButton.translatesAutoresizingMaskIntoConstraints = false
        resultButton.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.centerXAnchor).isActive = true
        resultButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor).isActive = true
        resultButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor).isActive = true
       // resultButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        resultButton.heightAnchor.constraint(equalToConstant: 50).isActive = true // specify the height of the view
    }
    
    //Add Back Button
    private func addBackButtonView() {
        backButton.backgroundColor = .black
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(.white, for: .normal)
        backButton.addTarget(self, action: #selector(didButton1Click), for: .touchUpInside)
        tableView.addSubview(backButton)
        
        // set position
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        backButton.rightAnchor.constraint(equalTo: resultButton.centerXAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.bottomAnchor).isActive = true
       // backButton.widthAnchor.constraint(equalTo: resultButton.widthAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //Add refresh button
    private func addRefreshButtonView(){
        
        
        refreshButton.backgroundColor = .black
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(.white, for: .normal)
        refreshButton.addTarget(self, action: #selector(didButton2Click), for: .touchUpInside)
        tableView.addSubview(refreshButton)
        
        // set position
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        
        refreshButton.rightAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.rightAnchor).isActive = true
        refreshButton.leftAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.leftAnchor).isActive = true
        refreshButton.bottomAnchor.constraint(equalTo: resultButton.topAnchor, constant: -7.5).isActive = true
        refreshButton.widthAnchor.constraint(equalTo: tableView.widthAnchor).isActive = true
        refreshButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //Method that hides back button when site number is equal to 0
    private func hideBackButton(){
        backButton.isHidden = true
    }
    
    //method that refreshes the view
    @objc func didButton2Click(_ sender: UIButton){
        viewDidLoad()
        loading(1.0)
    }
    
    //method that loads next page with next 30 results
    @objc func didButtonClick(_ sender: UIButton) {
        urlNum += 30
        addBackButtonView()
        backButton.isHidden = false
        viewDidLoad()
        loading(1.0)
    }
    
    //method that goes back by 30 results
    @objc func didButton1Click(_ sender: UIButton) {
        if(urlNum > 30){
            urlNum -= 30
            viewDidLoad()
            loading(1.0)
        }
        else{
            urlNum -= 30
            hideBackButton()
            viewDidLoad()
            loading(1.0)
        }
    }
}




//MARK: - GithubURLManagerDelegate related methods
extension ListViewController: GithubURLManagerDelegate{
    //Delegate method called when repo is updated
    func didUpdateRepo(manager: GithubURLManager, repNum: Int) {
        self.repoNum = repNum
    }

    //delegate method called when name and image is updated
    func didUpdateGithub(manager: GithubURLManager, githubUserData: GithubUserModel) {
        DispatchQueue.main.async{
            self.nickname = githubUserData.name
            self.image = githubUserData.imageURL
          //  self.repoNum = githubUserData.numberOfRepos
            self.tableView.reloadData()
           // print("Number: \(self.repoNum)")
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: -UIImageView - methods related to obtain image from URL

extension UIImageView {
    //method to download image from url
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

