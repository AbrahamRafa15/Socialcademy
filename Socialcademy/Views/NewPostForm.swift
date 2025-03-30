//
//  NewPostForm.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 15/07/24.
//

import SwiftUI

struct NewPostForm: View {
    @StateObject var viewModel: FormViewModel<Post>
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Title", text: $viewModel.title)
                }
                Section("Content") {
                    TextEditor(text: $viewModel.content)
                        .multilineTextAlignment(.leading)
                }
                Button(action: viewModel.submit) {
                    if viewModel.isWorking {
                        ProgressView()
                    } else {
                        Text("Create Post")
                    }
                }
                .font(.headline)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .listRowBackground(Color.accentColor)
            }
            .onSubmit(viewModel.submit)
            .navigationTitle("New Post")
        }
        .alert("Cannot Create Post", error: $viewModel.error)
        .disabled(viewModel.isWorking)
        .onChange(of: viewModel.isWorking) {
            guard !viewModel.isWorking, viewModel.error == nil else { return }
            dismiss()
        }
    }
}

#Preview {
    NewPostForm(viewModel: FormViewModel(value: Post.testPost, action: {_ in}))
}



