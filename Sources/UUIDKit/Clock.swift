import Foundation

extension UUID {
    internal final class Clock {
        func next() -> (timestamp: Timestamp, clockSequence: ClockSequence) {
            queue.sync {
                let timestamp = Timestamp()
                if timestamp <= lastTimestamp {
                    clockSequence = (clockSequence &+ 1) & 0x3f
                }
                lastTimestamp = timestamp
                return (timestamp, clockSequence)
            }
        }
        
        static let `default` = Clock()
        
        private let queue = DispatchQueue(label: "UUIDKit:Foundation.UUID.Clock")
        private var clockSequence = ClockSequence.random(in: 0...(.max)) & 0x3f
        private var lastTimestamp = Timestamp.zero
    }
}
