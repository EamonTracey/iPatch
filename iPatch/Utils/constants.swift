//
//  constants.swift
//  iPatch
//
//  Created by Eamon Tracey on 4/8/21.
//

import Foundation

let SUBSTRATEINFOTEXT = "iPatch supports injecting libsubstrate, libblackjack, and libhooker into IPAs. This feature is meant to be used when injecting substrate tweak dylibs into an IPA. If you are injecting an app tweak, toggle this option on. Otherwise, toggle it off."
let EXECIPATCHDYLIBS = "@executable_path/iPatchDylibs"

let DPKGDEB = "/usr/local/bin/dpkg-deb"
let INSTALL_NAME_TOOL = "/usr/bin/install_name_tool"
let ZIP = "/usr/bin/zip"
let UNZIP = "/usr/bin/unzip"
