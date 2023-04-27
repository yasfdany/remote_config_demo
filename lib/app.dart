import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  @override
  void initState() {
    super.initState();
    initRemoteConfig();
  }

  @override
  Widget build(BuildContext context) {
    final isAlredyEid = remoteConfig.getBool('isAlreadyEid');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Config Demo'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: isAlredyEid ? Colors.green : Colors.blue,
          ),
          child: Text(
            isAlredyEid ? 'Happy Eid Mubarrak' : 'Happy Fasting',
          ),
        ),
      ),
    );
  }

  void initRemoteConfig() async {
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      setState(() {});
    });

    await remoteConfig.ensureInitialized();
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        // minimumFetchInterval dibuat 0 untuk keperluan demo
        // untuk production usahakan minimal 1 jam minimumFetchInterval untuk mencegah Throttling Exception
        // Throttling Exception terjadi jika melakukan lebih dari 5 fetch request dalam 1 jam
        minimumFetchInterval: Duration.zero,
      ),
    );
    await remoteConfig.fetchAndActivate();
  }
}
