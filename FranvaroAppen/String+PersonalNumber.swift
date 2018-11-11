//
//  String+PersonalNumber.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2018-11-01.
//  Copyright © 2018 Knut Inge Grosland. All rights reserved.
//

import Foundation

extension String {
    var isValidPersonalNumber: Bool {
        let pat = "\\d\\d\\d\\d\\d\\d-\\w\\w\\w\\w"
        let regex = try! NSRegularExpression(pattern: pat, options: [])
        return regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) == 1
    }
}
