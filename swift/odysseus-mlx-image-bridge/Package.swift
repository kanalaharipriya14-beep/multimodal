// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "multivision-mlx-image-bridge",
    platforms: [.macOS(.v26)],
    products: [
        .executable(name: "multivision-mlx-inpaint", targets: ["MultivisionMLXInpaint"]),
        .executable(name: "multivision-mlx-colorize", targets: ["MultivisionMLXColorize"]),
    ],
    dependencies: [
        .package(url: "https://github.com/xocialize/mlx-lama-swift", branch: "main"),
        .package(url: "https://github.com/xocialize/mlx-ddcolor-swift", branch: "main"),
    ],
    targets: [
        .executableTarget(
            name: "MultivisionMLXInpaint",
            dependencies: [
                .product(name: "LaMa", package: "mlx-lama-swift"),
                .product(name: "MIGAN", package: "mlx-lama-swift"),
            ]
        ),
        .executableTarget(
            name: "MultivisionMLXColorize",
            dependencies: [
                .product(name: "DDColor", package: "mlx-ddcolor-swift"),
            ]
        ),
    ]
)
