import SwiftUI

struct UserListView: View {
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        List(viewModel.users.sorted(by: { $0.email < $1.email })) { user in
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(.headline)
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle("Users")
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        UserListView()
            .environmentObject(ViewModel.shared)
    }
}
