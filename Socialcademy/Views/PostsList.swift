//
//  PostsList.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 15/07/24.
//

import SwiftUI

struct PostsList: View {
    
    @StateObject var viewModel: PostViewModel
    @State private var searchText = ""
    @State private var showNewPostForm = false
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.posts {
                case .loading:
                    ProgressView()
                case let .error(error):
                    EmptyListView(title: "Cannot load posts", message: error.localizedDescription, retryAction: {viewModel.fetchPosts()})
                case .empty:
                    EmptyListView (title: "No Posts", message: "There aren't any posts yet.")
                case let .loaded(posts):
                    ScrollView {
                        ForEach(posts) {
                            post in
                            if searchText.isEmpty || post.contains(searchText) {
                                PostRow(viewModel: viewModel.makePostRowViewModel(for: post))
                                
                            }
                        }
                    }
                    .animation(.default, value: posts)
                    .searchable(text: $searchText)
                }
            }
            .navigationTitle(viewModel.title)
            .toolbar {
                Button {
                    showNewPostForm = true
                }
                label: {
                    Label("New Post", systemImage: "square.and.pencil")
                }
            }
            
            .sheet(isPresented: $showNewPostForm) {
                NewPostForm(viewModel: viewModel.makeNewPostViewModel())
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
        
        
    }
}

#Preview {
    //PostsList()
}

#if DEBUG
struct PostsList_Previews: PreviewProvider {
    
    static var previews: some View {
        ListPreview(state: .loaded([Post.testPost]))
        ListPreview(state: .empty)
        ListPreview(state: .error)
        ListPreview(state: .loading)
    }
    
    @MainActor
    private struct ListPreview: View {
        let state: Loadable<[Post]>
        
        var body: some View {
            let postsRepository = PostRepositoryStub(state: state)
            let viewModel = PostViewModel(postRepository: postsRepository)
            PostsList(viewModel: viewModel)
        }
    }
    
}
#endif
