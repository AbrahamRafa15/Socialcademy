//
//  PostRepository.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 15/07/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol PostRepositoryProtocol {
    func fetchAllPosts() async throws -> [Post]
    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    func fetchFavoritePosts() async throws -> [Post]
}

struct PostRepository: PostRepositoryProtocol {
    let postsReference = Firestore.firestore().collection("posts_v1")
    
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference)
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("isFavorite", isEqualTo: true))
    }
    
    private func fetchPosts(from query: Query) async throws -> [Post] {
        let snapshot = try await query.order(by: "timestamp", descending: true).getDocuments()
        return snapshot.documents.compactMap {
            document in
            try! document.data(as: Post.self)
        }
    }
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func favorite(_ post: Post) async throws {
        
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": true], merge: true)
        
    }
    
    func unfavorite(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(["isFavorite": false], merge: true)

    }
    
    
    
}

private extension DocumentReference {
    func setData<T: Encodable>(from value: T) async throws {
        return try await withCheckedThrowingContinuation {
            continuation in
            try! setData(from: value) {
                error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                continuation.resume()
            }
        }
    }
}

#if DEBUG
struct PostRepositoryStub: PostRepositoryProtocol {
    let state: Loadable<[Post]>
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func create(_ post: Post) async throws {
        
    }
    
    func delete(_ post: Post) async throws {
        
    }
    
    func favorite(_ post: Post) async throws {
        
    }
    
    func unfavorite(_ post: Post) async throws {
        
    }
    
}
#endif
