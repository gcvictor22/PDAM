import 'package:flutter/material.dart';

class GradientSlideToAct extends StatefulWidget {
  final double width;
  final double height;
  final double iconSize;
  final double borderRadius;
  final dynamic text;
  final TextStyle? textStyle;
  final IconData? sliderButtonIcon;
  final Duration animationDuration;
  final VoidCallback onSubmit;
  final Gradient? gradient;
  final Color backgroundColor;
  final Icon? submittedIcon;
  final Icon dragableIcon;
  final Color? dragableIconBackgroundColor;
  final Widget? draggableWidget;

  GradientSlideToAct({
    Key? key,
    required this.onSubmit,
    this.width = 380,
    this.height = 52,
    this.iconSize = 22,
    this.borderRadius = 52,
    this.text,
    this.textStyle,
    this.dragableIconBackgroundColor,
    this.submittedIcon,
    this.draggableWidget,
    this.dragableIcon = const Icon(Icons.arrow_forward_ios),
    this.sliderButtonIcon,
    this.animationDuration = const Duration(milliseconds: 300),
    this.gradient,
    required this.backgroundColor,
  })  : assert(width != double.infinity, "width should not be equal infinity"),
        assert(iconSize <= height,
            "the size of the icon {iconSize} should be < height"),
        super(key: key);

  @override
  State<GradientSlideToAct> createState() => _GradientSlideToActState();
}

class _GradientSlideToActState extends State<GradientSlideToAct>
    with SingleTickerProviderStateMixin {
  double _position = 0;
  bool _submitted = false;
  bool _reset = false;

  @override
  Widget build(BuildContext context) {
    if (_reset) {
      _position = 0;
      _submitted = false;
      _reset = false;
    }

    double position_percent = _position / (widget.width - 2 * widget.height);

    return AnimatedContainer(
      duration: widget.animationDuration,
      height: widget.height,
      width: _submitted ? widget.height : widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        gradient: !_submitted ? null : widget.gradient,
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(52),
        child: _submitted
            ? widget.submittedIcon ??
                Icon(
                  Icons.done,
                  color: Colors.white,
                )
            : Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 70),
                          height: widget.height,
                          width: _position + widget.height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(52),
                            gradient: widget.gradient,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Opacity(
                      opacity:
                          1 - (position_percent > 1 ? 1 : position_percent),
                      child: Center(
                        child: widget.text,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    bottom: 0,
                    child: Row(
                      children: [
                        GestureDetector(
                          onPanUpdate: (details) async {
                            _position += details.delta.dx;
                            if (_position < 0) {
                              _position = 0;
                              setState(() {});
                            } else if (_position >=
                                (widget.width - widget.height - 20)) {
                              _position = widget.width - widget.height;
                              if (!_submitted) {
                                _submitted = true;
                                setState(() {});
                                widget.onSubmit();
                                Duration _dur =
                                    const Duration(milliseconds: 1000) +
                                        widget.animationDuration;
                                await Future.delayed(_dur);
                                _reset = true;
                                setState(() {});
                                return;
                              }
                              _submitted = true;
                              setState(() {});
                            }
                            setState(() {});
                          },
                          onPanEnd: (_) {
                            position_percent = 0;
                            _position = 0;
                            setState(() {});
                          },
                          child: AnimatedPadding(
                            duration: const Duration(milliseconds: 70),
                            padding: EdgeInsets.only(left: _position),
                            child: widget.draggableWidget ??
                                _draggableWidget(
                                  iconSize: widget.height,
                                  gradient: widget.gradient,
                                  dragableIconBackground:
                                      widget.dragableIconBackgroundColor,
                                  dragableIcon: widget.dragableIcon,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _draggableWidget extends StatelessWidget {
  final double iconSize;
  final Gradient? gradient;
  final Color? dragableIconBackground;
  final Icon dragableIcon;

  const _draggableWidget({
    Key? key,
    required this.iconSize,
    this.gradient,
    this.dragableIconBackground,
    required this.dragableIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: iconSize,
      width: iconSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(52),
        color: dragableIconBackground,
        gradient: dragableIconBackground != null ? null : gradient,
      ),
      alignment: Alignment.center,
      child: dragableIcon,
    );
  }
}
