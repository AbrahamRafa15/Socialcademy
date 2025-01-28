//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 18/07/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class FormViewModel<Value>: ObservableObject {
    typealias Action = (Value) async throws -> Void
    
    @Published var value: Value
    @Published var error: Error?
    
    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) ->T {
        get { value[keyPath: keyPath]}
        set { value [keyPath: keyPath] = newValue }
    }
    
    private let action: Action
    
    init(value: Value, action: @escaping Action) {
        self.value = value
        self.action = action
    }
    
    private func handleSubmit() async {
        
            do {
                try await action(value)
            }
            catch {
                print("[FormViewModel] Cannot Submit: \(error)")
                self.error = error
            }
        
    }
    
    nonisolated func submit() {
        Task {
            await handleSubmit()
        }
    }
    
}
