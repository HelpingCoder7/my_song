import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysong/playlistProider.dart';
import 'package:mysong/songs_model.dart';
import 'package:provider/provider.dart';

class newHomePage extends StatefulWidget {
  const newHomePage({super.key});

  @override
  State<newHomePage> createState() => _newHomePageState();
}

class _newHomePageState extends State<newHomePage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final provider = Provider.of<PlatListProvider>(context, listen: false);
    final newIndex = _pageController.page!.round();
    if (provider.currentIndex != newIndex) {
      provider.currentIndex = newIndex;
      provider.seekValue = 0;
      provider.playAudio(provider.playlist[newIndex].songName);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    int seekValue = 0;

    return Scaffold(
      body: Consumer<PlatListProvider>(builder: (context, value, child) {
        final List<Songs> playlist = value.playlist;
        final int currentIndex = value.currentIndex;
        final Songs currentSong = playlist[currentIndex];

        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                currentSong.photo,
                fit: BoxFit.fill,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: height / 1.49,
              ),
              child: SizedBox(
                height: 320,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    value.currentIndex = index;
                    setState(() {});
                  },
                  itemCount: playlist.length,
                  itemBuilder: (context, index) {
                    final song = playlist[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              seekValue = seekValue;
                            });
                            value.forward10Seconds(seekValue);
                          },
                          child: const Icon(
                            Icons.forward_10,
                            size: 80,
                            color: Colors.brown,
                          ),
                        ),
                        GestureDetector(
                          onDoubleTap: () {
                            value.isPlaying = !value.isPlaying;
                            value.pauseAudio();
                          },
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.easeInCirc,
                            );
                            value.isPlaying = !value.isPlaying;
                            value.currentIndex = index;
                            value.playAudio(song.songName);
                            setState(() {}); // Update the background photo
                          },
                          child: SizedBox(
                            width: 150,
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.asset(
                                song.photo,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }
}
