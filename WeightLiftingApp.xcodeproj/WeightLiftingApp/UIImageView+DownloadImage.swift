//
//  UIImageView+DownloadImage.swift
//  WeightLiftingApp
//
//  Created by Khandaker Shayel on 11/15/20.
//  Copyright © 2020 Hunter CSCI Student. All rights reserved.
//

import Foundation
import UIKit

//code from chapter 41 of the textbook taken directly
extension UIImageView {
      func loadImage(url: URL) -> URLSessionDownloadTask {
            let session = URLSession.shared
            let downloadTask = session.downloadTask(with: url,
            completionHandler: { [weak self] url, response, error in
                if error == nil, let url = url,
                    let data = try? Data(contentsOf: url),
                            let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let weakSelf = self {
                            weakSelf.image = image
                        }
                    }
                }
            })
            downloadTask.resume()
            return downloadTask
      }
}
