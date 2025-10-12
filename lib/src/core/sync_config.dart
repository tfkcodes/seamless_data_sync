class SyncConfig {
  /// how many times to retry failed push operations
  final int maxRetries;

  /// delay between retries in seconds (simple constant delay)
  final int retryDelaySeconds;

  SyncConfig({
    this.maxRetries = 3,
    this.retryDelaySeconds = 5,
  });
}
