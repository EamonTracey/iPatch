//
//  FileManager+FilesExist.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import Foundation

extension FileManager {
    func filesExist(atURLPaths urlPaths: [URL]) -> Bool {
        for urlPath in urlPaths {
            if !FileManager.default.fileExists(atPath: urlPath.path) {
                return false
            }
        }
        return true
    }
}
