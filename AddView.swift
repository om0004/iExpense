//
//  AddView.swift
//  iExpense
//
//  Created by om on 15/04/21.
//

import SwiftUI

struct AddView: View
{
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses:Expenses
    @State private var name=""
    @State private var type="Personal"
    @State private var amount=""
    static let types=["Personal","Business"]
    @State private var showAlert=false
    var body: some View
    {
        NavigationView
        {
            Form
            {
                TextField("Name:",text:$name)
                Picker("Type",selection:$type)
                {
                    ForEach(AddView.types,id:\.self)
                    {
                        Text("\($0)")
                    }
                    
                }
                TextField("Amount:",text:$amount)
                    .keyboardType(.numberPad)
            }
            .alert(isPresented:$showAlert)
            {
                Alert(title:Text("Error"), message:Text("Please insert Integers"), dismissButton:.default(Text("ok")))
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:Button(action:
            {
                let newAmount=Int(amount) ?? -1
                if newAmount == -1
                {
                    showAlert=true
                }
                else
                {
                let item=ExpenseItem(name:self.name, type:self.type, amount:newAmount)
                expenses.items.append(item)
                presentationMode.wrappedValue.dismiss()
                }
            })
            {
                Text("Save")
            })
        }
    }
}
struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses:Expenses())
    }
}
