import Foundation

struct GameLink: Identifiable {
    let id = UUID()
    let name: String
    let developer: String
    let url: String
    let icon: String
    let gradient: [String] // Color names for gradient
}

class GameLinksData {
    static let hoyoverseGames: [GameLink] = [
        GameLink(
            name: "Honkai: Star Rail",
            developer: "COGNOSPHERE PTE. LTD.",
            url: "https://apps.apple.com/us/app/honkai-star-rail/id1599719154",
            icon: "star.fill",
            gradient: ["purple", "pink"]
        ),
        GameLink(
            name: "Genshin Impact",
            developer: "COGNOSPHERE PTE. LTD.",
            url: "https://apps.apple.com/us/app/genshin-impact/id1517783697",
            icon: "flame.fill",
            gradient: ["orange", "yellow"]
        ),
        GameLink(
            name: "Zenless Zone Zero",
            developer: "COGNOSPHERE PTE. LTD.",
            url: "https://apps.apple.com/us/app/zenless-zone-zero/id1606356401",
            icon: "bolt.fill",
            gradient: ["blue", "cyan"]
        )
    ]
}
