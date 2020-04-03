import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:humanaty/common/design.dart';

class DateSelect extends StatefulWidget {
  _DateSelectState createState() => _DateSelectState();
}

class _DateSelectState extends State<DateSelect> {
  DateTime _currentDate;
  EventList<Event> _marked = EventList<Event>(events: {});
  

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 350,
      //width: 100,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.close, color: Colors.black54),
                  onPressed:() => Navigator.of(context).pop(),),
                Text('Selected Dates', style: TextStyle(fontSize: 20, color: Colors.black)),
                IconButton(
                  icon: Icon(Icons.check, color: Colors.black54,),
                  onPressed:() => Navigator.of(context).pop(getMarkedDates()),)],),
          ),
          Container(
            height: 300, 
            width: double.infinity,
            child: calendar(context))],
      ),
    );
  }

  Widget calendar(BuildContext context){
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: CalendarCarousel(
        headerMargin: EdgeInsets.only(top: 8.0, bottom: 16.0),
        todayButtonColor: Colors.transparent,
        todayTextStyle: TextStyle(color: Colors.black),
        weekendTextStyle: TextStyle(color: Colors.black),
        headerTextStyle: TextStyle(fontSize: 20.0, color: Colors.black, fontFamily: 'Nuninto_Sans'),
        iconColor: Pallete.humanGreen,
        weekdayTextStyle: TextStyle(color: Colors.black),
        //selectedDateTime: _currentDate,
        onDayLongPressed:(DateTime time){},
        onDayPressed: (DateTime date, List _){
          if(_marked.removeAll(date).isEmpty) _marked.add(date, Event(date: date));  
          this.setState((){_currentDate = date;});
        },
        markedDateShowIcon: true,
        markedDatesMap: _marked,
        showIconBehindDayText: true,
        markedDateCustomTextStyle: TextStyle(color: Colors.white),  
        markedDateIconBuilder: markedDate,
      ),
    ); 
  }

  Widget markedDate(Event event){
    return Container(
      decoration: BoxDecoration(
        color: Pallete.humanGreen,
        shape: BoxShape.circle
      ),
    );
  }
  
  String getMarkedDates() => _marked.events.keys.toString();
  

}