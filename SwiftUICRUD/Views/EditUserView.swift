import SwiftUI

struct EditUserView: View {

    // id receiving of user from previous view
    @Binding var id: Int64

    @State var name: String = ""
    @State var email: String = ""
    @State var age: String = ""

    // to go back
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack {
            TextField("Enter name", text: $name)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .autocorrectionDisabled(true)

            TextField("Enter email", text: $email)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled(true)

            TextField("Enter age", text: $age)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(5)
                .textInputAutocapitalization(.none)
                .keyboardType(.numberPad)
                .autocorrectionDisabled(true)

            Button(action: {
                // call function to update row in the sqlite db
                DBManager().updateUser(idValue: self.id,
                                       nameValue: self.name,
                                       emailValue: self.email,
                                       ageValue: Int64(self.age) ?? 0
                )

                // go back home
                self.mode.wrappedValue.dismiss()
            },
                   label: { Text("Edit User")}
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }
        .padding()
        .onAppear(perform: {
            let userModel: UserModel = DBManager().getUser(idValue: self.id)

            self.name = userModel.name
            self.email = userModel.email
            self.age = String(userModel.age)
        })
    }
}

struct EditUserView_Previews: PreviewProvider {

    @State static var id: Int64 = 0

    static var previews: some View {
        EditUserView(id: $id)
    }
}
