import SwiftUI

extension View {
    func appAlertBinding<Item: Equatable, Content: View>(
        item: Binding<Binding<Item>?>,
        @ViewBuilder content: @escaping (Binding<Item>, Binding<Bool>) -> Content
    ) -> some View {
        self.overlay(AppAlertView(item: item, content: content))
    }

    func appAlert<Content: View>(
        isActive: Binding<Bool>,
        isAutoBack: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.overlay(AppAlert(isActive: isActive, isAutoBack: isAutoBack, content: content))
    }

    func appAlert<Item: Hashable, Content: View>(
        item: Binding<Item?>,
        isAutoBack: Bool = true,
        @ViewBuilder content: @escaping (Item) -> Content
    ) -> some View {
        let isActive = Binding(
            get: {
                item.wrappedValue != nil
            },
            set: { value in
                if !value {
                    item.wrappedValue = nil
                }
            }
        )
        return appAlert(isActive: isActive, isAutoBack: isAutoBack) {
            if let unwrappedItem = item.wrappedValue {
                content(unwrappedItem)
            }
        }
    }
}

fileprivate struct ChangeBinding<Item, Content: View>: View {
    @Binding var isActive: Bool
    @Binding var item: Item

    let content: (Binding<Item>, Binding<Bool>) -> Content

    var body: some View {
        content($item, $isActive)
    }
}

struct AppAlert<Content: View>: View {
    @Binding var isActive: Bool
    let isAutoBack: Bool
    let content: () -> Content

    var body: some View {
        ZStack {
            if isActive {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if isAutoBack {
                            self.isActive = false
                        }
                    }
                content()
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.linear(duration: 0.4), value: isActive)
    }
}

struct AppAlertView<Content: View, Item: Equatable>: View {
    @Binding var item: Binding<Item>?
    let content: (Binding<Item>, Binding<Bool>) -> Content

    init(item: Binding<Binding<Item>?>, @ViewBuilder content: @escaping (Binding<Item>, Binding<Bool>) -> Content) {
        self._item = item
        self.content = content
    }

    var body: some View {
        let isActive = Binding(
            get: { item != nil },
            set: { value in
                if !value {
                    item = nil
                }
            }
        )

        return ZStack {
            if let item {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.item = nil
                    }
                ChangeBinding(isActive: isActive, item: item, content: content)
                    .transition(.scale(scale: 0.5).combined(with: .opacity))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.linear(duration: 0.4), value: item?.wrappedValue)
    }
}
