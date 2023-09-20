import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clean_architecture/data/network/client/api_client.dart';
import 'package:flutter_clean_architecture/data/network/network_mapper.dart';
import 'package:flutter_clean_architecture/data/repository/movies_repository.dart';
import 'package:flutter_clean_architecture/presentation/app/app.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'domain/models/config.dart';

class InitialData {
  final List<SingleChildWidget> providers;
  InitialData({required this.providers});
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final data = await _createData();
  runApp(App(data: data));
}

Future<InitialData> _createData() async {
  // Util
  final log = Logger(
      printer: PrettyPrinter(), level: kDebugMode ? Level.trace : Level.off);

  // Keterangan deprecated di Logger Flutter
  // Level.verbose, Level.wtf and Level.nothing have been deprecated and are replaced by Level.trace, Level.fatal and Level.off. Additionally Level.all has been added.

  // Load project configuration
  final config = await _loadConfig(log);

  // Data
  final apiClient = ApiClient(
      baseUrl: 'https://moviesdatabase.p.rapidapi.com/',
      apiKey: config.apiKey,
      apiHost: config.apiHost);

  final networkMapper = NetworkMapper(log: log);
  final movieRepo =
      MoviesRepository(apiClient: apiClient, networkMapper: networkMapper);

  // Create and return List of Providers
  return InitialData(providers: [
    Provider<Logger>.value(value: log),
    Provider<MoviesRepository>.value(value: movieRepo)
  ]);
}

Future<Config> _loadConfig(Logger log) async {
  String raw;

  try {
    raw = await rootBundle.loadString("assets/config/config.json");
    final config = json.decode(raw) as Map<String, dynamic>;

    return Config(
        apiKey: config['apiKey'] as String,
        apiHost: config['apiHost'] as String);
  } catch (e) {
    log.e(
        'Error while loading project configuration, please make sure that the file located at /assets/config/config.json exists and that it contains the correct configuration.',
        error: e);
    rethrow;
  }
}
