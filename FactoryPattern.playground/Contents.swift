import Foundation

class Point: CustomStringConvertible
{
    var x: Double
    var y: Double

    private init(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }

    private init(rho: Double, theta: Double)
    {
        x = rho * cos(theta)
        y = rho * sin(theta)
    }

    var description: String
    {
        return "x = \(x), y = \(y)"
    }

}

class PointFactory
{
    static func createCartesian(x: Double, y: Double) -> Point
    {
        return Point(x: x, y: y)
    }

    static func createPolar(rho: Double, theta: Double) -> Point
    {
        return Point(rho: rho, theta: theta)
    }
}

func main()
{
    let p = Point.createPolar(rho: 1, theta: 2)
    print(p)
}

main()
