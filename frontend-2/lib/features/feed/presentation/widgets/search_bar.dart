import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({ super.key });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {

  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      maxLines: 1,
      decoration: const InputDecoration(
        labelText: 'Поиск...',
        hintText: 'Поиск...',
      ),
    );
  }
}