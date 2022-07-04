//
//  GitHubSearchPage.swift
//  iOSEngineerCodeCheckUITests
//
//  Created by Toshio Nakao on 2022/07/04.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import XCTest

/// 検索画面用のPageObject.
final class GitHubSearchPage: PageObject {
    let app: XCUIApplication = XCUIApplication()

    var pageTitle: XCUIElement {
        app.navigationBars["リポジトリ検索"].firstMatch
    }

    /// Returns the search bar.
    var searchBar: XCUIElement {
        app.searchFields.firstMatch
    }

    /// Returns the search button.
    var searchButton: XCUIElement {
        app.keyboards.buttons["Search"].firstMatch
    }

    /// Returns the first cell.
    var cellsFirst: XCUIElement {
        app.tables.cells.firstMatch
    }

    /// Returns number of cells.
    var cellsCount: Int {
        app.tables.cells.count
    }

    /// Types a search word into the search bar.
    /// - Parameter text: A search word.
    /// - Returns: Instance of itself.
    func typeSearchWord(_ text: String) -> Self {
        searchBar.tap()
        searchBar.typeText(text)
        return self
    }

    /// Taps the search button on the keyboard.
    /// - Returns: Instance of itself.
    func tapSearchButton() -> Self {
        searchButton.tap()
        return self
    }

    /// Waits the amount of time for the search completion.
    /// - Parameter timeout: Timeout Period.
    /// - Returns: true; success, false: timeout.
    func waitForSearchResult(timeout: TimeInterval) -> Bool {
        cellsFirst.waitForExistence(timeout: timeout)
    }

    /// Finds a cell containing the text.
    /// - Parameter text: A containing text.
    /// - Returns: A found.cell.
    func findCellFor(_ text: String) -> XCUIElement {
        app.tables.cells.containing(NSPredicate(format: "label CONTAINS '\(text)'")).firstMatch
    }

    /// Taps a cell containing the text.
    /// - Parameter text: A containing text.
    /// - Returns: Instance of GitHubDetailPage. If nil, the cell was not found.
    func tapCellFor(_ text: String) -> GitHubDetailPage? {
        let cell = findCellFor(text)

        if cell.exists {
            cell.tap()
            return GitHubDetailPage()
        } else {
            return nil
        }
    }
}
