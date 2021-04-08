//
//  dependencies.swift
//  iPatch
//
//  Created by Eamon Tracey on 4/8/21.
//

func validateDependencies() {
    if !fileManager.filesExist(atFileURLS: [URL(fileURLWithPath: DPKGDEB), URL(fileURLWithPath: INSTALL_NAME_TOOL), URL(fileURLWithPath: ZIP), URL(fileURLWithPath: UNZIP)]) {
        fatalExit("Missing dependencies. Please ensure you have installed the Xcode command line tools and dpkg-deb. You can install dpkg with brew.")
    }
}
