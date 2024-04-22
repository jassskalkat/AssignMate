import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/profile_list_cubit.dart';
import 'member/cubit/member_tile_cubit.dart';
import 'member/member_tile.dart';

class ProfilesListView extends StatelessWidget {
  final String groupID;
  const ProfilesListView({super.key, required this.groupID});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileListCubit, ProfileListState>(
        builder: (context, state) {
          if(state is ProfileListInitial){
            context.read<ProfileListCubit>().getGroupInfo(groupID);
            return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                ),
                body: const Center(child: CircularProgressIndicator()),
            );
          }
          else if(state is ProfileListLoading){
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: true,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          else if(state is ProfileListLoaded){
            final snapshot = state.snapshot;
            return StreamBuilder(
              stream: snapshot,
              builder: (context, AsyncSnapshot snapshot){
                if (snapshot.hasData){
                  if (snapshot.data['members'].length != null && snapshot.data['members'].length != 0) {
                    return Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        automaticallyImplyLeading: true,
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(snapshot.data['title']),
                            ],
                        ),
                      ),
                      body: ListView.builder(
                        itemCount: snapshot.data['members'].length,
                        itemBuilder: (context,i){
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider<MemberTileCubit>(
                                create: (context) => MemberTileCubit(),
                              ),
                            ],
                            child: Container(
                              child: MemberTile(
                                memberUsername: snapshot.data['members'][i],
                              ),
                            )
                          );
                        },
                      ),
                    );
                  }
                  else{
                    return Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        automaticallyImplyLeading: true,
                      ),
                      body: const Center(child: Text("There is no members in this group"),),
                    );
                  }
                }
                else {
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      automaticallyImplyLeading: true,
                    ),
                    body: const Center(child: CircularProgressIndicator()),
                  );
                }
              },
            );
          }
          else{
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: true,
              ),
              body: const Text("Something went wrong"),
            );
          }
        },
    );
  }
}