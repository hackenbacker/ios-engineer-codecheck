//
//  GitHubDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// 詳細画面を表示する view controller.
final class GitHubDetailViewController: UIViewController {

    @IBOutlet weak var avatarImageView:    UIImageView!
    @IBOutlet weak var fullNameLabel:      UILabel!
    @IBOutlet weak var languageLabel:      UILabel!
    @IBOutlet weak var starsCountLabel:    UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel:    UILabel!
    @IBOutlet weak var issuesCountLabel:   UILabel!

    /// 検索結果を保持しているview controllerへの参照.
    var searchViewController: GitHubSearchViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = searchViewController.repositoryList[searchViewController.selectedIndex]

        languageLabel.text      = "Written in \(repository["language"] as? String ?? "")"
        starsCountLabel.text    = "\(repository["stargazers_count"]    as? Int ?? 0) stars"
        watchersCountLabel.text = "\(repository["wachers_count"]       as? Int ?? 0) watchers"
        forksCountLabel.text    = "\(repository["forks_count"]         as? Int ?? 0) forks"
        issuesCountLabel.text   = "\(repository["open_issues_count"]   as? Int ?? 0) open issues"
        getAvatarImage()
    }

    /// アバター画像を取得する.
    /// 取得したアバター画像を表示する.
    /// フルネームを表示する.
    private func getAvatarImage() {

        let repository = searchViewController.repositoryList[searchViewController.selectedIndex]

        fullNameLabel.text = repository["full_name"] as? String

        guard let owner = repository["owner"] as? [String: Any],
              let imageURL = owner["avatar_url"] as? String else {
            return
        }

        URLSession.shared.dataTask(with: URL(string: imageURL)!) { (data, response, error) in
            let avatarImage = UIImage(data: data!)!
            DispatchQueue.main.async {
                self.avatarImageView.image = avatarImage
            }
        }
        .resume()
    }
}
