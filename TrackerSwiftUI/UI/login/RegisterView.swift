import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var email = "a1@a.com"
    @State private var password = "1111qqqq"

    var body: some View {
        ZStack {
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button(action: {
                    closeKeyboard()
                    viewModel.createUser(email: email, password: password, name: nil)
                }) {
                    Text("Register")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .autocorrectionDisabled(true)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(colors: [
                .gray, .gray.opacity(0.4)
            ], startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(ViewModel.shared)
    }
}
