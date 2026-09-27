// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "AgentLLM",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "AgentLLM", targets: ["AgentLLM"]),
    ],
    targets: [
        .target(name: "AgentLLM"),
        .testTarget(name: "AgentLLMTests", dependencies: ["AgentLLM"]),
    ]
)
