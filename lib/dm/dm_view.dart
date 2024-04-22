import 'package:assign_mate/database/database.dart';
import 'package:assign_mate/dm/cubit/dm_cubit.dart';
import 'package:assign_mate/dm/tiles/cubit/dm_tiles_cubit.dart';
import 'package:assign_mate/dm/tiles/dm_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bottomNavigation/navigation_bar_view.dart';

class DMView extends StatelessWidget {
  const DMView({super.key});


  @override
  Widget build(BuildContext context)  {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Direct Messages"),
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
                    if (snapshot.data['DM'].length != null && snapshot.data['DM'].length != 0) {
                      return ListView.builder(
                        itemCount: snapshot.data['DM'].length,
                        itemBuilder: (context,i){
                          return MultiBlocProvider(
                            providers: [
                              BlocProvider<DMTilesCubit>(
                                create: (context) => DMTilesCubit(),
                              ),
                            ],
                            child: DMTile(id: snapshot.data['DM'][i],),
                          );
                        },
                      );
                    }
                    else{
                      return const Center(child: Text("There is no Messengers at this moment\n "
                          "You can add Messengers from the + button"),);
                    }
                  }
                  else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
            return Text("something went wrong");
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              final controller = TextEditingController();
              return AlertDialog(
                title: const Text("Add a mate", textAlign: TextAlign.center,),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade900),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Mate's Username",
                      ),
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        if(controller.text.isEmpty){
                          return;
                        }

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return const AlertDialog(
                                  title: CircularProgressIndicator()
                              );
                            }
                        );

                        QuerySnapshot querySnapshot = await Database().getUserData(controller.text);
                        if (querySnapshot.docs.isNotEmpty){
                          await Database().createDM(controller.text);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();

                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Mate has been Added successfully", textAlign: TextAlign.center,),
                              );
                            }
                          );
                        }
                        else {
                          Navigator.of(context).pop();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                  title: Text("There Does not exist a mate with this Username", textAlign: TextAlign.center,),
                              );
                            }
                          );
                        }
                      },
                      child: const Text("add")),
                ],
              );
            }
          )
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: NavigationBarView(NavigationBarView.DMIndex),
    );
  }
}