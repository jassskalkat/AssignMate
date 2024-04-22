import 'package:assign_mate/dm/info.dart';
import 'package:assign_mate/dm/tiles/cubit/dm_tiles_cubit.dart';
import 'package:assign_mate/routes/route_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';

class DMTile extends StatelessWidget {
  final id;
  const DMTile({super.key, this.id,});


  @override
  Widget build(BuildContext context) {

    String name = '';

    return BlocBuilder<DMTilesCubit, DMTilesState>(
        builder: (context, state) {
          if (state is DMTilesInitial){
            context.read<DMTilesCubit>().getInfo(id);
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is DMTileLoading){
            return const Center(child: CircularProgressIndicator());
          }
          else if (state is DMTileLoaded){
            final messengers = state.snapshot;
            final currUsername = state.currUsername;
            final picUrl = state.picUrl;
            return StreamBuilder(
              stream: messengers,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['members'][0] == currUsername) {
                    name = snapshot.data['members'][1];
                  }
                  else {
                    name = snapshot.data['members'][0];
                  }
                  Info info = Info(snapshot.data['DM_ID'], snapshot.data['members'][1], snapshot.data['members'][0],name, picUrl);
                  return Column(
                    children: [
                      const SizedBox(height: 5,),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, RouteGenerator.dmChatPage, arguments: info);
                        },
                        leading: CircleAvatar(
                          radius: 35,
                          child: FullScreenWidget(
                            disposeLevel: DisposeLevel.High,
                            child: picUrl == '' ? 
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueGrey,
                              ),
                              child: const Icon(Icons.account_circle_rounded, size: 55),
                            ):
                            ClipOval(
                              child: Image.network(
                                picUrl,
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                              ),
                            ),
                          )
                        ),
                        title: Text(name),
                        subtitle: Text(
                            snapshot.data['recentMessage'].toString().length > 20
                                ? snapshot.data['recentMessage'].toString().substring(0,20)
                                : snapshot.data['recentMessage'].toString()
                        ),
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