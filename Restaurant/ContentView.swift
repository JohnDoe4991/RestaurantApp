//import AuthenticationServices
//import SwiftUI
//
//struct ContentView: View {
//    @Environment(\.colorScheme) var colorScheme
//    
//    @AppStorage("email") var email: String = ""
//    @AppStorage("firstName") var firstName: String = ""
//    @AppStorage("lastName") var lastName: String = ""
//    @AppStorage("userId") var userId: String = ""
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                
//                if userId.isEmpty {
//                    SignInWithAppleButton(.continue) {request in
//                        
//                        request.requestedScopes = [.email, .fullName]
//                        
//                    } onCompletion: { result in
//                        
//                        switch result {
//                        case .success(let auth):
//                            
//                            switch auth.credential {
//                            case let credential as ASAuthorizationAppleIDCredential:
//                                
//                                // User Id
//                                let userId = credential.user
//                                
//                                // User Info
//                                let email = credential.email
//                                let firstName = credential.fullName?.givenName
//                                let lastName = credential.fullName?.familyName
//                                
//                                self.email = email ?? ""
//                                self.userId = userId
//                                self.firstName = firstName ?? ""
//                                self.lastName = lastName ?? ""
//                                
//                                break
//                            default:
//                                break
//                            }
//                            
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                    .signInWithAppleButtonStyle(
//                        colorScheme == .dark ? .white : .black)
//                    .frame(height:50 )
//                    .padding()
//                    .cornerRadius(8)
//                }
//                else {
//                    // signed in 
//                }
//            }
//            .navigationTitle("Sign In")
//        }
//    }
//}

import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var userId: String = ""
    @State private var showingDetail = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if userId.isEmpty {
                    Button("Sign In with Apple") {
                        self.showingDetail = true
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .background(colorScheme == .dark ? .white : .black)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .sheet(isPresented: $showingDetail, onDismiss: {
                        // Check if any of the fields are non-empty as a condition to "log in"
                        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                            self.userId = "loggedIn" // Or use a more meaningful value/ID
                            
                        }
                    }) {
                        // Present a modal view for user details input
                        UserDetailsInputView(firstName: $firstName, lastName: $lastName, email: $email, showModal: $showingDetail)
                    }
                } else {
                    HomeScreen()
                }
            }
            .navigationTitle("Sign In")
        }
    }
}


struct UserDetailsInputView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var showModal: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Information")) {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                    TextField("Email", text: $email)
                }
                Section {
                    Button("Submit") {
                        // Submitting the form will now dismiss the modal and trigger navigation in ContentView
                        self.showModal = false
                        // No need to manually set userId here; ContentView handles it on modal dismissal
                    }
                }
            }
            .navigationBarTitle("Enter Details", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                self.showModal = false
            })
        }
    }
}

#Preview {
    ContentView()
}
