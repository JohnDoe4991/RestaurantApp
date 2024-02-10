import AuthenticationServices
import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                if userId.isEmpty {
                    SignInWithAppleButton(.continue) {request in
                        
                        request.requestedScopes = [.email, .fullName]
                        
                    } onCompletion: { result in
                        
                        switch result {
                        case .success(let auth):
                            
                            switch auth.credential {
                            case let credential as ASAuthorizationAppleIDCredential:
                                
                                // User Id
                                let userId = credential.user
                                
                                // User Info
                                let email = credential.email
                                let firstName = credential.fullName?.givenName
                                let lastName = credential.fullName?.familyName
                                
                                self.email = email ?? ""
                                self.userId = userId
                                self.firstName = firstName ?? ""
                                self.lastName = lastName ?? ""
                                
                                break
                            default:
                                break
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    .signInWithAppleButtonStyle(
                        colorScheme == .dark ? .white : .black)
                    .frame(height:50 )
                    .padding()
                    .cornerRadius(8)
                }
                else {
                    // signed in 
                }
            }
            .navigationTitle("Sign In")
        }
    }
}

#Preview {
    ContentView()
}
