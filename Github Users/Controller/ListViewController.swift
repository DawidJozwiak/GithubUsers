//
//  ListViewController.swift
//  Github Users
//
//  Created by Dawid Jóźwiak on 4/10/21.
//


import UIKit

class ListViewController: UIViewController{
    
    var nickname = [String]()
    var image = [String]()
    var repoNum = Int()
        
    var urlNum = 0
    let resultButton = UIButton()
    let refreshButton = UIButton()
    let backButton = UIButton()
    let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    var githubUser = GithubURLManager()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    
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
    
    private func refreshTableView(){
        tableView.reloadData()
    }
    
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
    
    private func hideBackButton(){
        backButton.isHidden = true
    }
    
    @objc func didButton2Click(_ sender: UIButton){
        viewDidLoad()
        loading(1.0)
    }
    
    @objc func didButtonClick(_ sender: UIButton) {
        urlNum += 30
        addBackButtonView()
        backButton.isHidden = false
        viewDidLoad()
        loading(1.0)
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        githubUser.delegate = self
            self.githubUser.performRequest(apiNumber: self.urlNum)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        addResultButtonView()
        addRefreshButtonView()
    }
    
    lazy var executeOnce: () -> Void = {
        loading(2.0)
        return {}
    }()
}

//MARK: - UITableView
extension ListViewController: UITableViewDataSource, UITableViewDelegate{
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        tableView.allowsSelection = true
        tableView.allowsSelection = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.githubUser.parseJSONRepo(nickName: self.nickname[indexPath.row])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            let alert = UIAlertController(title: "User:" + self.nickname[indexPath.row], message: "Number of Repositories: " + String(self.repoNum), preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
        }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func dismissAlert() {         if let vc = self.presentedViewController, vc is UIAlertController {             dismiss(animated: false, completion: nil)         }     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nickname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = self.nickname[indexPath.row]
        //cell.detailTextLabel?.text = String(self.repoNum[indexPath.row])
        cell.imageView?.downloaded(from: self.image[indexPath.row])
  
        executeOnce()
        
        return cell
        
    }

    
}

//MARK: - GithubURLManagerDelegate
extension ListViewController: GithubURLManagerDelegate{
    func didUpdateRepo(manager: GithubURLManager, repNum: Int) {
        self.repoNum = repNum
    }
    
    
    func didUpdateGithub(manager: GithubURLManager, githubUserData: GithubUserModel) {
        DispatchQueue.main.async{
            self.nickname = githubUserData.name
            self.image = githubUserData.imageURL
          //  self.repoNum = githubUserData.numberOfRepos
            self.tableView.reloadData()
           // print("Number: \(self.repoNum)")
        }
    }
    
}

//MARK: -UIImageView

extension UIImageView {
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

