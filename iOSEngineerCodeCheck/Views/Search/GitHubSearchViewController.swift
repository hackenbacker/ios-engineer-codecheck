//
//  GitHubSearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit
import Combine

/// 検索画面を表示する view controller.
final class GitHubSearchViewController: UITableViewController {

    @IBOutlet weak var querySearchBar: UISearchBar!

    private var viewModel = GitHubSearchViewModel()
    private var cancelables = Set<AnyCancellable>()

    /// リポジトリ検索結果.
    private(set) var gitHubItems: [GitHubItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    /// 選択中のリポジトリ.
    private(set) var selectedGitHubItem: GitHubItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "リポジトリ検索"
        querySearchBar.placeholder = "GitHub-検索文字列を入力"

        // ViewModelのstateを監視して、変化があれば画面を更新する.
        viewModel.$state
            .sink { [weak self] state in
                self?.viewStateDidChange(state)
            }
            .store(in: &cancelables)

        Task {
            await viewModel.onAppear()
        }
    }

    /// Called when state of this view has been changed.
    /// - Parameter state: State of this view.
    private func viewStateDidChange(_ state: GitHubSearchViewState) {
        switch state {
        case .idle:
            NSLog("\(#function): Idle")
        case.loading:
            NSLog("\(#function): Searching now...")
        case .loaded([]):
            NSLog("\(#function): No Repositories")
            gitHubItems = []
            AlertUtil.show(GitHubAppError.noRepositories, from: self)
        case .loaded(let items):
            NSLog("\(#function): Found")
            gitHubItems = items
        case .failed(let error):
            NSLog("\(#function): Failed to search repositories")
            AlertUtil.show(error, from: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let recipient = segue.destination as? GitHubItemRecipient {
            recipient.gitHubItem = selectedGitHubItem
        }
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitHubItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Repository", for: indexPath)

        let item = gitHubItems[indexPath.row]

        cell.textLabel?.text       = item.fullName
        cell.detailTextLabel?.text = item.language

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 詳細画面へ遷移する
        selectedGitHubItem = gitHubItems[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

extension GitHubSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let query = searchBar.text, !query.isEmpty else {
            return
        }

        Task {
            await viewModel.onSearchButtonTapped(query)
        }
    }
}
