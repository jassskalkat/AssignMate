import 'package:assign_mate/group_chat/chat/group_info.dart';
import 'package:assign_mate/routes/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'cubit/group_tiles_cubit.dart';

class GroupChatTile extends StatelessWidget {
  final String id;
  const GroupChatTile({super.key, required this.id,});


  @override
  Widget build(BuildContext context) {


    return BlocBuilder<GroupTilesCubit, GroupTilesState>(
        builder: (context, state) {
          if (state is TilesInitial){
            context.read<GroupTilesCubit>().getInfo(id);
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is TileLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is TileLoaded){
            final groupData = state.snapshot;
            final currUsername = state.currUsername;
            return StreamBuilder(
              stream: groupData,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  String subtitle = "";

                  if(snapshot.data['recentMessageSender'] == currUsername){
                    subtitle = "You: ";
                  }else if(snapshot.data['recentMessageSender'].toString().isNotEmpty){
                    subtitle = snapshot.data['recentMessageSender'] + ": ";
                  }
                  else{
                    subtitle = "";
                  }

                  if(snapshot.data['recentMessage'].toString().length > 20){
                    subtitle += snapshot.data['recentMessage'].toString().substring(0,20);
                  }
                  else{
                    subtitle += snapshot.data['recentMessage'].toString();
                  }

                  GroupInfo info = GroupInfo(snapshot.data["group_ID"], currUsername, snapshot.data["title"]);

                  return Column(
                    children: [
                      const SizedBox(height: 5,),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, RouteGenerator.groupChatPage, arguments: info);
                        },
                        title: Text(snapshot.data['title']),
                        subtitle: Text(subtitle),
                        trailing: Text(getTime(snapshot.data['recentMessageTime'].toString())),
                      )
                    ],
                  );
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          }
          return const Text("something went wrong");
        });
  }

  String getTime(String timestampString){
    if (timestampString == ''){
      return '';
    }
    int timestamp = int.parse(timestampString);
    DateTime now = DateTime.now();
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    Duration diff = now.difference(date);

    if (diff.inDays == 0) { // same day
      return DateFormat('h:mm a').format(date);
    } else if (diff.inDays == 1) { // previous day
      return 'Yesterday';
    } else { // before previous day
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }
}