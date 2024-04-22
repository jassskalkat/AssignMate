import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';

class GroupChatTile extends StatelessWidget {
  final String message;
  final String sender;
  final String url;
  final String user;
  final String time;

  const GroupChatTile({Key? key, required this.message, required this.sender, required this.url, required this.user, required this.time})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: user == sender ? Alignment.centerRight: Alignment.centerLeft,
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: user == sender ? 0:20,
          right: user == sender ? 20:0
      ),
      child: Container(
        margin: user == sender ? const EdgeInsets.only(left: 30): const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(top:15, bottom: 15,left: 20,right: 20),
        decoration: BoxDecoration(
          borderRadius: user == sender ? const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ): const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          color: user == sender ? Colors.blue : Colors.grey[400],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            user == sender ?
            const SizedBox.shrink() :
            Text(sender, textAlign: TextAlign.left, style: const TextStyle(color: Colors.deepPurpleAccent),),
            const SizedBox(height: 2,),
            SelectableText(message, textAlign: TextAlign.center,),
            url == ''? const SizedBox.shrink(): FullScreenWidget(disposeLevel: DisposeLevel.High, child: Image.network(url)),
            const SizedBox(height: 5,),
            Text(getTime(time), textAlign: TextAlign.right,style: const TextStyle(color: Colors.deepPurple),),
          ],
        ),
      ),
    );
  }

  String getTime(String timestampString){
    if (timestampString == ''){
      return '';
    }
    int timestamp = int.parse(timestampString);
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration diff = now.difference(date);

    if (diff.inDays == 0) {
      return DateFormat('h:mm a').format(date);
    } else if(diff.inDays == 1){
      return "yesterday ${DateFormat('h:mm a').format(date)}";
    }else if (diff.inDays >= 365){
      return DateFormat('yyyy/MM/dd h:mm a').format(date);
    }
    else{
      return DateFormat('MM/dd h:mm a').format(date);
    }
  }
}