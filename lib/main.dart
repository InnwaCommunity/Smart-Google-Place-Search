import 'package:customize_google_place_api/bloc/search_address_bloc.dart';
import 'package:customize_google_place_api/provider/place_provider.dart';
import 'package:customize_google_place_api/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => PlaceProvier(),
            child: const MyHomePage(title: 'Google Places Search'),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Places Search',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'Google Places Search'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController placeController = TextEditingController();
  final SearchPlaceListsBloc _searchBloc = SearchPlaceListsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Consumer<PlaceProvier>(builder: (consumerContext, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [searchBar(context, _searchBloc, placeController)],
        );
      }),
    );
  }

  Widget searchBar(BuildContext context, SearchPlaceListsBloc searchBloc,
      TextEditingController searchController) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextFormField(
                    scrollPadding: EdgeInsets.zero,
                    controller: searchController,
                    onChanged: (text) async {
                      if (text != "") {
                        searchBloc.updateSuggestions(text);
                      } else {
                        searchBloc.resetSuggestions();
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintText: 'Key Words',
                      labelStyle: const TextStyle(color: Colors.black),
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SearchSuggestionsOverlay(
              suggestionsStream: searchBloc.suggestionsStream,
              onItemSelected: (String selectedText, String selectedRiderID) {
                searchController.text = selectedText;
              },
            ),
          ),
        ],
      ),
    );
  }
}
