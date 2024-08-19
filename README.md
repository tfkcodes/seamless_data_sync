
# Seamless Data Sync

[![pub package](https://img.shields.io/pub/v/seamless_data_sync.svg)](https://pub.dev/packages/seamless_data_sync)
[![GitHub issues](https://img.shields.io/github/issues/tfkcodes/seamless_data_sync)](https://github.com/tfkcodes/seamless_data_sync/issues)
[![GitHub stars](https://img.shields.io/github/stars/tfkcodes/seamless_data_sync)](https://github.com/tfkcodes/seamless_data_sync/stargazers)
[![GitHub license](https://img.shields.io/github/license/tfkcodes/seamless_data_sync)](https://github.com/tfkcodes/seamless_data_sync/blob/main/LICENSE)

**Seamless Data Sync** is a Flutter package designed to handle data synchronization between local storage and remote servers in offline-first applications. It provides seamless sync capabilities with conflict resolution, ensuring that users can work offline and have their data automatically synced once they regain connectivity.

## Features

- Two-way data synchronization (local ↔ remote)
- Automatic and manual conflict resolution strategies
- Offline data storage with encryption support
- Network monitoring and background sync
- Real-time sync with WebSocket support (coming soon)
- Developer-friendly API with customizable sync intervals
- Cross-platform support (Android, iOS, Web, Desktop)

## Getting Started

### Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  seamless_data_sync: ^0.1.0


Then run:

```dart
   flutter pub get
```

## Usage

Import the package in your Dart file:

```dart
import 'package:seamless_data_sync/seamless_data_sync.dart';
```



# Usage
1. Initialize the Sync Manager

```dart
import 'package:seamless_data_sync/seamless_data_sync.dart';

void main() async {
  final seamlessManager = SeamlesManager(
    localStorage: LocalDatabase(), // Replace with your local storage implementation
    remoteService: RemoteService(), // Replace with your remote service implementation
    conflictResolutionStrategy: ConflictResolutionStrategy.lastWriteWins,
  );

  await seamlessManager.initialize();

  runApp(MyApp());
}

```

2. Perform Sync Operations

```dart
// Trigger manual sync
await seamlessManager.sync();

// Listen for sync events
seamlessManager.onSyncComplete.listen((SyncResult result) {
  if (result.success) {
    print("Data sync completed successfully!");
  } else {
    print("Data sync failed: ${result.error}");
  }
});

```