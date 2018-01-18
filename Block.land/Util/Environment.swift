//
//  Environment.swift
//  Block.land
//
//  Created by Nicolas Nascimento on 16/01/18.
//  Copyright © 2018 Nicolas Nascimento. All rights reserved.
//

import Foundation

// Constants & Default Values
enum Environment {
    
    /// Tells wheter the Environment is supposed to use Debug Features
    static let debugMode: Bool = {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }()
    
    // The folders contained in the app
    enum Folder {
        static let assets3DFolder = "Assets-3D.scnassets/"
    }
    
    // The relevante files in the project
    enum Files {
        static let baseWorldScene = Folder.assets3DFolder + "world.scn"
    }
}
