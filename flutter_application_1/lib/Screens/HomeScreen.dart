import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define colors for consistent theming
  final Color primaryColor = Color.fromRGBO(56, 68, 80, 1);
  final Color secondaryColor = Color.fromRGBO(38, 52, 62, 1);
  final Color accentColor = Colors.blueAccent;

  // PageController for managing PageView
  final PageController _pageController = PageController();

  // Search functionality variables
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _searchQuery = "";
  final TextEditingController searchController = TextEditingController();
  dynamic data = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeechToText();
  }

  void _initializeSpeechToText() {
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (val) {
        setState(() {
          _searchQuery = val.recognizedWords;
          searchController.text = _searchQuery;
        });
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  // process file
  Future<void> processFile() async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      final url = Uri.parse("http://192.168.7.66:8000/search");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user_id": 123, "query": searchController.text}),
      );

      if (response.statusCode == 200) {
        setState(() {
          data = jsonDecode(response.body);
        });
      } else {
        setState(() {
          data = {"error": "API Error: ${response.statusCode}"};
        });
      }
    } catch (e) {
      setState(() {
        data = {"error": "Failed to connect to server"};
      });
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  // Widget for the header section
  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Eduhaven',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Your Learning Companion',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: accentColor,
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the search bar
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white70),
                icon: Icon(Icons.search, color: Colors.white70),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                _isListening ? Icons.mic_off : Icons.mic,
                color: Colors.white,
                size: 24,
              ),
              onPressed: _isListening ? _stopListening : _startListening,
            ),
          ),
        ],
      ),
    );
  }

  // Widget for the feature boxes
  Widget _buildFeatureBoxes() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildFeatureBox(Icons.video_library, 'Videos', 0),
          _buildFeatureBox(Icons.article, 'Articles', 1),
          _buildFeatureBox(Icons.assignment, 'Tasks', 2),
          _buildFeatureBox(Icons.quiz, 'Quizzes', 3),
        ],
      ),
    );
  }

  // Helper method to create individual feature boxes
  Widget _buildFeatureBox(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: Container(
        width: 105,
        height: 35,
        decoration: BoxDecoration(
          color: Color.fromRGBO(87, 106, 130, 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 87106130100
            // Icon(icon, color: Colors.white, size: 30),
            // SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for the PageView
  Widget _buildPageView() {
    return Expanded(
      child: PageView(
        controller: _pageController,
        children: [
          _buildVideosTab(),
          _buildArticlesTab(),
          _buildTasksTab(),
          _buildQuizzesTab(),
        ],
      ),
    );
  }

  // Widget for Videos Tab
  Widget _buildVideosTab() {
    if (data.containsKey("youtube_videos") &&
        data["youtube_videos"].isNotEmpty) {
      return Container(
        color: Color.fromRGBO(169, 187, 200, 1),
        child: ListView.builder(
          itemCount: data["youtube_videos"].length,
          itemBuilder: (context, index) {
            var video = data["youtube_videos"][index];
            String title = video["title"]?.toString() ?? "No Title";
            String url = video["url"]?.toString() ?? "No URL";
            return ListTile(
              title: Text(title),
              subtitle: Text(url),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentScreen(title: title, url: url),
                ),
              ),
            );
          },
        ),
      );
    }
    return Center(
        child: Container(
            height: 1000,
            width: MediaQuery.of(context).size.width,
            color: Color.fromRGBO(169, 187, 200, 1),
            child: Text("No videos found")));
  }

  // Widget for Articles Tab
  Widget _buildArticlesTab() {
    if (data.containsKey("articles") && data["articles"].isNotEmpty) {
      return ListView.builder(
        itemCount: data["articles"].length,
        itemBuilder: (context, index) {
          var article = data["articles"][index];
          String title = article["title"]?.toString() ?? "No Title";
          String content = article["content"]?.toString() ?? "No Content";

          return ListTile(
            title: Text(title),
            subtitle: Text(content),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ContentScreen(title: title, content: content),
              ),
            ),
          );
        },
      );
    }
    return Center(child: Text("No articles found"));
  }

  // Widget for Tasks Tab
  Widget _buildTasksTab() {
    if (data.containsKey("tasks") && data["tasks"].isNotEmpty) {
      return ListView.builder(
        itemCount: data["tasks"].length,
        itemBuilder: (context, index) {
          var task = data["tasks"][index];
          String title = task["title"]?.toString() ?? "No Title";
          String description =
              task["description"]?.toString() ?? "No Description";

          return ListTile(
            title: Text(title),
            subtitle: Text(description),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ContentScreen(title: title, content: description),
              ),
            ),
          );
        },
      );
    }
    return Center(child: Text("No tasks found"));
  }

  // Widget for Quizzes Tab
  Widget _buildQuizzesTab() {
    if (data.containsKey("quizzes") && data["quizzes"].isNotEmpty) {
      return ListView.builder(
        itemCount: data["quizzes"].length,
        itemBuilder: (context, index) {
          var quiz = data["quizzes"][index];
          String title = quiz["title"]?.toString() ?? "No Title";
          String description =
              quiz["description"]?.toString() ?? "No Description";

          return ListTile(
            title: Text(title),
            subtitle: Text(description),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ContentScreen(title: title, content: description),
              ),
            ),
          );
        },
      );
    }
    return Center(child: Text("No quizzes found"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeader(),
                _buildSearchBar(),
                _buildFeatureBoxes(),
              ],
            ),
          ),
          _buildPageView(),
        ],
      ),
    );
  }
}

class ContentScreen extends StatelessWidget {
  final String title;
  final String? url;
  final String? content;

  const ContentScreen({super.key, required this.title, this.url, this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: url != null
            ? ElevatedButton(
                onPressed: () => _launchURL(url!),
                child: Text("Open Link"),
              )
            : Text(content ?? "No Content Available"),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
