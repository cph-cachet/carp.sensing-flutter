import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    // Initialization of serialization
    tmp = DomainJsonFactory();
  });

  group('Trigger Tests', () {
    test(' - RecurrentScheduledTrigger - success', () {
      RecurrentScheduledTrigger t;

      // collect every day at 13:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: TimeOfDay(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      //print(toJsonString(t));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inHours, 24);

      // collect every day at 22:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: TimeOfDay(hour: 22, minute: 30),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inHours, 24);

      // collect every other day at 13:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        separationCount: 1,
        time: TimeOfDay(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 2);

      // collect every wednesday at 12:23
      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.wednesday,
        time: TimeOfDay(hour: 12, minute: 23),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 7);

      // collect every thursday at 14:23
      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.thursday,
        time: TimeOfDay(hour: 14, minute: 23),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 7);

      // collect every 2nd thursday at 14:00
      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.thursday,
        separationCount: 1,
        time: TimeOfDay(hour: 14, minute: 00),
        duration: Duration(seconds: 1),
      );
      print(
          'weekly, Thursday at 14:00 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 2 * 7);

      // the monthly trigger from iPDM-GO app
      t = RecurrentScheduledTrigger(
        triggerId: 'Blood glucose events trigger',
        type: RecurrentType.monthly,
        dayOfMonth: 1,
        time: TimeOfDay(hour: 18),
        remember: true,
        duration: Duration(seconds: 1),
      );
      print(
          'monthly, 1st day of month at 18:00 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 1 * 30);

      // collect quarterly on the 11th day of the first month
      // in each quarter at 21:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        dayOfMonth: 11,
        separationCount: 2,
        time: TimeOfDay(hour: 21, minute: 30),
        duration: Duration(seconds: 1),
      );
      print(
          'quarterly, 11th day of month at 21:30 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 3 * 30);

      // collect monthly in the second week on a monday at 14:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        weekOfMonth: 2,
        dayOfWeek: DateTime.tuesday,
        time: TimeOfDay(hour: 14, minute: 30),
        duration: Duration(seconds: 1),
      );
      print(
          'monthly, 2nd week of month on Tuesday at 14:30 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.firstOccurrence.weekday, DateTime.tuesday);
      expect(t.period.inDays, 30);

      // collect quarterly as above,
      // but remember this trigger across app shutdown
      t = RecurrentScheduledTrigger(
        triggerId: '1234wef',
        type: RecurrentType.monthly,
        dayOfMonth: 11,
        separationCount: 2,
        time: TimeOfDay(hour: 21, minute: 30),
        remember: true,
        duration: Duration(seconds: 1),
      );
      print(
          'quarterly, 11th day of month at 21:30 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 3 * 30);
    });

    test(' - RecurrentScheduledTrigger - scheduling I', () {
      RecurrentScheduledTrigger t;

      // collect every day at 13:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: TimeOfDay(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      //print(toJsonString(t));
      print(t);
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inHours, 24);

      final from = DateTime.now();
      final to = from.add(const Duration(days: 5));
      final ex = RecurrentScheduledTriggerExecutor();
      ex.initialize(t);

      List<DateTime> schedule = ex.getSchedule(from, to);
      print(schedule);
      schedule.forEach((time) {
        assert(time.isAfter(from));
        assert(time.isBefore(to));
      });
    });

    test(' - RecurrentScheduledTrigger - scheduling II', () {
      RecurrentScheduledTrigger t;

      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.wednesday,
        time: TimeOfDay(hour: 12, minute: 23),
        duration: Duration(seconds: 1),
      );
      print(t);
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 7);

      final from = DateTime.now();
      final to = from.add(const Duration(days: 25));
      final ex = RecurrentScheduledTriggerExecutor();
      ex.initialize(t);

      List<DateTime> schedule = ex.getSchedule(from, to);
      print(schedule);
      schedule.forEach((time) {
        assert(time.isAfter(from));
        assert(time.isBefore(to));
      });
    });

    test(' - RecurrentScheduledTrigger - assert failures', () {
      // all of the following should fail due to assert
      RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: TimeOfDay(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        separationCount: -1,
        time: TimeOfDay(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );

      RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        time: TimeOfDay(hour: 12, minute: 23),
        duration: Duration(seconds: 1),
      );

      RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        dayOfWeek: DateTime.monday,
        time: TimeOfDay(hour: 14, minute: 30),
        duration: Duration(seconds: 1),
      );
      RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        dayOfMonth: 43,
        separationCount: 2,
        time: TimeOfDay(hour: 21, minute: 30),
        duration: Duration(seconds: 1),
      );
      RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        weekOfMonth: 12,
        dayOfWeek: DateTime.monday,
        time: TimeOfDay(hour: 14, minute: 30),
        duration: Duration(seconds: 1),
      );
    }, skip: true);

    test(' - CronScheduledTrigger', () {
      print('cron job at 12:00 every day.');
      CronScheduledTrigger t =
          CronScheduledTrigger.parse(cronExpression: '0 12 * * *');
      print(t);
      print(toJsonString(t));

      t = CronScheduledTrigger(
        minute: 0,
        hour: 12,
        duration: Duration(seconds: 1),
      );
      print(t);

      final from = DateTime.now();
      final to = from.add(const Duration(days: 5));
      final ex = CronScheduledTriggerExecutor();
      ex.initialize(t);

      List<DateTime> schedule = ex.getSchedule(from, to);
      print(schedule);
      schedule.forEach((time) {
        assert(time.isAfter(from));
        assert(time.isBefore(to));
      });

      // t = CronScheduledTrigger(
      //   minute: 10,
      //   hour: 12,
      //   day: 5,
      //   month: DateTime.april,
      //   weekday: DateTime.tuesday,
      //   duration: Duration(seconds: 1),
      // );
      // print(t);
    });

    test(' - RandomRecurrentTrigger', () {
      RandomRecurrentTrigger t = RandomRecurrentTrigger(
        // startTime: Time(hour: 8, minute: 0),
        // endTime: Time(hour: 20, minute: 0),
        startTime: TimeOfDay(hour: 8, minute: 56),
        endTime: TimeOfDay(hour: 20, minute: 10),
        // startTime: Time(hour: 8, minute: 0),
        // endTime: Time(hour: 8, minute: 30),
        minNumberOfTriggers: 2,
        maxNumberOfTriggers: 8,
        duration: Duration(seconds: 1),
      );
      print(toJsonString(t));

      final ex = RandomRecurrentTriggerExecutor();
      ex.initialize(t);
      List<TimeOfDay> times = ex.samplingTimes;
      print(times);
      times.forEach((time) {
        assert(time.isAfter(t.startTime));
        assert(time.isBefore(t.endTime));
      });

      final from = DateTime.now();
      final to = from.add(const Duration(days: 5));
      List<DateTime> schedule = ex.getSchedule(from, to);
      print(schedule);
      schedule.forEach((time) {
        assert(time.isAfter(from));
        assert(time.isBefore(to));
      });
    });

    test(' - ConditionalPeriodicTrigger', () {
      ConditionalPeriodicTrigger t = ConditionalPeriodicTrigger(
        period: Duration(minutes: 1),
        resumeCondition: () {
          return ('jakob'.length == 5);
        },
      );
      print(toJsonString(t));

      ConditionalPeriodicTriggerExecutor ex =
          ConditionalPeriodicTriggerExecutor();
    });

    /// Test template.
    test('...', () {
      // test template
    });
  });
}
