//
//  UIColor+App.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-11.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    
    struct App {
        static var light: UIColor { return UIColor(red: 0.918, green: 0.918, blue: 0.918, alpha: 1)  } // eaeaea
        static var blue: UIColor { return UIColor(red:0.24, green:0.47, blue:0.58, alpha:1.0)  }  // 3D7794
        static var green: UIColor { return UIColor(red:0.239, green:0.467, blue:0.027, alpha:1)  } // 3D7707
        static var orange: UIColor { return UIColor(red: 0.886, green: 0.435, blue: 0.149, alpha: 1)  } // e26f26
        static var darkBlue: UIColor { return UIColor(red: 0.243, green: 0.314, blue: 0.416, alpha: 1)  } // 3e506a
        static var lightBlue: UIColor { return UIColor(red: 0.380, green: 0.675, blue: 0.914, alpha: 1)  } // 61ace9
        static var dark: UIColor { return UIColor(red: 0.180, green: 0.196, blue: 0.204, alpha: 1)  } // 2e3234
        static var background: UIColor { return UIColor(red: 46, green: 57, blue: 81)  } // 2E3951
    }
    
}
