//
//  AuthView.swift
//  Socialcademy
//
//  Created by Abraham Martinez Ceron on 18/07/24.


import SwiftUI

struct AuthView: View {
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        if viewModel.isAuthenticated {
            MainTabView()
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

struct CreateAccountForm: View {
    @StateObject var viewModel: AuthViewModel.CreateAccountViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            TextField("Name", text: $viewModel.name)
            TextField("Email", text: $viewModel.email)
            SecureField("Password", text: $viewModel.password)
        }
        footer: {
            Button("Create Account", action: viewModel.submit).buttonStyle(.primary)
        }
        .navigationTitle("Create Account")
        .onSubmit(viewModel.submit)
    }
}

struct SignInForm<Footer: View>: View {
    @StateObject var viewModel: AuthViewModel.SignInViewModel
    @ViewBuilder let footer: () -> Footer
    
    var body: some View{
        Form{
            TextField("Email", text: $viewModel.email).textInputAutocapitalization(.none)
            SecureField("Password", text: $viewModel.password).textContentType(.password)
        }
        footer: {
            Button("Sign In", action: viewModel.submit).buttonStyle(.primary)
            footer()
                .padding()
        }
        .onSubmit(viewModel.submit)
    }
}

struct Form<Content: View, Footer: View>: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let footer: () -> Footer
    
    var body: some View {
        VStack {
            Text("Socialcademy")
                .font(.title.bold())
            content()
                .padding()
                .background(Color.secondary.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            footer()
            //Button("Sign In", action: dismiss.callAsFunction)
                .padding()

        }
        .toolbar(.hidden)
        .padding()
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .background(Color.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    static var primary: PrimaryButtonStyle {
        PrimaryButtonStyle()
    }
}

#Preview {
    AuthView()
}
