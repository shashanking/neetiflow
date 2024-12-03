import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neetiflow/domain/entities/employee_timeline_event.dart';
import 'package:neetiflow/presentation/blocs/employee_timeline/employee_timeline_bloc.dart';
import 'package:neetiflow/presentation/widgets/employees/employee_timeline.dart';

class EmployeeTimelineContainer extends StatelessWidget {
  final String employeeId;
  final String companyId;

  const EmployeeTimelineContainer({
    super.key,
    required this.employeeId,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeTimelineBloc, EmployeeTimelineState>(
      builder: (context, state) {
        // Load timeline events when widget is first built
        if (state is EmployeeTimelineInitial) {
          context.read<EmployeeTimelineBloc>().add(
                LoadEmployeeTimeline(
                  employeeId: employeeId,
                  companyId: companyId,
                ),
              );
        }

        if (state is EmployeeTimelineError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading timeline',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return EmployeeTimeline(
          events: state is EmployeeTimelineLoaded ? state.events : <EmployeeTimelineEvent>[],
          isLoading: state is EmployeeTimelineLoading,
        );
      },
    );
  }
}
