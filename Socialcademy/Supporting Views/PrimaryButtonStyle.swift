//
//  PrimaryButtonStyle.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 17/02/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Group{
            if isEnabled {
                configuration.label
            }
            else{
                ProgressView()
            }
        }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(10)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}
