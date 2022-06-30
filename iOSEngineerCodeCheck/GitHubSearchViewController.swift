//
//  GitHubSearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// 検索画面を表示する view controller.
final class GitHubSearchViewController: UITableViewController, UISearchBarDelegate, RepositoryListProvider {

    @IBOutlet weak var querySearchBar: UISearchBar!

    /// リポジトリ検索結果.
    private(set) var repositoryList: [[String: Any]] = []
    /// 選択中のリポジトリ.
    private(set) var selectedRepository: [String: Any]?

    private var task: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        querySearchBar.text = "GitHubのリポジトリを検索できるよー"
        querySearchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let recipient = segue.destination as? RepositoryListRecipient {
            recipient.repositoryListProvider = self
        }
    }

    // MARK: - UISearchBarDelegate
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = "" // 初期のテキストを消す
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        task?.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let query = searchBar.text, !query.isEmpty else {
            return
        }

        let urlString = "https://api.github.com/search/repositories?q=\(query)"
        guard let searchUrl = URL(string: urlString) else {
            AlertUtil.show(GitHubAppError.invalidInput, from: self)
            return
        }

        task = URLSession.shared.dataTask(with: searchUrl) { (data, response, error) in
            do {
                guard let data = data,
                      let object = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let items = object["items"] as? [[String: Any]] else {
                    throw GitHubAppError.communicationError
                }

                self.repositoryList = items

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch let error {
                DispatchQueue.main.async {
                    AlertUtil.show(error, from: self)
                }
            }
        }
        task?.resume()
    }

    // MARK: - UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let repository = repositoryList[indexPath.row]

        cell.textLabel?.text       = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"]  as? String ?? ""

        cell.tag = indexPath.row

        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 詳細画面へ遷移する
        selectedRepository = repositoryList[indexPath.row]
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
