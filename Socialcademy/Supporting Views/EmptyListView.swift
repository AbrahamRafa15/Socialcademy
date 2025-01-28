//
//  EmptyListView.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 16/07/24.
//

import SwiftUI

struct EmptyListView: View {
    
    let title: String
    let message: String
    var retryAction: (() -> Void)?
    
    var body: some View {
        VStack (alignment: .center, spacing: 10) {
            Text(title).font(.title2).fontWeight(.semibold).foregroundStyle(Color.primary)
            Text(message)
            if let retryAction = retryAction {
                Button (action: retryAction) {
                    Text("Try again")
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 5).stroke(Color.secondary))
                }
                .padding(.top)
            }
        }
        .font(.subheadline)
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.secondary)
        .padding()
    }
}

#Preview {
    EmptyListView(title: "Cannot Load Posts", message: "Something went wrong while loading posts. Please check your internet connection.", retryAction: {})
}

#Preview {
    EmptyListView(title: "No posts", message: "There aren't any posts yet.")
}
