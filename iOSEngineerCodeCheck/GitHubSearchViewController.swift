//
//  GitHubSearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

/// 検索画面を表示する view controller.
final class GitHubSearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var querySearchBar: UISearchBar!

    /// リポジトリ検索結果.
    var repositoryList: [[String: Any]] = []
    /// 詳細を表示するリポジトリのindex.
    var selectedIndex: Int!

    private var task: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()

        querySearchBar.text = "GitHubのリポジトリを検索できるよー"
        querySearchBar.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Detail" {
            // 詳細画面にデータを受け渡す
            let detailViewController = segue.destination as! GitHubDetailViewController
            detailViewController.searchViewController = self
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
        let searchUrl = URL(string: urlString)!

        task = URLSession.shared.dataTask(with: searchUrl) { (data, response, error) in
            guard let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any],
                  let items = obj["items"] as? [[String: Any]] else {
                return
            }

            self.repositoryList = items
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        // 選択された行を保存して詳細画面へ遷移する
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
