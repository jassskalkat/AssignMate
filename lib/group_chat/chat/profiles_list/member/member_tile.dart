import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../routes/route_generator.dart';
import 'cubit/member_tile_cubit.dart';

class MemberTile extends StatelessWidget {
  final String memberUsername;

  const MemberTile({super.key, required this.memberUsername});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberTileCubit, MemberTileState>(
      builder: (context, state) {
        if(state is MemberTileInitial){
          context.read<MemberTileCubit>().getInfo(memberUsername);
          return const Center(child: CircularProgressIndicator());
        }
        else if(state is MemberTileLoading){
          return const Center(child: CircularProgressIndicator());
        }
        else if (state is MemberTileLoaded){
          final currUsername = state.currUsername;
          final picUrl = state.picUrl;

          return Container(
            margin: const EdgeInsets.all(2),
            padding: const EdgeInsets.all(7),
            color: Colors.grey[400],
            child: ListTile(
              onTap: () {
                if(memberUsername != currUsername) {
                  Navigator.pushNamed(context, RouteGenerator.profilePage,
                      arguments: memberUsername);
                }
              },
              leading: CircleAvatar(
                radius: 35,
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
              ),
              title: Text(memberUsername != currUsername ? memberUsername: "You"),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}