//
//  iOSEngineerCodeCheckUITests.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

/// 検索画面のUIテスト.
final class iOSEngineerCodeCheckUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// アプリの起動直後に検索画面が表示されるか確認する.
    func testLaunchAppWithSearchPage() throws {
        let searchPage = GitHubSearchPage()

        XCTContext.runActivity(named: "Launch app") { _ in
            searchPage.app.launch()
        }

        XCTContext.runActivity(named: "検索画面の表示をチェックする。") { _ in
            XCTAssertTrue(searchPage.exists)
        }
    }

    /// キーワード検索を実行する.
    /// - Parameters:
    ///   - word: 検索ワード.
    /// - Returns: 検索結果数.
    private func searchByWord(_ word: String) throws -> Int {
        let searchPage = GitHubSearchPage()

        XCTContext.runActivity(named: "Launch app") { _ in
            searchPage.app.launch()
        }

        XCTContext.runActivity(named: "Search with \(word)") { _ in
            XCTAssertTrue(searchPage
                            .typeSearchWord(word)
                            .tapSearchButton()
                            .waitForSearchResult(timeout: 5),
                          "検索がタイムアウトしました。")
        }

        return searchPage.cellsCount
    }

    /// キーワード"Swift"で検索する.
    /// - Returns: 検索結果数.
    @discardableResult
    private func searchByWordSwift() throws -> Int {
        try searchByWord("Swift")
    }

    /// キーワード"Swift"で検索して結果数を検査するテスト.
    func testSearchByWordSwift() throws {
        let expectedCount = 50
        let resultCount = try searchByWordSwift()
        XCTContext.runActivity(named: "Check number of results") { _ in
            XCTAssertEqual(resultCount, expectedCount, "検索結果が\(expectedCount)個ではありません。")
        }
    }

    /// 詳細画面に遷移するテスト.
    func testTransitToDetail() throws {
        try searchByWordSwift()

        let searchPage = GitHubSearchPage()

        let fullName = "apple/swift"
        XCTContext.runActivity(named: "詳細画面に画面遷移") { _ in
            if let detailPage = searchPage.tapCellFor(fullName) {
                XCTAssertTrue(detailPage.exists, "詳細画面が見つかりません。")
            } else {
                XCTFail("ラベルが\"\(fullName)\"のcellが見つかりません。")
            }
        }
    }
}
