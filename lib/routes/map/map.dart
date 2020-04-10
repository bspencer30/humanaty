import 'package:flutter/material.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/models/models.dart';
import 'package:humanaty/routes/_router.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  HumanatyLocation _location;
  List<DateTime> filterDates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            GoogleMaps(location: _location),
            _filter(context),
          ],
        ),
        appBar: HumanatyAppBar(
          displayBackBtn: true,
          title: _location?.city ?? 'Atlanta',
          actions: [_search(context)],
        ));
  }

  Widget _search(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search, color: Colors.grey),
      onPressed: () async {
        String location =
            await showSearch(context: context, delegate: MapSearch());
        print(location);
        if (location != null) {
          setState(() {
            _location = HumanatyLocation.fromString(location);
          });
          print(_location);
        }
      },
    );
  }

  Widget _filter(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
                child: Text(
                  "Date",
                  style: TextStyle(fontSize: 16),
                ),
                color: Colors.white,
                onPressed: () async {
                  List<DateTime> selectedDates = await showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return FilterDate(
                          selectedDates: filterDates,
                        );
                      },
                      backgroundColor: Colors.white);
                  if (selectedDates != null) {
                    filterDates = selectedDates;
                  }
                }),
          ),
          SizedBox(width: 8),
          Expanded(
              child: RaisedButton(
                  child: Text("Filters", style: TextStyle(fontSize: 16)),
                  color: Colors.white,
                  onPressed: () async {
                    String filters = await showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Filter();
                        },
                        backgroundColor: Colors.white);
                  }))
        ],
      ),
    );
  }
}
