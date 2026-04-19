import 'package:cromostracker/app/shell_page.dart';
import 'package:cromostracker/data/mock_album_data.dart';
import 'package:cromostracker/features/album/cubit/album_cubit.dart';
import 'package:cromostracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CromosTrackerApp extends StatelessWidget {
  const CromosTrackerApp({
    super.key,
    this.albumCubit,
  });

  /// Injected in tests; default uses [createMockAlbum].
  final AlbumCubit? albumCubit;

  @override
  Widget build(BuildContext context) {
    final child = MaterialApp(
      title: 'CromosTracker',
      theme: buildAppTheme(),
      home: const ShellPage(),
    );
    if (albumCubit != null) {
      return BlocProvider.value(value: albumCubit!, child: child);
    }
    return BlocProvider(
      create: (_) => AlbumCubit(createMockAlbum()),
      child: child,
    );
  }
}
