import 'dart:async';
import 'package:customize_google_place_api/bloc/search_address_bloc.dart';
import 'package:customize_google_place_api/entity/suggestion.dart';
import 'package:flutter/material.dart';

typedef OnItemSelectedCallback = void Function(
    String selectedText, String selectedRiderID);

class SearchSuggestionsOverlay extends StatefulWidget {
  final Stream<List<Suggestion>> suggestionsStream;
  final OnItemSelectedCallback onItemSelected;

  const SearchSuggestionsOverlay(
      {super.key,
      required this.suggestionsStream,
      required this.onItemSelected});

  @override
  SearchSuggestionsOverlayState createState() =>
      SearchSuggestionsOverlayState();
}

class SearchSuggestionsOverlayState extends State<SearchSuggestionsOverlay> {
  OverlayEntry? _overlayEntry;
  final SearchPlaceListsBloc _searchBloc = SearchPlaceListsBloc();

  @override
  void initState() {
    super.initState();
    widget.suggestionsStream.listen((suggestions) {
      if (suggestions == []) {
        _hideOverlay();
      } else {
        _showOverlay(suggestions);
      }
    });
  }

  void _showOverlay(List<Suggestion> suggestions) {
    _hideOverlay();

    // if (suggestions == []) {
    //   _overlayEntry = OverlayEntry(
    //     builder: (context) => Positioned(
    //       top: MediaQuery.of(context).viewInsets.top + kToolbarHeight + 155,
    //       left: 14.0,
    //       right: 14.0,
    //       child: Material(
    //         elevation: 1,
    //         borderRadius: BorderRadius.circular(10),
    //         shadowColor: Colors.grey.withOpacity(0.9),
    //         child: InkWell(
    //           onTap: () {
    //             _hideOverlay();
    //           },
    //           child: const Padding(
    //             padding: EdgeInsets.all(16.0),
    //             child: Center(
    //               child: Text(
    //                 "User not found",
    //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // } else
    if (suggestions == []) {
      _hideOverlay();
    } else {
      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: kToolbarHeight + 75,
          left: 14.0,
          right: 14.0,
          child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
            shadowColor: Colors.grey.withOpacity(0.9),
            child: LimitedBox(
              maxHeight: 350,
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(suggestions[index].description),
                    onTap: () async {
                      _hideOverlay();
                      _searchBloc
                          .getPlaceDetailFromId(suggestions[index].placeId);
                      FocusScope.of(context).unfocus();
                      // widget.onItemSelected(
                      //   suggestionList[index].username,
                      //   suggestionList[index].riderid,
                      // );
                      // tripListReq.search = suggestionList[index].riderid;
                      // widget.dateProvider.searchText =
                      //     suggestionList[index].riderid;
                      // tripListReq.taxigroupkey =
                      //     suggestionList[index].taxigroupkey;
                      // TripListPresenter()
                      //     .getTripLists(context, tripListReq, true);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
    }

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _hideOverlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
