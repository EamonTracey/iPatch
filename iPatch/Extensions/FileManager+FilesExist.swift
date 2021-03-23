//
//  FileManager+FilesExist.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import Foundation

extension FileManager {
    func filesExist(atFileURLS fileURLS: [URL]) -> Bool {
        for urlPath in fileURLS {
            if !FileManager.default.fileExists(atPath: urlPath.path) {
                return false
            }
        }
        return true
    }
}
