//
//  dependencies.swift
//  iPatch
//
//  Created by Eamon Tracey on 4/8/21.
//

func validateDependencies() {
    if !fileManager.filesExist(atFileURLS: [URL(fileURLWithPath: AR), URL(fileURLWithPath: TAR), URL(fileURLWithPath: INSTALL_NAME_TOOL), URL(fileURLWithPath: UNZIP), URL(fileURLWithPath: ZIP)]) {
        fatalExit("Missing dependencies. Please ensure you have installed the Xcode command line tools. iPatch requires \(AR), \(TAR), \(INSTALL_NAME_TOOL), \(UNZIP), and \(ZIP)")
    }
}
