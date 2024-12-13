import Foundation

protocol Renderer{
    func renderCircle(_ radius: Float)
}

class VectorRenderer: Renderer {
    func renderCircle(_ radius: Float) {
        print("Drawing a circle of radius \(radius)")
    }
}

class RasterRenderer: Renderer {
    func renderCircle(_ radius: Float) {
        print("Drawing pixels for cicle of radius \(radius)")
    }
}

protocol Shape{
    func draw()
    func resize(_ factor: Float)
}

class Circle: Shape {
    var radius: Float
    var renderer: Renderer

    init(_ radius: Float, _ renderer: Renderer) {
        self.radius = radius
        self.renderer = renderer
    }

    func draw() {
        renderer.renderCircle(radius)
    }

    func resize(_ factor: Float) {
        radius *= factor
    }
}

func main() {
    let raster = RasterRenderer()
    let vector = VectorRenderer()
    let circle = Circle(5, vector)
    circle.draw()
    circle.resize(2)
    circle.draw()
}

main()
