import SwiftUI

struct RootView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showLogin = true
    
    var body: some View {
        Color.clear
            .overlay(
                ZStack {
                    switch viewModel.currentScreen {
                    case .loading:
                        LinearGradient(colors: [
                            .black, .red
                        ], startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                        .overlay(
                            VStack {
                                Text("Loading...")
                                ProgressView()
                            }
                        )
                    case .login:
                        StartScreen()
                            .environmentObject(viewModel)
                    case .app:
                        AppTabView()
                            .environmentObject(viewModel)
                    }
                    if viewModel.isPerformingAction {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.black.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                    }
                }
            )
            .appAlert(item: $viewModel.errorMessage) {
                Text($0)
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black)
            }
            .allowsHitTesting(!viewModel.isPerformingAction)
    }
}

#Preview {
    RootView()
        .environmentObject(ViewModel.shared)
}
