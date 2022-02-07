import Foundation

extension UUIDv1 {
    internal final class Clock {
        func next() -> (timestamp: Timestamp, clockSequence: ClockSequence) {
            queue.sync {
                let timestamp = Timestamp()
                if timestamp <= lastTimestamp {
                    clockSequence = clockSequence.next
                }
                lastTimestamp = timestamp
                return (timestamp, clockSequence)
            }
        }
        
        static let `default`: Clock = .init()
        
        private let queue: DispatchQueue = .init(label: "UUIDKit.UUIDv1.Clock")
        private var clockSequence: ClockSequence = .random()
        private var lastTimestamp: Timestamp = .zero
    }
}
