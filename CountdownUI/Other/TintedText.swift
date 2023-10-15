//
//  File.swift
//  CountdownUI
//
//  Created by Joe Rupertus on 10/1/23.
//

import Foundation
import SwiftUI

struct TintedText<Content: View>: View {
    
    var tint: Color
    var material: Material = .regularMaterial
    
    var text: () -> Content
    
    var body: some View {
        ZStack {
            text().foregroundStyle(tint)
            text().foregroundStyle(material)
        }
    }
}
