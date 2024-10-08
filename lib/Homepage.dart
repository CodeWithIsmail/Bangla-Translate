import 'ImportAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  String extractedText = "";
  List<WordPair> wordPairs = [];

  TranslatorService translator = TranslatorService();

  void initState() {
    super.initState();
    // translator.downloadModelIfNeeded();
    getLostData();
  }

  Future<void> getLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      File? croppedFile = await _cropImage(File(response.file!.path));
      if (croppedFile != null) {
        setState(() {
          selectedMedia = croppedFile;
        });
        final text = await _extractText(croppedFile);
        setState(() {
          extractedText = text ?? "";
        });
      }
    } else {
      Fluttertoast.showToast(
        msg: response.exception?.message ?? "Unknown error occurred.",
        backgroundColor: Colors.redAccent,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPicker(context);
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a Picture'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            selectedMedia = croppedFile;
          });
          final text = await _extractText(croppedFile);
          setState(() {
            extractedText = text ?? "";
          });
        }
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Image load failed. Try again or try image from gallery.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightBlueAccent,
          textColor: Colors.black,
          fontSize: 16.0);
      // TODO
    }
  }

  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPresetCustom(),
            ],
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      }
      return null;
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Image load failed. Try again or try image from gallery.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightBlueAccent,
          textColor: Colors.black,
          fontSize: 16.0);
      // TODO
    }
  }

  Widget _buildUI() {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF757F9A),
            Color(0xFFD7DDE8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'BanglaLens',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Playwrite',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 30),
                Text(
                  'Captured Image',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Playwrite',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _imageView(),
                SizedBox(height: 30),
                Text(
                  'Extracted Text',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Playwrite',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _extractTextView(),
                SizedBox(height: 30),
                Text(
                  'Word Meaning',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Playwrite',
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                _buildWordPairList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("Pick an image for text recognition."),
      );
    }
    return Center(
      child: Image.file(
        selectedMedia!,
        width: (MediaQuery.sizeOf(context).width * 2) / 3,
      ),
    );
  }

  Widget _extractTextView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text(""),
      );
    }
    return Column(
      children: [
        FutureBuilder<String?>(
          future: _extractText(selectedMedia!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return Text(
              snapshot.data ?? extractedText,
              style: const TextStyle(fontSize: 20),
            );
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: extractedText));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Text copied to clipboard!')),
            );
          },
          child: const Text('Copy extracted text'),
        ),
      ],
    );
  }

  Widget _buildWordPairList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: wordPairs.length,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  wordPairs[index].english,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                Text(
                  wordPairs[index].bengali,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 6,
      ),
    );
  }

  Future<String?> _extractText(File file) async {
    try {
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final InputImage inputImage = InputImage.fromFile(file);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      String text = recognizedText.text;
      print(text);

      List<String> words = text.split(RegExp(r'[^\w]+'));
      Map<String, String> uniqueWordPairs = {};

      for (String word in words) {
        if (word.isNotEmpty && !RegExp(r'^\d+$').hasMatch(word)) {
          String lowerCaseWord = word.toLowerCase();
          String bengaliMeaning = await translator.translateText(lowerCaseWord);
          uniqueWordPairs[lowerCaseWord] = bengaliMeaning;
        }
      }

      wordPairs = uniqueWordPairs.entries
          .map((entry) => WordPair(entry.key, entry.value))
          .toList()
        ..sort((a, b) => a.english.compareTo(b.english));
      print(wordPairs);

      textRecognizer.close();
      return text;
    } on Exception catch (e) {
      Fluttertoast.showToast(
          msg: "Text extraction failed. Try again or try image from gallery.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.lightBlueAccent,
          textColor: Colors.black,
          fontSize: 16.0);
      // TODO
    }
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
