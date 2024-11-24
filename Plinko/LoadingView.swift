import SwiftUI

struct LoadingView: View {
    @State private var loadingProgress: Double = 0.0

    var body: some View {
        ZStack {
            Image("fon")
                .resizable()
                .scaledToFill()
                .padding(.trailing, 30)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: 600)
                
                ZStack {
                    Text("Loading...")
                        .font(.custom("WendyOne-Regular", size: 30))
                        .foregroundColor(.black)
                        .offset(x: 2, y: 2)
                    
                    Text("Loading...")
                        .font(.custom("WendyOne-Regular", size: 28))
                        .foregroundColor(.white)
                }
                
                Spacer()
                    .frame(height: 15)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 60)
                        .frame(width: 300, height: 20)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 56/255, green: 1/255, blue: 57/255),
                                    Color(red: 121/255, green: 1/255, blue: 109/255),
                                    Color(red: 57/255, green: 1/255, blue: 51/255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    RoundedRectangle(cornerRadius: 60)
                        .frame(width: CGFloat(loadingProgress) * 300 , height: 20)
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1/255, green: 11/255, blue: 250/255),
                                    Color(red: 0/255, green: 80/255, blue: 255/255)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .animation(.linear(duration: 3.0), value: loadingProgress)
                }
                .padding(.trailing,10)
                .onAppear {

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation {
                            loadingProgress = 1.0
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoadingView()
}

