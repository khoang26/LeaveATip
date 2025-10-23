import SwiftUI

struct ShakeEffect: GeometryEffect {
    var travelDistance: CGFloat = 10
    var numberOfShakes: CGFloat = 3
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(
                translationX: travelDistance * sin(animatableData * .pi * numberOfShakes),
                y: 0
            )
        )
    }
}

struct ContentView: View {
    @State private var showThankYou = false
    @State private var showCustomInput = false
    @State private var customTip = ""
    @State private var errorMessage: String? = nil
    @State private var shakeTrigger: CGFloat = 0

    var body: some View {
        VStack {
            Spacer(minLength: 60)
            
            Text("Leave a tip?")
                .font(.system(size: 50, weight: .bold))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 20) {
                TipButton(title: "15%", width: 365, height: 200) {
                    showThankYou = true
                }
                TipButton(title: "20%", width: 365, height: 200) {
                    showThankYou = true
                }
                TipButton(title: "25%", width: 365, height: 200) {
                    showThankYou = true
                }
            }
            .padding(.top, 12)
            
            TipButton(title: "Custom", fullWidth: true, height: 100) {
                showCustomInput = true
            }
            .padding(.top, 28)
            
            Spacer()
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .alert("Thank you!", isPresented: $showThankYou) {
            Button("OK", role: .cancel) { }
        }
        .sheet(isPresented: $showCustomInput) {
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        showCustomInput = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                
                Text("Enter custom tip amount (%)")
                    .font(.title2)
                    .padding(.top, 10) 
                TextField("Amount", text: $customTip)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 40)
                    .modifier(ShakeEffect(animatableData: shakeTrigger))
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.top, 8)
                }
                
                Spacer()
                
                Button(action: {
                    if let value = Int(customTip.trimmingCharacters(in: .whitespaces)) {
                        if value < 15 {
                            errorMessage = "❌ Minimum tip is 15%. Please enter a higher tip amount."
                            customTip = ""
                            withAnimation(.default) { shakeTrigger += 1 }
                        } else {
                            errorMessage = nil
                            showCustomInput = false
                            customTip = ""
                            showThankYou = true
                        }
                    } else {
                        errorMessage = "❌ Please enter a valid number."
                        customTip = ""
                        withAnimation(.default) { shakeTrigger += 1 }
                    }
                }) {
                    Text("Submit")
                        .font(.title2)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                }
            }
            .onDisappear {
                errorMessage = nil
            }
        }


        .statusBar(hidden: true)
        .preferredColorScheme(.light)
    }
}

struct TipButton: View {
    var title: String
    var fullWidth: Bool = false
    var width: CGFloat? = nil
    var height: CGFloat = 50
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(
                    width: fullWidth ? nil : width,
                    height: height
                )
                .frame(maxWidth: fullWidth ? .infinity : nil)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ContentView()
}
