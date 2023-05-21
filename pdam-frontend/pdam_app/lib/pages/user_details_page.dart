import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pdam_app/config/locator.dart';
import 'package:pdam_app/services/post_service.dart';
import 'package:pdam_app/services/user_service.dart';
import 'package:pdam_app/widgets/UserProfile.dart';
import 'package:shimmer/shimmer.dart';

import '../blocs/user_details/user_details_bloc.dart';

class UserDetailsPage extends StatelessWidget {
  final String userName;
  const UserDetailsPage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final userService = getIt<UserService>();
        final postService = getIt<PostService>();
        return UserDetailsBloc(userService, postService, userName)
          ..add(UserDetailsInitialEvent());
      },
      child: UserDetailsPageSF(),
    );
  }
}

class UserDetailsPageSF extends StatefulWidget {
  const UserDetailsPageSF({super.key});

  @override
  State<UserDetailsPageSF> createState() => _UserDetailsPageSFState();
}

class _UserDetailsPageSFState extends State<UserDetailsPageSF> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDetailsBloc, UserDetailsState>(
      builder: (context, state) {
        if (state is UserDetailsSucces) {
          return UserDetailsLandingPage(
            state: state,
          );
        } else if (state is UserDetailsFailure) {
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

class UserDetailsLandingPage extends StatefulWidget {
  final UserDetailsSucces state;
  const UserDetailsLandingPage({
    super.key,
    required this.state,
  });

  @override
  State<UserDetailsLandingPage> createState() => _UserDetailsLandingPageState();
}

class _UserDetailsLandingPageState extends State<UserDetailsLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/main-background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: BlurryContainer(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 34),
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.zero,
          elevation: 6,
          blur: 8,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                Navigator.pop(context);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                  child: Icon(Icons.arrow_back_ios),
                  onTap: () => Navigator.pop(context),
                ),
                Shimmer.fromColors(
                  period: Duration(milliseconds: 3000),
                  baseColor: Colors.black,
                  highlightColor: Colors.white.withOpacity(0.85),
                  child: Text(
                    "Desliza o pulsa la flecha para volver",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              ],
            ),
          ),
        ),
        body: UserProfile(
          profile: widget.state.profile,
          posts: widget.state.posts,
          context: context,
          num: 3,
        ),
      ),
    );
  }
}
