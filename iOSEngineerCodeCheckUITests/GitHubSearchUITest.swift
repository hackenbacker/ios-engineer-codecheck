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
        continueAfterFailure = true
    }

    /// NavigationBarのタイトルを確認する.
    func testNavigationBarTitle() throws {
        let app = XCUIApplication()
        XCTContext.runActivity(named: "Launch app") { _ in
            app.launch()
        }

        XCTContext.runActivity(named: "Check content view") { _ in
            XCTAssertTrue(app.navigationBars["リポジトリ検索"].exists)
        }
    }

    /// キーワード検索を実行する..
    func testSearchWithKeyword() throws {
        let app = XCUIApplication()
        XCTContext.runActivity(named: "Launch app") { _ in
            app.launch()
        }

        let keyword = "Swift"
        XCTContext.runActivity(named: "Search with \(keyword)") { _ in
            let searchField = app.searchFields.element
            searchField.tap()
            searchField.typeText(keyword)
            app.keyboards.buttons["Search"].tap()
        }

        XCTContext.runActivity(named: "Waiting for search results") { _ in
            XCTAssertTrue(app.tables.cells.element.waitForExistence(timeout: 5), "検索がタイムアウトしました。")
        }

        XCTContext.runActivity(named: "Check number of results") { _ in
            let expectedCount = 50
            XCTAssertEqual(app.tables.cells.count, expectedCount, "検索結果が\(expectedCount)個ではありません。")
        }
    }
}
