import 'package:cromostracker/app/shell_page.dart';
import 'package:cromostracker/data/mock_album_data.dart';
import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CromosTrackerApp extends StatelessWidget {
  const CromosTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlbumCubit(createMockAlbum()),
      child: MaterialApp(
        title: 'CromosTracker',
        theme: buildAppTheme(),
        home: const ShellPage(),
      ),
    );
  }
}
