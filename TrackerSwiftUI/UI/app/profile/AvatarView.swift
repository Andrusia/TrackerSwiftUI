import SwiftUI
import PhotosUI

struct AvatarView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @EnvironmentObject var viewModel: ViewModel

    var body: some View {
        VStack {
            Color.gray
                .frame(width: 100, height: 100)
                .overlay(
                    ZStack {
                        if let urlString = viewModel.user?.avatarURL {
                            AsyncImage(url: .init(string: urlString)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                            }
                        } else {
                            Image(systemName: "photo.artframe")
                                .resizable()
                                .scaledToFit()
                                .padding(25)
                                .foregroundStyle(Color.white)

                        }
                    }
                )
                .clipShape(Circle())
                .onTapGesture {
                    showImagePicker = true
                }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedImage) { oldImage, newImage in
            if let image = newImage {
                viewModel.user?.avatarURL = ""
                viewModel.uploadAvatar(image: image)
            }
        }
    }
}

#Preview {
    AvatarView()
        .environmentObject(ViewModel.shared)
}
