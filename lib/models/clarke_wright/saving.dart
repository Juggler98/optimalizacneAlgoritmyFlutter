class Saving implements Comparable<Saving> {
  final int from;
  final int to;
  final double saving;

  Saving({
    this.from,
    this.to,
    this.saving,
  });

  @override
  String toString() {
    return 'from: $from to: $to saving: $saving';
  }

  @override
  int compareTo(Saving other) {
    if (saving != other.saving) {
      return saving.compareTo(other.saving);
    }
    return (from + to).compareTo(other.from + other.to);
  }
}
