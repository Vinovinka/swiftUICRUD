import Foundation
import SQLite

class DBManager {

    // sqlite instance
    private var db: Connection!

    // table instance
    private var users: Table!

    // columns instances of table
    private var id: Expression<Int64>!
    private var name: Expression<String>!
    private var email: Expression<String>!
    private var age: Expression<Int64>!

    // construction of this class
    init() {

        // exeption handling
        do {

            // path of document directory
            let path: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""

            // creating db connection
            db = try Connection("\(path)/my_user.sqlite3")

            // creating table object
            users = Table("users")

            // creating instances of each column
            id = Expression<Int64>("id")
            name = Expression<String>("name")
            email = Expression<String>("email")
            age = Expression<Int64>("age")

            // check if the user's table is already created
            if (!UserDefaults.standard.bool(forKey: "is_db_created")) {

                //if not, then create the table
                try db.run(users.create { (t) in
                    t.column(id, primaryKey: true)
                    t.column(name)
                    t.column(email, unique: true)
                    t.column(age)
                })

                // set the value to true, so it will not attempt to create the table again
                UserDefaults.standard.set(true, forKey: "is_db_created")
            }
        } catch {

            // show error message if any
            print(error.localizedDescription)
        }
    }

    public func addUser(nameValue: String, emailValue: String, ageValue: Int64) {
        do {
            try db.run(users.insert(name <- nameValue, email <- emailValue, age <- ageValue))
        } catch {
            print(error.localizedDescription)
        }
    }

    // return array of user models
    public func getUsers() -> [UserModel] {

        // create empty array
        var userModels: [UserModel] = []

        // get all users in descending order
        users = users.order(id.desc)

        // exception handling
        do {

            // loop through all users
            for user in try db.prepare(users) {

                let userModel: UserModel = UserModel()

                userModel.id = user[id]
                userModel.name = user[name]
                userModel.email = user[email]
                userModel.age = user[age]

                userModels.append(userModel)
            }

        } catch {
            print(error.localizedDescription)
        }

        return userModels
    }

    public func getUser(idValue: Int64) -> UserModel {

        let userModel: UserModel = UserModel()

        do {

            let user: AnySequence<Row> = try db.prepare(users.filter(id == idValue))

            try user.forEach({ (rowValue) in

                userModel.id = try rowValue.get(id)
                userModel.name = try rowValue.get(name)
                userModel.email = try rowValue.get(email)
                userModel.age = try rowValue.get(age)
            })

        } catch {
            print(error.localizedDescription)
        }

        return userModel
    }

    public func updateUser(idValue: Int64, nameValue: String, emailValue: String, ageValue: Int64) {

        do {
            // get user using id
            let user: Table = users.filter(id == idValue)

            // run the update query
            try db.run(user.update(name <- nameValue, email <- emailValue, age <- ageValue))


        } catch {
            print(error.localizedDescription)
        }
    }

    public func deleteUser(idValue: Int64) {

        do {
            let user: Table = users.filter(id == idValue)

            try db.run(user.delete())

        } catch {
            print(error.localizedDescription)
        }
    }

}
