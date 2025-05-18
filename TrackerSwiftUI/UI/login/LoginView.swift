import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var email = "a1@a.com"
    @State private var password = "1111qqqq"

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: {
                viewModel.loginUser(email: email, password: password)
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(ViewModel.shared)
    }
}
