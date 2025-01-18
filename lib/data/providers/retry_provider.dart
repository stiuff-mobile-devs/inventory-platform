class RetryProvider {
  Future<void> retryWithExponentialBackoff(
      Future<void> Function() action) async {
    const int maxRetries = 5;
    int retryCount = 0;
    int delay = 1000;

    while (retryCount < maxRetries) {
      try {
        await action();
        return;
      } catch (e) {
        retryCount++;
        if (retryCount >= maxRetries) rethrow;
        await Future.delayed(Duration(milliseconds: delay));
        delay *= 2;
      }
    }
  }
}
