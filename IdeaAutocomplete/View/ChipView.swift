//
//  ChipView.swift
//  IdeaAutocomplete
//
//  Created by Kaustubh on 04/08/23.
//

import SwiftUI

struct ChipView: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            Image(systemName: "x.circle.fill")
                .padding(.leading, 3)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(.pink.opacity(0.7)))
        .foregroundColor(.white)
        .cornerRadius(18)
    }
}

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipView(text: "Random chip")
    }
}
