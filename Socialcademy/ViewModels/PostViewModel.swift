//
//  PostViewModel.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 15/07/24.
//

import Foundation



@MainActor
class PostViewModel: ObservableObject {
    
    enum Filter {
        case all, favorites
    }
    
    @Published var posts: Loadable<[Post]> = .loading
    private let postRepository: PostRepositoryProtocol
    private let filter: Filter
    
    var title: String {
        switch filter{
        case .all:
            return "Posts"
        case .favorites:
            return "Favorites"
        }
    }
    
    init(filter: Filter = .all ,postRepository: PostRepositoryProtocol = PostRepository()){
        self.filter = filter
        self.postRepository = postRepository
    }
    
    func makePostRowViewModel(for post: Post) -> PostRowViewModel {
        return PostRowViewModel(post: post, deleteAction: {
            [weak self] in
            try await self?.postRepository.delete(post)
            self?.posts.value?.removeAll {
                $0 == post
            }
        }, favoriteAction: {
            [weak self] in
                let newValue = !post.isFavorite
                try await newValue ? self?.postRepository.favorite(post): self?.postRepository.unfavorite(post)
                guard let i = self?.posts.value?.firstIndex(of: post) else {return }
                self?.posts.value?[i].isFavorite = newValue
        })
    }
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await self?.postRepository.create(post)
            self?.posts.value?.insert(post, at: 0)
        }
    }
    
    func fetchPosts() {
        Task {
            do {
                posts = .loaded(try await postRepository.fetchPosts(matching: filter))
            }
            catch {
                print("[PostsViewModel] Cannot fetch posts: \(error)")
                posts = .error(error)
            }
        }
    }
    
}


private extension PostRepositoryProtocol {
    func fetchPosts(matching filter: PostViewModel.Filter) async throws -> [Post] {
        switch filter{
        case .all:
            return try await fetchAllPosts()
        case .favorites:
            return try await fetchFavoritePosts()
        }
    }
}
