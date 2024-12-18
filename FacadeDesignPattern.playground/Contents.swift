import Foundation

class Buffer {

    var width, height: Int
    var buffer: [Character]

    init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.buffer = [Character](repeating: " ", count: width*height)
    }

    subscript(_ index: Int) -> Character {
        return buffer[index]
    }
}

class Viewport {

    var buffer: Buffer
    var offset = 0
    init(buffer: Buffer) {

        self.buffer = buffer
    }

    func getCharacterAt(_ index: Int) -> Character {

        return buffer[offset+index]
    }
}

class Console {

    var buffer = [Buffer]()
    var viewports = [Viewport]()
    var offset = 0

    init() {
        let b = Buffer(width: 30,height: 20)
        let v = Viewport(buffer: b)
        buffer.append(b)
        viewports.append(v)
    }

    func getCharacterAt(_ index: Int) -> Character {

        return viewports[0].getCharacterAt(index)
    }


}

func main(){

    let c = Console()
    let u = c.getCharacterAt(1)
    
}

main()
