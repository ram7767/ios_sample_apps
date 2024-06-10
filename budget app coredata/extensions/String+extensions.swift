//
//  String+extensions.swift
//  budget app coredata
//
//  Created by Ram on 10/06/24.
//

import UIKit

extension String {
    
    var isEmptyOrWhiteSpaces: Bool {
        trimmingCharacters(in: .whitespaces).isEmpty
    }
}
