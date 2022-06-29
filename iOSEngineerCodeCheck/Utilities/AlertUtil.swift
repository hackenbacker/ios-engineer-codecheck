//
//  AlertUtil.swift
//  iOSEngineerCodeCheck
//
//  Created by Toshio Nakao on 2022/06/29.
//  Copyright © 2022 YUMEMI Inc. All rights reserved.
//

import UIKit

/// アラート表示用のユーティリティ.
final class AlertUtil {
    
    private init() {} // prevent instantiation.

    /// Errorオブジェクトからアラートを表示する.
    /// - Parameters:
    ///   - error: Errorオブジェクト.
    ///   - from:  アラートを表示するview controller.
    static func show(_ error: Error, from viewController: UIViewController) {
        let alert = UIAlertController(title: "エラー",
                                      message: error.localizedDescription,
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default) { _ in
            viewController.dismiss(animated: true)
        })

        viewController.present(alert, animated: true)
    }
}
