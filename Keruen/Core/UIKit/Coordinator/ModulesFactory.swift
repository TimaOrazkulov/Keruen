import Swinject

public final class ModulesFactory {
    public let assembler: Assembler

    public init(assembler: Assembler) {
        self.assembler = assembler
    }
}
