//
//  GitHubSearchViewController.swift
//  iOSEngineerCodeCheck
//
//  Created by 史 翔新 on 2020/04/20.
//  Copyright © 2020 YUMEMI Inc. All rights reserved.
//

import UIKit

final class GitHubSearchViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var querySearchBar: UISearchBar!

    var repositoryList: [[String: Any]] = []
    var selectedIndex: Int!

    private var task: URLSessionTask?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        querySearchBar.text = "GitHubのリポジトリを検索できるよー"
        querySearchBar.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
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
        let url = URL(string: urlString)!

        task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            if let obj = try! JSONSerialization.jsonObject(with: data!) as? [String: Any] {
                if let items = obj["items"] as? [[String: Any]] {
                    self.repositoryList = items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        // これ呼ばなきゃリストが更新されません
        task?.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "Detail" {
            let detailViewController = segue.destination as! GitHubDetailViewController
            detailViewController.searchViewController = self
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositoryList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell()
        let rp   = repositoryList[indexPath.row]

        cell.textLabel?.text       = rp["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = rp["language"]  as? String ?? ""

        cell.tag = indexPath.row

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 画面遷移時に呼ばれる
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
