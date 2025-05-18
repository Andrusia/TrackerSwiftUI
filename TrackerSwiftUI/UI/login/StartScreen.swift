import SwiftUI

struct StartScreen: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var showRegister: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    LoginView()
                        .environmentObject(viewModel)

                        Button(action: { showRegister = true }, label: {
                            Text("Switch to Register")
                                .font(.headline)
                        })
                }
                .textInputAutocapitalization(.never)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(colors: [
                    .gray, .gray.opacity(0.4)
                ], startPoint: .topLeading, endPoint: .bottomTrailing)
            )
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
                    .environmentObject(viewModel)
            }
//            .navigation(isActive: $showRegister) {
//                RegisterView()
//                    .environmentObject(viewModel)
//            }

        }
    }
}

#Preview {
    StartScreen()
        .environmentObject(ViewModel.shared)
}
