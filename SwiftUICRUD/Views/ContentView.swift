import SwiftUI

struct ContentView: View {

    @State var userModels: [UserModel] = []

    @State var userSelected: Bool = false

    @State var selectedUserId: Int64 = 0

    var body: some View {
        NavigationView {
            VStack {

                List( self.userModels) { (model) in
                    HStack {
                        Text(model.name)
                        Spacer()
                        Text(model.email)
                        Spacer()
                        Text("\(model.age)")

                        Button(action: {
                            self.selectedUserId = model.id
                            self.userSelected = true
                        }, label: {
                            Text("Edit")
                                .foregroundColor(Color(.systemBlue))
                        })
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            let dbManager: DBManager = DBManager()

                            dbManager.deleteUser(idValue: model.id)

                            self.userModels = dbManager.getUsers()

                        }, label: {
                            Text("Delete")
                                .foregroundColor(Color(.systemRed))
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                NavigationLink(destination:
                                EditUserView(id: self.$selectedUserId), isActive: self.$userSelected) { EmptyView() }


                NavigationStack {
                }

                HStack {
                    Spacer()
                    NavigationLink(destination: AddUserView(),
                                   label: { Text("Add User")}
                    )
                }
                .padding()

            }
            .padding()
            .onAppear(perform: {
                self.userModels = DBManager().getUsers()
            })
            .navigationTitle("Users")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
