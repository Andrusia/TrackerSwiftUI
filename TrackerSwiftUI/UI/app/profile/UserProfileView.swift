import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        ZStack {
            if let user = viewModel.user {
                VStack(alignment: .center, spacing: 0) {
                    Text("Profile")
                        .font(.largeTitle)
                    Spacer()
                    userView(with: user)
                    Spacer()

                    Button(action: { viewModel.logoutUser() }, label: {
                        Text("logout")
                            .foregroundStyle(.white)
                            .padding()
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.red)
                                }
                            )
                    })
                    Spacer()
                }
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
    }

    func userView(with user: UserProfile) -> some View {
        VStack(alignment: .center, spacing: 25) {
            AvatarView()
                .environmentObject(viewModel)
            VStack(alignment: .center, spacing: 10) {
                infoFieldView(title: "Name:", text: user.name)
                infoFieldView(title: "Email:", text: user.email)
            }
        }
    }

    func infoFieldView(title: String, text: String) -> some View {
        HStack(alignment: .center, spacing: 0) {
            Text(title)
                .frame(width: 100, alignment: .leading)
            Text(text)
                .frame(width: 150, alignment: .leading)
                .background(
                    ZStack {
                        if text.isEmpty {
                            Text("default")
                                .foregroundStyle(.black.opacity(0.5))
                        }
                    }
                )
                .padding(.vertical, 5)
                .background(Color.black.frame(height: 1), alignment: .bottom)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(ViewModel.shared)
    }
}
