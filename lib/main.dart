import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SurahList(),
    );
  }
}

// ================= SURAH LIST =================

class SurahList extends StatelessWidget {
  const SurahList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> surahs =
        List.generate(114, (i) => "Surah ${i + 1}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran Player"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 114,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text("${index + 1}")),
              title: Text(surahs[index]),
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

// ================= PLAYER =================

class PlayerPage extends StatefulWidget {
  final int surahNumber;
  const PlayerPage(this.surahNumber, {super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  final AudioPlayer player = AudioPlayer();

  String? audioUrl;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAudio();
  }

  // 🔥 FETCH FROM GITHUB DB
  Future<void> loadAudio() async {
    try {
      final url =
          "https://raw.githubusercontent.com/w-coding/Quran-Database-Timings/main/data.json";

      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      // ⚠️ adjust depending on your JSON structure
      String link = data["surahs"][widget.surahNumber.toString()];

      setState(() {
        audioUrl = link;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
    }
  }

  void playAudio() async {
    if (audioUrl == null) return;

    await player.stop();
    await player.play(UrlSource(audioUrl!));
  }

  void stopAudio() {
    player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Surah ${widget.surahNumber}"),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    audioUrl == null
                        ? "No Audio Found"
                        : "Ready to Play",
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: playAudio,
                    child: const Text("Play"),
                  ),
                  ElevatedButton(
                    onPressed: stopAudio,
                    child: const Text("Stop"),
                  ),
                ],
              ),
      ),
    );
  }
}
