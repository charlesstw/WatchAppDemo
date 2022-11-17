//
//  CircleImage.swift
//  SwiftUI-Essentials
//
//  Created by Willie on 2019/6/5.
//  Copyright © 2019 Willie. All rights reserved.
//

import SwiftUI

struct IconView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.system(size: 150))
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

#if DEBUG
struct IconView_Previews : PreviewProvider {
    static var previews: some View {
        IconView(text: "🐯")
    }
}
#endif
