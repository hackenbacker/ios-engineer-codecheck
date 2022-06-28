//
//  GitHubDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class GitHubDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView:    UIImageView!
    @IBOutlet weak var fullNameLabel:      UILabel!
    @IBOutlet weak var languageLabel:      UILabel!
    @IBOutlet weak var starsCountLabel:    UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel:    UILabel!
    @IBOutlet weak var issuesCountLabel:   UILabel!

    var searchViewController: GitHubSearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = searchViewController.repositoryList[searchViewController.selectedIndex]

        languageLabel.text      = "Written in \(repository["language"] as? String ?? "")"
        starsCountLabel.text    = "\(repository["stargazers_count"]    as? Int ?? 0) stars"
        watchersCountLabel.text = "\(repository["wachers_count"]       as? Int ?? 0) watchers"
        forksCountLabel.text    = "\(repository["forks_count"]         as? Int ?? 0) forks"
        issuesCountLabel.text   = "\(repository["open_issues_count"]   as? Int ?? 0) open issues"
        getImage()
    }

    private func getImage() {

        let repository = searchViewController.repositoryList[searchViewController.selectedIndex]

        fullNameLabel.text = repository["full_name"] as? String

        guard let owner = repository["owner"] as? [String: Any],
              let imageURL = owner["avatar_url"] as? String else {
            return
        }

        URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, res, err) in
            let avatarImage = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.avatarImageView.image = avatarImage
            }
        }
        .resume()
    }
}
