import 'package:assign_mate/dm/cubit/dm_cubit.dart';
import 'package:assign_mate/group_chat/tiles/cubit/group_tiles_cubit.dart';
import 'package:assign_mate/group_chat/tiles/group_chat_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bottomNavigation/navigation_bar_view.dart';

class GroupView extends StatelessWidget {
  const GroupView({super.key});


  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Group Chats"),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<DmCubit, DmState>(
          builder: (context, state) {
            if (state is DmInitial){
              context.read<DmCubit>().getMessengers();
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is DmLoading){
              return const Center(child: CircularProgressIndicator());
            }
            else if (state is DmLoaded){
              final messengers = state.snapshot;
              return StreamBuilder(
                stream: messengers,
                builder: (context, AsyncSnapshot snapshot){
                  if (snapshot.hasData){
                    if (snapshot.data['assignmentsGroups'].length != null && snapshot.data['assignmentsGroups'].length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data['assignmentsGroups'].length,
                        itemBuilder: (context,i){
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider<GroupTilesCubit>(
                                create: (context) => GroupTilesCubit(),
                              ),
                            ],
                            child: GroupChatTile(id: snapshot.data['assignmentsGroups'][i],),
                          );},
                      );
                    }
                    else{
                      return const Center(child: Text("You are not enrolled in any assignments at this moment"),);
                    }
                  }
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
            return const Text("something went wrong");
          },
      ),
      bottomNavigationBar: NavigationBarView(NavigationBarView.groupsIndex),
    );
  }
}