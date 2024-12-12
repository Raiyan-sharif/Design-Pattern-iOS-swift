import Foundation

protocol Copying
{
    init(copyFrom other: Self)
}

class Address: CustomStringConvertible, Copying
{
    var streetAddress: String
    var city: String

    init(_ streetAddress: String, _ city: String) {
        self.streetAddress = streetAddress
        self.city = city
    }

    required init(copyFrom other: Address) {
        streetAddress = other.streetAddress
        city = other.city
    }

    var description: String
    {
        return "\(streetAddress), \(city)"
    }
}

class Employee: CustomStringConvertible
{
    var name: String
    var address: Address

    init(_ name: String, _ address: Address) {
        self.name = name
        self.address = address
    }

    init(copyFrom other: Employee){
        name = other.name
//        address = Address(other.address.streetAddress, other.address.city)
        address = Address(copyFrom: other.address)
    }

    var description: String{
        return "My name is \(name) and I live ar \(address)"
    }
}

func main(){
    var raiyan = Employee("Raiyan", Address("Mirpur", "Dhaka"))


    var sharif = Employee(copyFrom: raiyan)
    sharif.name = "Sharif"
    sharif.address.streetAddress = "Gulshan"
    print(raiyan)
    print(sharif)
}

main()
