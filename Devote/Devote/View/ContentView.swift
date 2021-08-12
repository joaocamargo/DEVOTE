//
//  ContentView.swift
//  Devote
//
//  Created by joao camargo on 11/08/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    //MARK: - properties
    
    @State var task: String = ""
    
    private var isButtonDisabled: Bool {
        task.isEmpty
    }
    
    // fething data
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //MARK: - function
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack(spacing: 16){
                        TextField("New Task", text: $task)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        
                        
                        Button(action: { addItem() }
                               , label: {
                                Spacer()
                                Text("save".uppercased())
                                Spacer()
                               })
                            .disabled(isButtonDisabled)
                            .padding()
                            .font(.headline)
                            .foregroundColor(.white)
                            .background(isButtonDisabled ? Color.gray : Color.pink)
                            .cornerRadius(10)
                    } // : VSTACK
                    .padding()
                    
                    
                    
                    List {
                        ForEach(items) { item in
                            VStack(alignment: .leading) {
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } // VSTACK
                        } // foreach
                        .onDelete(perform: deleteItems)
                    } // LIST
                    .listStyle(InsetGroupedListStyle())
                    .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.3), radius: 12, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                    .padding(.vertical, 0)
                    .frame(maxWidth: 640)
                } // : VSTACK
            } // zstack
            .onAppear(){
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                #endif
                
            }// : toolbar
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
        }// : navigation
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()
            
            do {
                try viewContext.save()
                task = ""
                hideKeyboard()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}


//MARK: -  preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
