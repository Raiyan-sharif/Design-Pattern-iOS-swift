import Foundation

class GraphicObject: CustomStringConvertible {
    var name: String = "Group"
    var color: String = ""

    var children = [GraphicObject]()

    init() {}
    init(name: String) {
        self.name = name
    }

    private func print(_ buffer: inout String, _ depth: Int) {
        buffer.append(String(repeating: "*", count: depth))
        buffer.append(color.isEmpty ? "": "\(color)")
        buffer.append("\(name)\n")

        for child in children {
            child.print(&buffer, depth+1)
        }
    }

    var description: String {
        var buffer = ""
        print(&buffer, 0)
        return buffer
    }

}

class Square: GraphicObject {

    init(_ color: String) {

        super.init(name: "Square")
        self.color = color
    }
}

class Circle: GraphicObject {

    init(_ color: String) {

        super.init(name: "Circle")
        self.color = color
    }
}


func main() {
    let drwawing = GraphicObject(name: "My Drawing")
    drwawing.children.append(Square("Red"))
    drwawing.children.append((Circle("Yellow")))

    let group = GraphicObject()
    group.children.append(Circle("Blue"))
    group.children.append(Square("Blue"))

    drwawing.children.append(group)

    print(drwawing)
}

main()
