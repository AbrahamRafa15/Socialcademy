//
//  PostRow.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 15/07/24.
//

import SwiftUI

struct PostRow: View {
    
    @ObservedObject var viewModel: PostRowViewModel
    
    @State private var showConfirmationDialog = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.authorName).font(.subheadline).fontWeight(.medium)
                Spacer()
                Text(viewModel.timestamp.formatted(date: .abbreviated, time: .omitted)).font(.caption)
            }
            .foregroundStyle(Color.gray)
            Text(viewModel.title).font(.title3)
                .fontWeight(.semibold)
            Text(viewModel.content)
            HStack{
                FavoriteButton(isFavorite: viewModel.isFavorite, action: {
                    viewModel.favoritePost()
                })
                Spacer()
                Button(role: .destructive, action: {
                    showConfirmationDialog = true
                }) {
                    Label("Delete", systemImage: "trash")
                }
            }
            
            .labelStyle(.iconOnly)
            .buttonStyle(.borderless)
        }
        .padding(.vertical)
        .confirmationDialog("Are you sure you want to delete this post?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
            Button("Delete", role: .destructive, action: {
                viewModel.deletePost()
            })
        }
        .alert("Error", error: $viewModel.error)
        
    }
    
}

private extension PostRow {
    struct FavoriteButton: View {
        let isFavorite: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                if isFavorite {
                    Label("Remove from Favorite", systemImage: "heart.fill")
                }
                else {
                    Label("Add to Favorites", systemImage: "heart")
                }
            }
            .foregroundStyle(isFavorite ? Color.red : Color.gray)
            .animation(.default, value: isFavorite)
        }
    }
}

#Preview {
    List {
        PostRow(viewModel: PostRowViewModel(post: Post.testPost, deleteAction: {}, favoriteAction: {}))
    }
}
