import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/UserProfile.dart';

import '../blocs/profile/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final userService = getIt<UserService>();
        final postService = getIt<PostService>();
        return ProfileBloc(userService, postService)
          ..add(ProfileInitialEvent());
      },
      child: ProfilePageSF(),
    );
  }
}

class ProfilePageSF extends StatefulWidget {
  const ProfilePageSF({super.key});

  @override
  State<ProfilePageSF> createState() => _ProfilePageSFState();
}

class _ProfilePageSFState extends State<ProfilePageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileSucces) {
          return ProfileLandingPage(
            state: state,
          );
        } else if (state is ProfileFailure) {
          return Center(
            child: Text(state.error),
          );
        } else {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 40),
          );
        }
      },
    );
  }
}

class ProfileLandingPage extends StatefulWidget {
  final ProfileSucces state;
  const ProfileLandingPage({
    super.key,
    required this.state,
  });

  @override
  State<ProfileLandingPage> createState() => _ProfileLandingPageState();
}

class _ProfileLandingPageState extends State<ProfileLandingPage> {
  @override
  Widget build(BuildContext context) {
    return UserProfile(
      profile: widget.state.profile,
      posts: widget.state.posts,
      context: context,
    );
  }
}
