import Testing
@testable import AgentLLM

@Suite("LLMRegistry")
@MainActor
struct LLMRegistryTests {

    private func cfg(_ id: String) -> LLMProviderConfig {
        LLMProviderConfig(id: id, displayName: id, kind: .cloudAPI,
                          endpoint: LLMEndpoint(chatURL: "https://example.com/\(id)"))
    }

    @Test("register keeps insertion order and de-dupes by id")
    func registerOrder() {
        let r = LLMRegistry.shared
        r.removeAll()
        r.registerAll([cfg("b"), cfg("a"), cfg("b")])
        #expect(r.allProviders.map(\.id) == ["b", "a"])
    }

    @Test("update on an unknown id makes it visible in allProviders")
    func updateUnknownIsVisible() {
        let r = LLMRegistry.shared
        r.removeAll()
        r.update(cfg("new"))
        #expect(r.provider("new") != nil)
        #expect(r.allProviders.map(\.id) == ["new"])
    }

    @Test("update on a known id replaces without changing order")
    func updateKnownKeepsOrder() {
        let r = LLMRegistry.shared
        r.removeAll()
        r.registerAll([cfg("x"), cfg("y")])
        var changed = cfg("x")
        changed.model = "m2"
        r.update(changed)
        #expect(r.allProviders.map(\.id) == ["x", "y"])
        #expect(r.provider("x")?.model == "m2")
    }

    @Test("remove drops from both map and order")
    func remove() {
        let r = LLMRegistry.shared
        r.removeAll()
        r.registerAll([cfg("x"), cfg("y")])
        r.remove("x")
        #expect(r.provider("x") == nil)
        #expect(r.allProviders.map(\.id) == ["y"])
    }
}
