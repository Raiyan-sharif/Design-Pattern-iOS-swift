import Foundation

class HtmElement: CustomStringConvertible
{
    var name = ""
    var text = ""
    var elements = [HtmElement]()
    private let indentSize = 2


    init(){

    }
    init(name: String = "", text: String = "") {
        self.name = name
        self.text = text
    }

    private func description(_ indent: Int) -> String
    {
        var result = ""
        let i = String(repeating: " ", count: indent)
        result += "\(i)<\(name)>\n"
        if !text.isEmpty
        {
            result += String(repeating: " ", count: indent + 1)
            result += text
            result += "\n"
        }

        for e in elements
        {
            result += e.description(indent + 1)
        }
        result += "\(i)</\(name)>\n"
        return result
    }

    public var description: String{
        return description(0)
    }
}

class HtmlBuilder: CustomStringConvertible
{
    private let rootName: String
    var root = HtmElement()

    init(rootName: String) {
        self.rootName = rootName
        root.name = rootName
    }

    func addChild(name: String, text: String){
        let e = HtmElement(name: name, text: text)
        root.elements.append(e)
    }

    func addChildFluent(name: String, text: String) -> HtmlBuilder{
        let e = HtmElement(name: name, text: text)
        root.elements.append(e)
        return self
    }

    var description: String
    {
        return root.description
    }

    func clear()
    {
        root = HtmElement(name: rootName, text: "")
    }

}

class Person : CustomStringConvertible
{
    // Adresss
    var streetAddress = "", postcode = "", city = ""

    //employment
    var companyName = "", position = ""
    var annualIncome = 0

    var description: String
    {
        return "I live at \(streetAddress), \(postcode), \(city). " +
        "I Work at \(companyName) as a \(position), earning \(annualIncome)."
    }
}

class PersonBuilder
{
    var person = Person()
    var lives: PersonAddressBuilder
    {
        return PersonAddressBuilder(person)
    }

    var works: PersonJobBuilder
    {
        return PersonJobBuilder(person)
    }

    func build() -> Person
    {
        return person
    }
}

class PersonJobBuilder: PersonBuilder{
    internal init(_ person: Person) {
        super.init()
        self.person = person
    }

    func at(_ companyName: String) -> PersonJobBuilder
    {
        person.companyName = companyName
        return self
    }

    func asA(_ position: String) -> PersonJobBuilder
    {
        person.position = position
        return self
    }

    func earning(_ annualIncome: Int) -> PersonJobBuilder
    {
        person.annualIncome = annualIncome
        return self
    }
}

class PersonAddressBuilder: PersonBuilder{
    internal init(_ person: Person) {
        super.init()
        self.person = person
    }
    func at(_ streetAddresss: String) -> PersonAddressBuilder
    {
        person.streetAddress = streetAddresss
        return self
    }

    func withPostcode(_ postcode: String) -> PersonAddressBuilder
    {
        person.postcode = postcode
        return self
    }

    func inCity(_ city: String) -> PersonAddressBuilder
    {
        person.city = city
        return self
    }
}

func main()
{
//    let hello = "hello"
//    var result = "<p>\(hello)</p>"
//    print(result)
//
//    let words = ["hello", "world"]
//    result = "<ul>\n"
//    for word in words
//    {
//        result.append("<li>\(word)</li>\n")
//    }
//    result.append("</ul>")
//    print(result)

    //Builder
    let builder = HtmlBuilder(rootName: "ul")
    builder.addChild(name: "li", text: "hello")
    builder.addChild(name: "li", text: "world")
    print(builder)

    //FluentBuilder
    let fluentBuilder = HtmlBuilder(rootName: "ul")
    fluentBuilder.addChildFluent(name: "li", text: "hello")
                .addChildFluent(name: "li", text: "world")
    print(fluentBuilder)

    //Faceted Builder
    let pb = PersonBuilder()
    let p = pb.lives.at("123 london Road")
        .inCity("London")
        .withPostcode("swere")
        .works.at("Fabricam")
        .asA("Engineer")
        .earning(3423434)
        .build()
    print(p)


}

main()
