import Foundation

class Playground : NSObject {
  static var bundleVersion: String {
    let s = self.description().replacingOccurrences(of: ".Playground", with: "")
    return s
  }
}

protocol HotDrink
{
    func consume()
}

class Tea: HotDrink
{
    func consume() {
        print("This tea is nice but I'd prefer with milk")
    }
}

class Coffee: HotDrink
{
    func consume() {
        print("This coffee is delicious!")
    }
}


protocol HotDrinkFactory{
    init()
    func prepare(amount: Int) -> HotDrink
}

class TeaFactory: HotDrinkFactory
{
    required init(){

    }
    func prepare(amount: Int) -> HotDrink
    {
        print("Put in tea bag, boil water, pour \(amount)ml, add lemon, enjoy!")
        return Tea()
    }
}

class CoffeeFactory: HotDrinkFactory
{
    required init(){}
    func prepare(amount: Int) -> HotDrink
    {
        print("Grind some beans, boil water, pour \(amount)ml, add cream and sugar")
        return Coffee()
    }
}

class HotDrinkMachine
{
    enum AvaiableDrink : String
    {
        case coffee = "Coffee"
        case tea = "Tea"

        static let all = [coffee, tea]
    }

    internal var factories = [AvaiableDrink: HotDrinkFactory]()

    internal var namedFactories = [(String, HotDrinkFactory)]()

    init()
    {
        for drink in AvaiableDrink.all
        {
            let version = Playground.bundleVersion
            print(version)
            if let type = NSClassFromString("\(version).\(drink.rawValue)Factory") as? HotDrinkFactory.Type{
                let factory = type.init()
                factories[drink] = factory
                namedFactories.append((drink.rawValue, factory))
            } else{
                print("Class not found")
            }
        }
    }

    func makeDrink() -> HotDrink
    {
        print("Available drinks:")
        for i in 0..<namedFactories.count
        {
            let tuple = namedFactories[i]
            print("\(i) : \(tuple.0)")
        }
        let input = Int(readLine() ?? "1") ?? 1
        return namedFactories[input].1.prepare(amount: 250)
    }
}

func main()
{
    let machine = HotDrinkMachine()
    print(machine.namedFactories.count)
    let drink = machine.makeDrink()
    drink.consume()
}

main()
