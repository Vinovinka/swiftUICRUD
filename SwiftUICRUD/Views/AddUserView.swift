import SwiftUI

struct AddUserView: View {

    // create variables to store user input values
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var age: String = ""

    // go back to home screen whan user is added
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
                .textInputAutocapitalization(.none)
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
                // call function to add row in the sqlite db
                DBManager().addUser(nameValue: self.name, emailValue: self.email, ageValue: Int64(self.age) ?? 0)

                // go back home
                self.mode.wrappedValue.dismiss()
            },
                   label: { Text("Add User")}
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
            .padding(.bottom, 10)
        }.padding()
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView()
    }
}
