import 'ImportAll.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TranslatorService translatorService = TranslatorService();
  bool isModelDownloaded = await translatorService.isModelDownloaded();
  if (!isModelDownloaded) {
    await translatorService.downloadModelIfNeeded();
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
