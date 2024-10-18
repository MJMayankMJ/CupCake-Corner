//
//  AddressView.swift
//  CupCake Corner
//
//  Created by Mayank Jangid on 10/16/24.
//

import SwiftUI

struct AddressView: View {
    @Bindable var order: Order
    // cz we recieving the order from somewhere else (ie ContentView), so we dont creat @State (instance of order) here
    // thus, SwiftUi doesnt have the same 2 way binding it normally does
    // as observable watches the class (Order()), we use @Bindable here, which just creates a 2 way binding which works with @Observable class without @State (to create local data)
    var body: some View {
        Form {
            Section{
                TextField("Name", text: $order.name)
                TextField("Address", text: $order.streetAddress)
                TextField("City", text: $order.city)
                TextField("Zip", text: $order.zip)
            }
            Section{
                NavigationLink("Check Out"){
                    CheckoutView(order: order)
                }
            }
            .disabled(order.hasValidAddress == false)
        }
    }
}

#Preview {
    AddressView(order: Order())
}
