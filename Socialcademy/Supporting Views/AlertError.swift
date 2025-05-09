//
//  AlertError.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 17/07/24.
//

import SwiftUI

private struct ErrorAlertViewModifier : ViewModifier {
    let title: String
    @Binding var error: Error?
    
    func body(content: Content) -> some View {
        content.alert(title, isPresented: $error.hasValue, presenting: error, actions: {_ in}) {
            error in
            Text(error.localizedDescription)
        }
    }
    
}

private extension Optional {
    var hasValue: Bool{
        get {self != nil}
        set {self = newValue ? self : nil}
    }
}

extension View {
    func alert(_ title: String, error: Binding<Error?>) -> some View {
        modifier(ErrorAlertViewModifier(title: title, error: error))
    }
}

struct ErrorAlertViewModifier_Previews: PreviewProvider {
    static var previews: some View {
        Text("Preview")
            .alert("Error", error: .constant(PreviewError()))
    }
    
    private struct PreviewError: LocalizedError {
        let errorDescription: String? = "Lorem ipsum dolor set amet."
    }
}
