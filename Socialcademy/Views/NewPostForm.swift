//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 15/07/24.
//

import SwiftUI

struct NewPostForm: View {
    
    typealias CreateAction = (Post) async throws -> Void
    
    let createAction: CreateAction
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var post = Post(title: "", content: "", authorName: "")
    
    @State private var state = FormState.idle
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $post.title)
                    TextField("Author Name", text: $post.authorName)
                }
                Section("Content") {
                    TextEditor(text: $post.content).multilineTextAlignment(.leading)
                }
                Button(action: createPost) {
                    if state == .working {
                         ProgressView()
                    }
                    else {
                        Text("Create Post")
                    }
                }.font(.headline)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.white)
                    .padding()
                    .listRowBackground(Color.accentColor)
            }
        footer: {
            
        }
            .onSubmit(createPost)
            .navigationTitle("New Post")
        }
        .disabled(state == .working)
        .alert("Cannot Create Post", isPresented: $state.isError, actions: {}) {
            Text("Sorry, something went wrong.")
        }
        
    }
    
    private func createPost() {
        Task {
            state = .working
            do {
                try await createAction(post)
                dismiss()
            }
            catch {
                print("[NewPostForm] Cannot create post: \(error)")
                state = .error
            }
        }
        
    }
    
}

#Preview {
    NewPostForm(createAction: {_ in })
}

private extension NewPostForm {
    enum FormState {
        case idle, working, error
        
        var isError: Bool {
            get {
                self == .error
            }
            set {
                guard !newValue else { return }
                self = .idle
            }
        }
    }
    
}


