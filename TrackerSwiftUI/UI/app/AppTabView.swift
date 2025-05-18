import SwiftUI

struct AppTabView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        TabView(selection: $viewModel.currentTabScreen) {
            ForEach(TabScreen.allCases, id: \.self) { screen in
                    tabScreenView(with: screen)
                    .tabItem {
                        Text(screen.title)
                            .foregroundStyle(.black)
                    }
                    .tag(screen)
            }
        }
    }

    @ViewBuilder
    func tabScreenView(with screen: TabScreen) -> some View {
        switch screen {
        case .profile:
            UserProfileView()
                .environmentObject(viewModel)
        case .users:
            UserListView()
                .environmentObject(viewModel)
        }
    }
}

#Preview {
    AppTabView()
        .environmentObject(ViewModel.shared)
}
