import Foundation

public class Vlaggen {
    let server: URL

    private init(server: URL) {
        self.server = server
    }

    static var settings: Vlaggen? = nil

    public static func set(server: URL) {
        settings = Vlaggen(server: server)
    }
}
