//
//  GitHubDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// 詳細画面を表示する view controller.
final class GitHubDetailViewController: UIViewController, RepositoryListRecipient {

    @IBOutlet weak var avatarImageView:    UIImageView!
    @IBOutlet weak var fullNameLabel:      UILabel!
    @IBOutlet weak var languageLabel:      UILabel!
    @IBOutlet weak var starsCountLabel:    UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel:    UILabel!
    @IBOutlet weak var issuesCountLabel:   UILabel!

    /// リポジトリ一覧を保持しているobject.
    weak var repositoryListProvider: RepositoryListProvider?

    override func viewDidLoad() {
        super.viewDidLoad()

        let repository = repositoryListProvider?.selectedRepository

        if let language = repository?["language"] as? String {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = ""
        }
        starsCountLabel.text    = "\(repository?["stargazers_count"]  as? Int ?? 0) stars"
        watchersCountLabel.text = "\(repository?["watchers_count"]    as? Int ?? 0) watchers"
        forksCountLabel.text    = "\(repository?["forks_count"]       as? Int ?? 0) forks"
        issuesCountLabel.text   = "\(repository?["open_issues_count"] as? Int ?? 0) open issues"
        getAvatarImage()
    }

    /// アバター画像を取得する.
    /// 取得したアバター画像を表示する.
    /// フルネームを表示する.
    private func getAvatarImage() {

        let repository = repositoryListProvider?.selectedRepository

        fullNameLabel.text = repository?["full_name"] as? String ?? ""

        let placeholderImage = UIImage(systemName: "person.crop.circle.badge.questionmark")!
                                .withTintColor(.systemGray5, renderingMode: .alwaysOriginal)

        guard let owner = repository?["owner"] as? [String: Any],
              let avatarUrl = owner["avatar_url"] as? String,
              let imageUrl = URL(string: avatarUrl) else {
            avatarImageView.image = placeholderImage
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in

            let avatarImage: UIImage

            if let data = data, let image = UIImage(data: data) {
                avatarImage = image
            } else {
                avatarImage = placeholderImage
            }

            // NOTE: 前の画面に戻る操作をしたら、直ちにこのview controlerを解放したいので[weak self]を使用する.
            DispatchQueue.main.async { [weak self] in
                self?.avatarImageView.image = avatarImage
            }
        }
        .resume()
    }
}
