import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/src/widgets/utils/awesome_circle_icon.dart';
import 'package:camerawesome/src/widgets/utils/awesome_theme.dart';
import 'package:flutter/material.dart';

import 'package:camerawesome/src/orchestrator/models/camera_flashes.dart';
import 'package:camerawesome/src/orchestrator/models/sensor_config.dart';
import 'package:camerawesome/src/orchestrator/states/camera_state.dart';
import 'package:camerawesome/src/widgets/utils/awesome_oriented_widget.dart';

Sensor mySensor = Sensor.position(SensorPosition.front);

class AwesomeFlashButton extends StatelessWidget {
  final CameraState state;
  final AwesomeTheme? theme;
  final Widget Function(FlashMode) iconBuilder;
  final void Function(SensorConfig, FlashMode) onFlashTap;

  AwesomeFlashButton({
    super.key,
    required this.state,
    this.theme,
    Widget Function(FlashMode)? iconBuilder,
    void Function(SensorConfig, FlashMode)? onFlashTap,
  })  : iconBuilder = iconBuilder ??
            ((flashMode) {
              // Check if the sensor position is front
              if (mySensor.sensorPosition == SensorPosition.front) {
                // Always return the flash_on icon for front camera
                return AwesomeCircleWidget.icon(
                  icon: Icons.flash_on,
                  theme: theme,
                );
              } else {
                // Original logic for other cases
                final IconData icon;
                switch (flashMode) {
                  case FlashMode.none:
                    icon = Icons.flash_off;
                    break;
                  case FlashMode.on:
                    icon = Icons.flash_on;
                    break;
                  case FlashMode.auto:
                    icon = Icons.flash_auto;
                    break;
                }
                return AwesomeCircleWidget.icon(
                  icon: icon,
                  theme: theme,
                );
              }
            }),
        onFlashTap = onFlashTap ??
            ((sensorConfig, flashMode) {
              if (mySensor.sensorPosition == SensorPosition.front) {
                sensorConfig.setFlashMode(FlashMode.on);
              } else {
                sensorConfig.switchCameraFlash();
              }
            });

  @override
  Widget build(BuildContext context) {
    final theme = this.theme ?? AwesomeThemeProvider.of(context).theme;
    return StreamBuilder<SensorConfig>(
      stream: state.sensorConfig$,
      builder: (_, sensorConfigSnapshot) {
        if (!sensorConfigSnapshot.hasData) {
          return const SizedBox.shrink();
        }
        final sensorConfig = sensorConfigSnapshot.requireData;
        return StreamBuilder<FlashMode>(
          stream: sensorConfig.flashMode$,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            return AwesomeOrientedWidget(
              rotateWithDevice: theme.buttonTheme.rotateWithCamera,
              child: theme.buttonTheme.buttonBuilder(
                iconBuilder(snapshot.requireData),
                () => onFlashTap(sensorConfig, snapshot.requireData),
              ),
            );
          },
        );
      },
    );
  }
}
