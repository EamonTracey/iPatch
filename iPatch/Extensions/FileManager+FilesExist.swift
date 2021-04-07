//
//  FileManager+FilesExist.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import Foundation

extension FileManager {
    func filesExist(atFileURLS fileURLs: [URL]) -> Bool {
        for urlPath in fileURLs {
            if !self.fileExists(atPath: urlPath.path) {
                return false
            }
        }
        return true
    }
}
