//
//  AuthView.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 18/07/24.


import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        if let user = viewModel.user {
            MainTabView().environmentObject(ViewModelFactory(user: user))
       }
        else {
            NavigationStack {
                SignInForm(viewModel: viewModel.makeSignInViewModel()) {
                    NavigationLink("Create Account", destination: CreateAccountForm(viewModel: viewModel.makeCreateAccountViewModel()))
                }
            }
        }
    }
}

private extension AuthView {
    
    struct CreateAccountForm: View {
        @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            Form {
                TextField("Name", text: $viewModel.name).textContentType(.name).textInputAutocapitalization(.words)
                TextField("Email", text: $viewModel.email).textContentType(.emailAddress).textInputAutocapitalization(.never)
                SecureField("Password", text: $viewModel.password).textContentType(.newPassword)
            }
            footer: {
                Button("Create Account", action: viewModel.submit).buttonStyle(.primary)
            }
            .alert("Cannot Create Account", error: $viewModel.error)
            .onSubmit(viewModel.submit)
            .disabled(viewModel.isWorking)
        }
        
    }
}

private extension AuthView {
    struct SignInForm<Footer: View>: View {
        @StateObject var viewModel: AuthViewModel.SignInViewModel
        @ViewBuilder let footer: () -> Footer
        
        var body: some View{
            Form {
                TextField("Email", text: $viewModel.email).textContentType(.emailAddress).textInputAutocapitalization(.never)
                SecureField("Password", text: $viewModel.password).textContentType(.password)
            } footer: {
                Button("Sign In", action: viewModel.submit).buttonStyle(.primary)
                footer()
                    .padding()
            }
            .alert("Cannot Sign In", error: $viewModel.error)
            .onSubmit(viewModel.submit)
            .disabled(viewModel.isWorking)
        }
    }
}

private extension AuthView {
    
    struct Form<Fields: View, Footer: View>: View {
        @ViewBuilder let fields: () -> Fields
        @ViewBuilder let footer: () -> Footer
        
        var body: some View {
            VStack {
                Text("Socialcademy")
                    .font(.title.bold())
                fields()
                    .padding()
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                footer()
            }
            .toolbar(.hidden)
            .padding()
        }
    }
}


#Preview {
    AuthView()
}
