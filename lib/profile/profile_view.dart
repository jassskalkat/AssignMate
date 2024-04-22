import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_screen_image/full_screen_image.dart';

import '../bottomNavigation/navigation_bar_view.dart';
import '../routes/route_generator.dart';
import 'cubit/profile_cubit.dart';

class ProfileView extends StatelessWidget {
  final String profileUsername;

  const ProfileView({super.key, required this.profileUsername});


  @override
  Widget build(BuildContext context) {
    String currentUserName = '';

    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileInitial) {
            context.read<ProfileCubit>().getUserData(profileUsername);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Mate's Profile"),
                automaticallyImplyLeading: false,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          else if (state is ProfileLoading) {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Mate's Profile"),
                automaticallyImplyLeading: false,
              ),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          else if (state is ProfileLoaded) {
            final data = state.data;
            currentUserName = state.currentUserName;

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Mate's Profile"),
                automaticallyImplyLeading: currentUserName == profileUsername? false: true,
              ),
              body: Center(
                child: ListView(
                  children: [
                    const SizedBox(height: 15,),
                    CircleAvatar(
                      radius: 100,
                      child: FullScreenWidget(
                        disposeLevel: DisposeLevel.High,
                        child: data['profilePicUrl'] == "" ?
                        Container(
                          width: 200,
                          height: 200,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey,
                          ),
                          child: const Icon(
                              Icons.account_circle_rounded, size: 150),
                        ) : ClipOval(
                          child: Image.network(
                            data['profilePicUrl'],
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    SelectableText(profileUsername, textScaleFactor: 3,
                      textAlign: TextAlign.center,),
                    const SizedBox(height: 15,),
                    SelectableText(data['email'], textScaleFactor: 1.5,
                      textAlign: TextAlign.center,),
                    const SizedBox(height: 15,),
                    currentUserName == profileUsername ? Container(
                      color: Colors.grey[300],
                      height: 250,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: SelectableText(
                            data['bio'] == '' ? "Bio: " : data['bio'],
                            textScaleFactor: 1,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ) : SelectableText(
                      data['bio'],
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25,),
                    currentUserName == profileUsername ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamed(
                                  context, RouteGenerator.authPage);
                            },
                            child: const Text("sign out",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ],
                    ) : const SizedBox.shrink(),
                  ],
                ),
              ),

              floatingActionButton: currentUserName == profileUsername ?
              FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      RouteGenerator.editProfilePage,
                      arguments: data);
                },
                child: const Icon(Icons.edit),
              ) : const SizedBox.shrink(),
              bottomNavigationBar: currentUserName == profileUsername? NavigationBarView(
                  NavigationBarView.profileIndex): const SizedBox.shrink(),
            );
          }
          else {
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text("Mate's Profile"),
                automaticallyImplyLeading: false,
              ),
              body: const Text("Something went Wrong"),
              bottomNavigationBar: NavigationBarView(
                  NavigationBarView.profileIndex),
            );
          }
        }
    );
  }
}