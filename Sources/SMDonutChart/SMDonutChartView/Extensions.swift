public extension Array {
    /// Method to return the object at index if available. If index is beyond bounds, returns nil.
    func object(at index: Int) -> Element? {
        guard index < self.count, index >= 0 else { return nil }
        return self[index]
    }
}
