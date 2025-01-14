//
//  CheckoutView.swift
//  CupCake Corner
//
//  Created by Mayank Jangid on 10/17/24.
//

import SwiftUI

struct CheckoutView: View {
    @State private var confirmationMessage = ""
    @State private var confirmationTitle = ""
    @State private var showingConfirmation = false
    
    @Bindable var order: Order
    var body: some View {
        ScrollView {
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                .accessibilityElement()
                Text("Your total is \(order.cost, format: .currency(code: "USD"))")
                           .font(.title)
                Button("Place Order") {
                    Task{
                        await placeOrder()
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Chech Out")
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .alert(confirmationTitle, isPresented: $showingConfirmation) {
            Button("OK"){}
        } message: {
            Text(confirmationMessage)
        }
    }
    
    func placeOrder() async {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode the order")
            return
        }
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        // URLRequest = url + add extra info to url such as what to do like POST or GET
        var request = URLRequest(url: url)
        //idk wtf is this
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        // now we are all set to make network request whcih we'll do by ....
        
        do{
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            confirmationTitle = "Thank you"
            confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types[decodedOrder.type].lowercased()) cupcake is own its way)"
            showingConfirmation = true
        } catch{
            confirmationTitle = "Warning"
            confirmationMessage = "Checkout failed \(error.localizedDescription)."
            showingConfirmation = true
                print("Checkout failed \(error.localizedDescription)")
            
        }
    }
}

#Preview {
    CheckoutView(order: Order())
}
