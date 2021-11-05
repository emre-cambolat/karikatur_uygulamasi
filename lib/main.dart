import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:metin_proje/components/responsive_size.dart';
import 'package:metin_proje/services/api_service.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ApiService apiService;
  late TextEditingController tcSearchBar;
  //Map imageData =  {};
  List<dynamic> liste = [];
  List<dynamic> tempList = [];
  List<dynamic> selectedList = [];
  List<int> cacheIndex = [];
  List<File> cachedImages =[];

  void _getData() async {
    List<String> tags = [];
    setState(
      () {
        apiService.fetchData(url: "https://labkod.net/cukubik/api.php").then(
          (value) {
            setState(
              () {
                liste = json.decode(value);
                for (int j = 0; j < liste.length; j++) {
                  DefaultCacheManager()
                      .getSingleFile(liste[j]["image"])
                      .then((file) async {
                        cachedImages.add(file);
                    cachedImages[j] = file;
                  });
                  tags = List<String>.from(liste[j]["tags"]);
                  for (int i = 0; i < tags.length; i++) {
                    tags[i] = tags[i].toLowerCase();
                  }
                  liste[j]["tags"] = tags;
                }
              },
            );
          },
        );
      },
    );
  }

  _doesContain({required String word,}) {
    tempList.clear();
    cacheIndex.clear();
    List<String> temp;
    for (int item = 0; item < liste.length; item++) {
      temp = List<String>.from(liste[item]["tags"]);
      for (var index in temp) {
        if (index.contains(word) && tempList.indexOf(temp) == -1) {
          cacheIndex.add(item);
          tempList.add(liste[item]);
          break;
        }
      }
    }
  }

  @override
  void initState() {
    tcSearchBar = TextEditingController();
    apiService = ApiService();
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    tcSearchBar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tempList.isEmpty ? selectedList = liste : selectedList = tempList;
    return Scaffold(
      backgroundColor: Colors.white38,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveSize.width / 72),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: ResponsiveSize.height / 144),
                height: ResponsiveSize.height / 48,
                child: TextField(
                  controller: tcSearchBar,
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(right: ResponsiveSize.width / 96),
                    isCollapsed: false,

                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Search image",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: tcSearchBar.text.isNotEmpty
                        ? InkWell(
                            child: Icon(
                              Icons.close,
                              color: Colors.grey.shade500,
                            ),
                            onTap: () {
                              setState(() {
                                tempList.clear();
                                cacheIndex.clear();
                                tcSearchBar.clear();
                              });
                            },
                          )
                        : SizedBox(),
                  ),
                  onChanged: (value) {
                    if (tcSearchBar.text.isEmpty) {
                      tempList.clear();
                      cacheIndex.clear();
                    }
                    if (tcSearchBar.text.length > 1) {
                      _doesContain(word: value.toLowerCase());
                    }
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: liste.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                      padding: EdgeInsets.only(
                          top: ResponsiveSize.height / 144),
                      child: GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: ResponsiveSize.height / 120,
                          crossAxisSpacing: ResponsiveSize.width / 72,
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                        ),
                        shrinkWrap: true,
                        primary: false,
                        physics: BouncingScrollPhysics(),
                        itemCount: selectedList.length,
                        itemBuilder: (context, index) {
                          if (tcSearchBar.text.isNotEmpty &&
                              tempList.isEmpty) {
                            return SizedBox();
                          } else {
                            return Tooltip(
                              message: selectedList[index]["tags"]
                                  .last
                                  .toString(),
                              child: InkWell(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade500,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12)),
                                    image: DecorationImage(
                                      image: CachedNetworkImageProvider(
                                        selectedList[index]["image"],
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: SizedBox(
                                          width:
                                              ResponsiveSize.width / 24,
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child:
                                                CircularProgressIndicator(),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  debugPrint(index.toString() +
                                      " numaralı resime tıklandı. Dosya adı: ${List<String>.from(selectedList[index]["tags"]).last}");
                                  debugPrint(cachedImages[tempList.isEmpty ? index: cacheIndex[index]].path);
                                  await cachedImages[tempList.isEmpty ? index: cacheIndex[index]]
                                      .readAsBytes()
                                      .then((bytes) {
                                    Navigator.pop(context);
                                    WcFlutterShare.share(
                                      sharePopupTitle: 'Share this image',
                                      //subject: 'This is subject',
                                      //text: 'This is text',
                                      fileName: List<String>.from(
                                              selectedList[index]["tags"])
                                          .last
                                          .trim(),
                                      mimeType: 'image/png',
                                      bytesOfFile: bytes,
                                    );
                                  });
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
