//
//  ViewModelFactory.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 20/03/25.
//

import Foundation

@MainActor
class ViewModelFactory: ObservableObject {
    private let user: User
    
    init(user: User){
        self.user = user
    }
    
    func makePostsViewModel(filter: PostViewModel.Filter = .all) -> PostViewModel {
        return PostViewModel(filter: filter, postRepository: PostRepository(user: user))
    }
}

#if DEBUG
extension ViewModelFactory {
    static let preview = ViewModelFactory(user: User.testUser)
}
#endif
