import 'audio_player.dart';
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
                borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              leading: CircleAvatar(
                child: Text("${index + 1}"),
              ),
              title: Text(surahs[index]),
              subtitle: const Text("Tap to open"),
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

// ================= PLAYER PAGE =================

class PlayerPage extends StatefulWidget {
  final int surahNumber;
  const PlayerPage(this.surahNumber, {super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final player = AudioPlayer();
  String selectedReciter = "Alafasy";

  final List<String> reciters = [
    "Alafasy",
    "Sudais",
    "Shuraim",
    "Ghamdi",
    "Husary"
  ];

  void playAudio() async {
    await player.stop();
    await player.play(
      AssetSource(
          'audio/${widget.surahNumber}.mp3'), // same audio for now
    );
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
                  ? const Icon(Icons.radio_button_checked)
                  : const Icon(Icons.radio_button_off),
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
            icon: const Icon(Icons.graphic_eq),
            onPressed: chooseReciter,
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // Audio Control Card
          Card(
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Reciter: $selectedReciter",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: playAudio,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Play"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
