//
//  Bundle+Extension.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import Foundation

extension Bundle {
    
    var apiKey: String? {
        return infoDictionary?["API_KEY"] as? String
    }
    
}
