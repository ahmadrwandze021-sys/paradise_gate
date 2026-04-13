import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Paradise Gate",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffF5F5F5),
        primaryColor: Colors.deepPurple,
      ),
      home: const SurahList(),
    );
  }
}

// ================= SURAH LIST =================

class SurahList extends StatelessWidget {
  const SurahList({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> surahs =
        List.generate(114, (i) => "Surah ${i + 1}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              leading: CircleAvatar(
                child: Text("${index + 1}"),
              ),
              title: Text(surahs[index]),
              subtitle: const Text("Tap to play"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerPage(index + 1),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ================= AUDIO SERVICE (FIXED) =================

class QuranAudioPlayer {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSurah(int number) async {
    await _player.stop();

    await _player.play(
      AssetSource('audio/$number.mp3'),
    );
  }

  static Future<void> stop() async {
    await _player.stop();
  }
}

// ================= PLAYER PAGE =================

class PlayerPage extends StatefulWidget {
  final int surahNumber;
  const PlayerPage(this.surahNumber, {super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  String selectedReciter = "Alafasy";

  final List<String> reciters = [
    "Alafasy",
    "Sudais",
    "Shuraim",
    "Ghamdi",
    "Husary"
  ];

  void playAudio() {
    QuranAudioPlayer.playSurah(widget.surahNumber);
  }

  void chooseReciter() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return ListView(
          children: reciters.map((r) {
            return ListTile(
              title: Text(r),
              trailing: selectedReciter == r
                  ? const Icon(Icons.check)
                  : const Icon(Icons.circle_outlined),
              onTap: () {
                setState(() {
                  selectedReciter = r;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surah ${widget.surahNumber}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: chooseReciter,
          )
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Reciter: $selectedReciter",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: playAudio,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Play Surah"),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: QuranAudioPlayer.stop,
                  icon: const Icon(Icons.stop),
                  label: const Text("Stop"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
