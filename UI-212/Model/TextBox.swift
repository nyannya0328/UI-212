//
//  TextBox.swift
//  UI-212
//
//  Created by にゃんにゃん丸 on 2021/05/29.
//

import SwiftUI

struct TextBox: Identifiable {
    var id = UUID().uuidString
    var text :String = ""
    var isBold : Bool = false
    var offset : CGSize = .zero
    var lastoffset : CGSize = .zero
    var textcolor : Color = .white
    var size : CGFloat = 30
    var isAdded : Bool = false
    
}

