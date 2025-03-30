//
//  PostRowViewModel.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 17/07/24.
//

import Foundation

@MainActor
@dynamicMemberLookup
class PostRowViewModel: ObservableObject {
    typealias Action = () async throws -> Void
    
    @Published var post: Post
    @Published var error: Error?
    
    private let deleteAction: Action?
    private let favoriteAction: Action
    
    var canDeletePost: Bool {
        deleteAction != nil
    }
    
    init(post: Post, deleteAction: Action?, favoriteAction: @escaping Action) {
        self.post = post
        self.deleteAction = deleteAction
        self.favoriteAction = favoriteAction
    }
    
    subscript<T>(dynamicMember keyPath: KeyPath<Post,T>) -> T {
        post[keyPath: keyPath]
    }
    
    func deletePost() {
        guard let deleteAction = deleteAction else {
            preconditionFailure("Cannot delete post: no delete action provided")
        }
        withErrorHandlingTask(perform: deleteAction)
    }
    
    func favoritePost() {
        withErrorHandlingTask(perform: favoriteAction)
    }
    
    private func withErrorHandlingTask(perform action: @escaping Action) {
        Task {
            do {
                try await action()
            }
            catch {
                print("[PostRowViewModel] Error: \(error)")
                self.error = error
            }
        }
    }
    
}
