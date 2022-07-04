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

    /// GitHub item (リポジトリ一情報).
    var gitHubItem: GitHubItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "詳細"

        fullNameLabel.text = gitHubItem?.fullName

        if let language = gitHubItem?.language {
            languageLabel.text = "Written in \(language)"
        } else {
            languageLabel.text = ""
        }
        starsCountLabel.text  = "\(gitHubItem?.stargazersCount ?? 0) stars"
        forksCountLabel.text  = "\(gitHubItem?.forksCount ?? 0) forks"
        issuesCountLabel.text = "\(gitHubItem?.openIssuesCount ?? 0) open issues"

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
        refreshView(state)
    }

    /// Refreshes this view.
    /// - Parameter state: State of this view.
    private func refreshView(_ state: GitHubDetailViewState) {
        switch state {
        case .loaded(let (data, count)):
            avatarImageView.image   = UIImage(data: data)
            watchersCountLabel.text = "\(count) watchers"
        case .idle, .loading, .failed:
            let placeholderImage = UIImage(systemName: "person.crop.circle.badge.questionmark")!
                                    .withTintColor(.systemGray5, renderingMode: .alwaysOriginal)
            let placeholderText  = "- watchers"

            avatarImageView.image   = placeholderImage
            watchersCountLabel.text = placeholderText
        }
    }
}
