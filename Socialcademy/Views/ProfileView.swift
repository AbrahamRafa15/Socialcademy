//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 18/07/24.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }
}

#Preview {
    ProfileView()
}
