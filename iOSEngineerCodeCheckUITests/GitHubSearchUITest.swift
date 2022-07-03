//
//  GitHubSearchUITest.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

/// 検索画面のUIテスト.
final class GitHubSearchUITest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// NavigationBarのタイトルを確認する.
    func testNavigationBarTitle() throws {
        let app = XCUIApplication()
        XCTContext.runActivity(named: "Launch app") { _ in
            app.launch()
        }

        XCTContext.runActivity(named: "検索画面の表示をチェックする。") { _ in
            XCTAssertTrue(app.navigationBars["リポジトリ検索"].exists)
        }
    }

    /// キーワード検索を実行する.
    /// - Parameters:
    ///   - keyword: 検索キーワード.
    /// - Returns: 検索結果数.
    private func searchWithKeyword(_ keyword: String) throws -> Int {
        let app = XCUIApplication()

        XCTContext.runActivity(named: "Launch app") { _ in
            app.launch()
        }

        XCTContext.runActivity(named: "Search with \(keyword)") { _ in
            let searchField = app.searchFields.element
            searchField.tap()
            searchField.typeText(keyword)
            app.keyboards.buttons["Search"].tap()
        }

        XCTContext.runActivity(named: "Waiting for search results") { _ in
            XCTAssertTrue(app.tables.cells.element.waitForExistence(timeout: 5), "検索がタイムアウトしました。")
        }

        return app.tables.cells.count
    }

    /// キーワード"Swift"で検索する.
    /// - Returns: 検索結果数.
    @discardableResult
    private func searchKeywordSwift() throws -> Int {
        try searchWithKeyword("Swift")
    }

    /// キーワード"Swift"で検索して結果数を検査するテスト.
    func testSearchKeywordSwift() throws {
        let expectedCount = 50
        let resultCount = try searchKeywordSwift()
        XCTContext.runActivity(named: "Check number of results") { _ in
            XCTAssertEqual(resultCount, expectedCount, "検索結果が\(expectedCount)個ではありません。")
        }
    }

    /// 詳細画面に遷移するテスト.
    func testTransitToDetail() throws {
        try searchKeywordSwift()

        let app = XCUIApplication()

        let fullName = "apple/swift"
        XCTContext.runActivity(named: "Table内のラベルが\"\(fullName)\"のcellをタップする.") { _ in
            let cell = app.tables.cells.containing(NSPredicate(format: "label CONTAINS '\(fullName)'")).firstMatch
            XCTAssertTrue(cell.exists, "ラベルが\"\(fullName)\"のcellが存在しません。")
            cell.tap()
        }

        XCTContext.runActivity(named: "詳細画面の表示をチェックする。") { _ in
            XCTAssertTrue(app.navigationBars["詳細"].exists)
        }
    }
}
