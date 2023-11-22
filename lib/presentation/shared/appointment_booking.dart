// import 'package:fahem/core/resources/colors_manager.dart';
// import 'package:fahem/core/resources/strings_manager.dart';
// import 'package:fahem/core/utils/app_provider.dart';
// import 'package:fahem/core/utils/enums.dart';
// import 'package:fahem/core/utils/extensions.dart';
// import 'package:fahem/core/utils/methods.dart';
// import 'package:flutter/material.dart';
// import 'package:booking_calendar/booking_calendar.dart';
// import 'package:provider/provider.dart';
//
// class AppointmentBooking extends StatefulWidget {
//   final int targetId;
//   final TransactionType transactionType;
//
//   const AppointmentBooking({Key? key, required this.targetId, required this.transactionType}) : super(key: key);
//
//   @override
//   State<AppointmentBooking> createState() => _AppointmentBookingState();
// }
//
// class _AppointmentBookingState extends State<AppointmentBooking> {
//   late AppProvider appProvider;
//   List<DateTimeRange> converted = [];
//   final DateTime now = DateTime.now();
//
//   @override
//   void initState() {
//     
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height,
//       child: BookingCalendar(
//         availableSlotColor: ColorsManager.green.withOpacity(0.8),
//         bookedSlotColor: ColorsManager.green.withOpacity(0.3),
//         selectedSlotColor: ColorsManager.primaryColor,
//         bookingButtonColor: ColorsManager.primaryColor,
//
//         availableSlotText: Methods.getText(StringsManager.available, appProvider.isEnglish).toCapitalized(),
//         pauseSlotText: Methods.getText(StringsManager.pause, appProvider.isEnglish).toCapitalized(),
//         bookedSlotText: Methods.getText(StringsManager.booked, appProvider.isEnglish).toCapitalized(),
//         selectedSlotText: Methods.getText(StringsManager.selected, appProvider.isEnglish).toCapitalized(),
//         bookingButtonText: Methods.getText(StringsManager.booking, appProvider.isEnglish).toCapitalized(),
//
//         bookingService: BookingService(
//           serviceName: 'Appointment Booking',
//           serviceDuration: 30,
//           bookingStart: DateTime(now.year, now.month, now.day, 0, 0),
//           bookingEnd: DateTime(now.year, now.month, now.day, 23, 0),
//         ),
//         convertStreamResultToDateTimeRanges: ({required dynamic streamResult}) {
//           DateTime first = now;
//           DateTime tomorrow = now.add(const Duration(days: 1));
//           DateTime second = now.add(const Duration(minutes: 55));
//           DateTime third = now.subtract(const Duration(minutes: 240));
//           DateTime fourth = now.subtract(const Duration(minutes: 500));
//           converted.add(DateTimeRange(start: first, end: now.add(const Duration(minutes: 30))));
//           converted.add(DateTimeRange(start: second, end: second.add(const Duration(minutes: 23))));
//           converted.add(DateTimeRange(start: third, end: third.add(const Duration(minutes: 15))));
//           converted.add(DateTimeRange(start: fourth, end: fourth.add(const Duration(minutes: 50))));
//
//           //book whole day example
//           converted.add(DateTimeRange(
//             start: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 5, 0),
//             end: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 0)),
//           );
//           return converted;
//         },
//         getBookingStream: ({required DateTime end, required DateTime start}) {
//           return Stream.value([]);
//         },
//         uploadBooking: ({required BookingService newBooking}) async {
//           await Future.delayed(const Duration(seconds: 1)).then((value) async {
//             converted.add(DateTimeRange(
//                 start: newBooking.bookingStart,
//                 end: newBooking.bookingEnd,
//               ));
//             await Methods.appointmentBookingCalendar(context: context, targetId: widget.targetId, transactionType: widget.transactionType, date: newBooking.bookingStart.millisecondsSinceEpoch.toString()).then((value) {
//               Methods.showToast(Methods.getText(StringsManager.consultationBooked, appProvider.isEnglish).toCapitalized(), toastColor: ColorsManager.green);
//               Navigator.pop(context);
//             });
//           });
//         },
//         pauseSlots: const [],
//         hideBreakTime: false,
//         loadingWidget: const Text('Fetching data...'),
//         uploadingWidget: const Center(child: CircularProgressIndicator()),
//         locale: appProvider.isEnglish ? 'en_US' : 'ar_EG',
//         startingDayOfWeek: StartingDayOfWeek.saturday,
//         // wholeDayIsBookedWidget: const Text('Sorry, for this day everything is booked'),
//         // disabledDates: [DateTime(2023, 1, 20)],
//         // disabledDays: [6, 7],
//       ),
//     );
//   }
// }