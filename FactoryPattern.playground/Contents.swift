import Foundation

class Point: CustomStringConvertible
{
    private var x, y: Double

    init(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }

    init(rho: Double, theta: Double)
    {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }

    var description: String
    {
        return "x = \(x), y = \(y)"
    }

    static let factory = PointFactory.instance

    class PointFactory
    {
        private init() {}
        static let instance = PointFactory()
        func createCartesian(x: Double, y: Double) -> Point
        {
            return Point(x: x, y: y)
        }

        func createPolar(rho: Double, theta: Double) -> Point
        {
            return Point(rho: rho, theta: theta)
        }
    }

}



func main()
{
//    let p = Point.createPolar(rho: 1, theta: 2)
//    print(p)
    let f = Point.factory.createCartesian(x: 1, y: 2)
}

main()
