//
//  ViewState.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/07/01.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import Foundation

/// Viewの状態を表現する.
enum ViewState<Value> {
    case idle           // 初期状態
    case loading        // データ取得中
    case loaded(Value)  // データ取得済み
    case failed(Error)  // エラー発生
}
