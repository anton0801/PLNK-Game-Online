import SwiftUI

struct MenuView: View {
    var body: some View {
        ZStack {
            Image("menuFon")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                Image("menuGirl")
                    .padding(.bottom, 200)
                
                Button(action: {
                    // Отправляем уведомление, когда кнопка "Play" нажата
                    NotificationCenter.default.post(name: .playButtonTapped, object: nil)
                }) {
                    Image("play")
                }
                .padding(.top, 300)
                
                Button(action: {
                    print("Shop button tapped")
                }) {
                    Image("shop")
                        .padding(.top, 585)
                }
            }
        }
    }
}

// Расширение для определения уникального идентификатора уведомления
extension Notification.Name {
    static let playButtonTapped = Notification.Name("playButtonTapped")
}

