import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:picstar/pages/ai_generator_screen/model/promptsModel.dart';
import 'package:picstar/pages/ai_generator_screen/widgets/try_inspiration.dart';
import 'package:picstar/shared/routes/routes.dart';

import '../apiclient/inspirations/prompts.dart';

class InspirationsPage extends StatefulWidget {
  const InspirationsPage({super.key});

  @override
  State<InspirationsPage> createState() => _InspirationsPageState();
}

bool isgridloading = false;

class _InspirationsPageState extends State<InspirationsPage> {
  late List<InspirationInfo> inspirations = [];
  @override
  void initState() {
    super.initState();
    isgridloading = true;
    fetchData().then((_) {
      isgridloading = false;
    });
  }

  Future<void> fetchData() async {
    try {
      final apiService = InspirationsPrompt();
      final fetchedItems = await apiService.fetchItems(context);
      setState(() {
        inspirations = fetchedItems;
      });
      // setState(() {
      //   styles = fetchedItems;
      // });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showPopup(
    InspirationInfo item,
  ) {
    String imageUrl = '$baseApiUrl/${item.image}';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          content: TryInspiration(
            watchVideoCallback: () {
              Navigator.pushReplacementNamed(
                context,
                RouteHelper.aiGenerator,
                arguments: {'prompt': item.prompt},
              );
            },
            customText: item.prompt,
            customImage: CachedNetworkImageProvider(imageUrl),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  int selectedIndex = -1;
  String baseApiUrl = 'https://cognise.art';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Inspirations',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.42,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 1.2,
                      width: double.infinity,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: MediaQuery.of(context).size.width ~/
                                110, // Adjust the item width based on the screen size
                            childAspectRatio: 0.62,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: inspirations.length,
                          itemBuilder: (context, index) {
                            InspirationInfo item = inspirations[index];
                            bool isSelected = selectedIndex == index;
                            precacheImage(
                                CachedNetworkImageProvider(
                                    '$baseApiUrl/${item.image}'),
                                context);

                            return InkWell(
                                onTap: () {
                                  print('Item tapped at index $index');
                                  setState(() {
                                    selectedIndex = isSelected ? -1 : index;

                                    _showPopup(item);

                                    // selectedStylesid =
                                    //
                                    //
                                    //    isSelected ? null : item.id;
                                  });
                                },
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 110,
                                        height: 154,
                                        decoration: ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: isSelected
                                                  ? const Color(0xFF8181FF)
                                                  : Colors.white,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        '$baseApiUrl/${item.image}',
                                                    fit: BoxFit.cover,
                                                    height: 152,
                                                    placeholder:
                                                        (context, url) =>
                                                            const Center(
                                                      child: Image(
                                                          image: AssetImage(
                                                              'assets/icons/loading.png')),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (isSelected)
                                              const Positioned.fill(
                                                child: Center(
                                                  child: Image(
                                                    image: AssetImage(
                                                        'assets/icons/checkmarkRounded.webp'),
                                                    width: 15,
                                                    height: 15,
                                                  ),
                                                ),
                                              ),
                                            Positioned(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: FittedBox(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.6),
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    height: 50,
                                                    width: 150,
                                                    child: Center(
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        item.prompt,
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? const Color(
                                                                  0xFF8181FF)
                                                              : Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.48,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines:
                                                            2, // Set the maximum number of lines to 2
                                                        softWrap:
                                                            true, // Allow the text to wrap onto the next line
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ]));
                          }),
                    ),
                  ),
                ],
              ),
            ),
            if (isgridloading)
              const Positioned.fill(
                child: Center(
                    child: SpinKitSpinningLines(color: Color(0xFF8181FF))),
              )
          ]),
        ),
      ),
    );
  }
}
