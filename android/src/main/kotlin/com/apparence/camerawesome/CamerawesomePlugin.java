 package com.apparence.camerawesome;

 /**
  * CamerawesomePlugin
  * This plugin recquire android Lolipop version (21) as a min version in your Android's gradle build
  * */
 public class CamerawesomePlugin {

   public static final String TAG = CamerawesomePlugin.class.getName();

     private void setFrontFlashMode(boolean enable) {
         if (enable) {
             Window window = activity.getWindow();
             WindowManager.LayoutParams layout = window.getAttributes();
             layout.screenBrightness = 1F;
             window.setAttributes(layout);
         } else {
             Window window = activity.getWindow();
             WindowManager.LayoutParams layout = window.getAttributes();
             layout.screenBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE;
             window.setAttributes(layout);
         }
     }


 }
