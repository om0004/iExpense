//
//  ContentView.swift
//  iExpense
//
//  Created by om on 14/04/21.
//

import SwiftUI
struct ExpenseItem:Identifiable,Codable
{
    var id=UUID()
    let name:String
    let type:String
    let amount:Int
}
class Expenses:ObservableObject
{
    @Published var items=[ExpenseItem]()
    {
        didSet
        {
            let encoder=JSONEncoder()
            if let data = try? encoder.encode(items)
            {
                UserDefaults.standard.set(data,forKey:"Items")
            }
        }
    }
    init()
    {
        if let JsonData=UserDefaults.standard.data(forKey:"Items")
        {
            let decoder=JSONDecoder()
            if let decoded=try? decoder.decode([ExpenseItem].self,from:JsonData)
            {
                self.items=decoded
                return
            }
        }
        self.items=[]
    }
}
struct ContentView: View
{
    @ObservedObject var expenses=Expenses()
    @State private var showScreen=false
    func removeRows(by offsets:IndexSet)
    {
        expenses.items.remove(atOffsets:offsets)
    }
    var body: some View
    {
       NavigationView
       {
        List
        {
            ForEach(expenses.items)
            {
                item in
                HStack
                {
                    VStack(alignment:.leading)
                    {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    Spacer()
                    Text("$\(item.amount)")
                }
            }
            .onDelete(perform:removeRows)
        }
        .sheet(isPresented:$showScreen)
        {
            AddView(expenses:self.expenses)
        }
        .navigationBarTitle("iExpense")
        .toolbar { EditButton() }
        .navigationBarItems(leading:Button(action:
        {
        showScreen=true
        })
        {
        Image(systemName:"plus")
        })
 
       }
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
