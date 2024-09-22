import 'ImportAll.dart';

class TranslatorService {
  late OnDeviceTranslator _translator;
  late final modelManager;

  TranslatorService() {
    _initTranslator();
  }

  void _initTranslator() {
    modelManager = OnDeviceTranslatorModelManager();
    _translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.bengali,
    );
  }

  Future<bool> isModelDownloaded() async {
    return await modelManager
        .isModelDownloaded(TranslateLanguage.bengali.bcpCode);
  }

  Future<void> downloadModelIfNeeded() async {
    bool modelDownloaded = await isModelDownloaded();
    if (!modelDownloaded) {
      try {
        await modelManager.downloadModel(TranslateLanguage.bengali.bcpCode);
        print('Model downloaded successfully.');
      } catch (e) {
        print('Error downloading model: $e');
      }
    } else {
      print('Model already downloaded.');
    }
  }

  Future<String> translateText(String text) async {
    String translatedText = '';
    try {
      translatedText = await _translator.translateText(text);
      print('Translated Text: $translatedText');
    } catch (e) {
      print('Translation error: $e');
    }
    return translatedText;
  }
}
