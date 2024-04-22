import 'package:assign_mate/routes/route_generator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../bottomNavigation/navigation_bar_view.dart';
import '../database/database.dart';
import 'cubit/calendar_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String month = "month";
    const String week = "week";
    const String twoWeeks = "twoWeeks";
    TextEditingController eventController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    Map<DateTime, List<String>> events = {};

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("AssignMate"),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: NavigationBarView(NavigationBarView.homeIndex),
      body: SingleChildScrollView(
        child: BlocBuilder<CalendarCubit, CalendarState>(
          builder: (context, state) {
            if(state is CalendarInitial){
              context.read<CalendarCubit>().getEvents();
              return const Center(child: CircularProgressIndicator());
            }
            else if(state is CalendarMonth){
              events = state.events;
              final today = DateTime.now();
              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    availableGestures: AvailableGestures.all,
                    focusedDay: today,
                    headerStyle: const HeaderStyle(
                        titleCentered: true
                    ),
                    onDaySelected: (DateTime day, DateTime selected){
                      selectedDate = day;
                      context.read<CalendarCubit>().selectDay(day, selected,month);
                    },
                    onFormatChanged: (format){
                      context.read<CalendarCubit>().updateCalendarFormat();
                    },
                    eventLoader: (date) {
                      return events[DateTime(date.year,date.month,date.day)] ?? [];
                    }
                  ),
                  const SizedBox(height: 15,),
                  getEvents(context,selectedDate,events),
                ],
              );
            }
            else if(state is CalendarTwoWeeks){
              events = state.event;
              final today = DateTime.now();
              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    availableGestures: AvailableGestures.all,
                    focusedDay: today,
                    headerStyle: const HeaderStyle(
                        titleCentered: true
                    ),
                    onDaySelected: (DateTime day, DateTime selected){
                      selectedDate = day;
                      context.read<CalendarCubit>().selectDay(day, selected, twoWeeks);
                    },
                    calendarFormat: CalendarFormat.twoWeeks,
                    onFormatChanged: (format){
                      context.read<CalendarCubit>().updateCalendarFormat();
                    },
                    eventLoader: (date) {
                      return events[DateTime(date.year,date.month,date.day)] ?? [];
                    }
                  ),
                  const SizedBox(height: 15,),
                  getEvents(context,selectedDate,events),
                ],
              );
            }
            else if(state is CalendarOneWeek){
              events = state.event;
              final today = DateTime.now();
              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    availableGestures: AvailableGestures.all,
                    focusedDay: today,
                    headerStyle: const HeaderStyle(
                        titleCentered: true
                    ),
                    onDaySelected: (DateTime day, DateTime selected){
                      selectedDate = day;
                      context.read<CalendarCubit>().selectDay(day, selected, week);
                    },
                    calendarFormat: CalendarFormat.week,
                    onFormatChanged: (format){
                      context.read<CalendarCubit>().updateCalendarFormat();
                    },
                    eventLoader: (date) {
                      return events[DateTime(date.year,date.month,date.day)] ?? [];
                    }
                  ),
                  const SizedBox(height: 15,),
                  getEvents(context,selectedDate,events),
                ],
              );
            }
            else if(state is SelectedDay){
              events = state.event;
              final today = state.day;
              final format = state.format;
              CalendarFormat calendarFormat = CalendarFormat.month;
              if(format == week){
                calendarFormat = CalendarFormat.week;
              }
              else if(format == twoWeeks){
                calendarFormat = CalendarFormat.twoWeeks;
              }

              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    availableGestures: AvailableGestures.all,
                    focusedDay: today,
                    onDaySelected: (DateTime day, DateTime selected){
                      selectedDate = day;
                      context.read<CalendarCubit>().selectDay(day, selected,format);
                    },
                    headerStyle: const HeaderStyle(
                        titleCentered: true,
                    ),
                    calendarFormat: calendarFormat,
                    onFormatChanged: (format){
                      if(format == CalendarFormat.twoWeeks){
                        context.read<CalendarCubit>().selectDay(today, today,twoWeeks);
                      }
                      else if(format == CalendarFormat.week){
                        context.read<CalendarCubit>().selectDay(today, today,week);
                      } else{
                        context.read<CalendarCubit>().selectDay(today, today,month);
                      }
                    },
                    eventLoader: (date) {
                      return events[DateTime(date.year,date.month,date.day)] ?? [];
                    }
                  ),
                  const SizedBox(height: 15,),
                  getEvents(context,selectedDate,events),
                ],
              );
            }
            else{
              return const Text("Something Gone Wrong");
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: const Text("Add Event"),
              content: TextField(
                controller: eventController,
              ),
              actions: [
                TextButton(
                  onPressed: (){ Navigator.pop(context); },
                  child: const Text("Cancel"),
                ),
                TextButton(
                    onPressed: () async {
                      if(eventController.text.isEmpty){
                        showDialog(context: context, builder: (context) {
                          return const AlertDialog(
                            title: Text("You can not have an event without a name"),
                          );
                        });
                        return;
                      }
                      else {
                        Map<String, dynamic> event = {
                          "Name" : eventController.text,
                          "Date" : DateTime(selectedDate.year,selectedDate.month, selectedDate.day),
                        };
                        eventController.clear();
                        showDialog(context: context,barrierDismissible: false, builder: (context){
                          return const AlertDialog(
                            content: CircularProgressIndicator(),
                          );
                        });
                        String username = await Database().getUsernameFromEmail(FirebaseAuth.instance.currentUser!.email!);
                        await Database().addEvent(username, event);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RouteGenerator.homePage);
                      }
                    },
                    child: const Text("Add"),
                ),
              ],
            );
          });
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Event"),
      ),
    );
  }

  SizedBox getEvents(BuildContext context, DateTime selectedDate, Map<DateTime, List<String>> events){
    return SizedBox(
      height: 230,
      child: Card(
        elevation: 0,
        child: ListView.builder(
          itemCount: events[DateTime(selectedDate.year,selectedDate.month,selectedDate.day)]?.length ?? 0,
          itemBuilder: (context,i){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                title: Text(events[DateTime(selectedDate.year,selectedDate.month,selectedDate.day)]![i]),
                tileColor: Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
