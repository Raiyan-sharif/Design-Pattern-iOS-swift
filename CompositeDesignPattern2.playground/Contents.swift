import Foundation

class Neuron: Sequence {
    var inputs = [Neuron]()
    var outputs = [Neuron]()

    func connect(_ to: Neuron) {

        outputs.append(to)
        to.inputs.append(self)
    }

    func makeIterator() -> IndexingIterator<Array<Neuron>> {
        return IndexingIterator(_elements: [self])
    }
}


class NeuronLayer: Sequence {
    private var neurons: [Neuron]

    init(_ count: Int) {
        self.neurons = [Neuron](repeating: Neuron(), count: count)
    }

    func makeIterator() -> IndexingIterator<Array<Neuron>> {

        return IndexingIterator(_elements: neurons)
    }
}

extension Sequence {
    func connect<Seq: Sequence>(to other: Seq) 
    where Seq.Iterator.Element == Neuron, Self.Iterator.Element == Neuron {

        for from in self {
            for to in other {
                from.outputs.append(to)
                to.inputs.append(from)
            }
        }

    }
}

func main() {
    var neuron1 = Neuron()
    var neuron2 = Neuron()
    var layer1 = NeuronLayer(10)
    var layer2 = NeuronLayer(20)

    neuron1.connect(to: neuron2)
    neuron1.connect(to: layer1)
    layer1.connect(to: neuron1)
    layer1.connect(to: layer2)

}
