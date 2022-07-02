//
//  GitHubDetailViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/21.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

/// 詳細画面を表示する view controller.
final class GitHubDetailViewController: UIViewController, GitHubItemRecipient {

    @IBOutlet weak var avatarImageView:    UIImageView!
    @IBOutlet weak var fullNameLabel:      UILabel!
    @IBOutlet weak var languageLabel:      UILabel!
    @IBOutlet weak var starsCountLabel:    UILabel!
    @IBOutlet weak var watchersCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel:    UILabel!
    @IBOutlet weak var issuesCountLabel:   UILabel!

    private var viewModel = GitHubDetailViewModel()
    private var cancelables = Set<AnyCancellable>()

    /// GitHub item (リポジトリ一情報 ).
    var gitHubItem: GitHubItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        fullNameLabel.text = gitHubItem?.fullName

        if let language = gitHubItem?.language {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = ""
        }
        starsCountLabel.text    = "\(gitHubItem?.stargazersCount ?? 0) stars"
        watchersCountLabel.text = "\(gitHubItem?.watchersCount ?? 0) watchers"
        forksCountLabel.text    = "\(gitHubItem?.forksCount ?? 0) forks"
        issuesCountLabel.text   = "\(gitHubItem?.openIssuesCount ?? 0) open issues"

        // ViewModelのstateを監視して、変化があれば画面を更新する.
        viewModel.$state
            .sink { [weak self] state in
                self?.viewStateDidChange(state)
            }
            .store(in: &cancelables)

        Task {
            await viewModel.onAppear(gitHubItem)
        }
    }

    /// Called when state of this view has been changed.
    /// - Parameter state: State of this view.
    private func viewStateDidChange(_ state: GitHubDetailViewState) {
        showAvatarImage(state)
    }

    /// Shows an avatar image.
    /// - Parameter state: State of this view.
    private func showAvatarImage(_ state: GitHubDetailViewState) {

        let placeholderImage = UIImage(systemName: "person.crop.circle.badge.questionmark")!
                                .withTintColor(.systemGray5, renderingMode: .alwaysOriginal)

        switch state {
        case .idle:
            NSLog("\(#function): Idle")
            avatarImageView.image = placeholderImage
        case .loading:
            NSLog("\(#function): Downloading now...")
            avatarImageView.image = placeholderImage
        case .loaded(let data):
            if let data = data {
                NSLog("\(#function): Done")
                avatarImageView.image = UIImage(data: data)
            } else {
                NSLog("\(#function): No image")
                avatarImageView.image = placeholderImage
            }
        case .failed:
            NSLog("\(#function): Failed to get image")
            // エラーでもplacehplder画像の表示にとどめる.
            avatarImageView.image = placeholderImage
        }
    }
}
