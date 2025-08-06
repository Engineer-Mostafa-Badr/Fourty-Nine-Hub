import 'dart:io';

class FlutterProjectCleaner {
  // قائمة الأصول غير المستخدمة
  static const List<String> unreferencedAssets = [
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\current_new_message.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\ChatSounds\Message Notification.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\translations\ar.json~',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\translations\ar.json',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\translations\en.json',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\rings_sound.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\rings.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\translations\en.json~',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\filters\Ping Pong Minigame\hit.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\favorite_ad_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\favorite_main_category_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\favorite_sub_category_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\contact_us_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\my_ads_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\filters\Ping Pong Minigame\models\paddleandball.fbx',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\sign_out_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\share_app_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\settings_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\privacy_icon.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\Icon awesome-heart.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\filters\Ping Pong Minigame\preview.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\filters\Ping Pong Minigame\Ping_Pong.deepar',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\new_message.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\filters\Ping Pong Minigame\textures\paddle.jpeg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\filters\Ping Pong Minigame\scripts\pingpongscript.js',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\contact_us_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\settings_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\privacy_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\my_ads_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\share_app_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\favorite_sub_category_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\favorite_main_category_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\favorite_ad_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\dashbboard_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\wallet_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\settings\New folder\sign_out_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\lottie\haaha_reaction.json',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\arrow-down.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\doctor.jpg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\json\driver.json',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\cheetah.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\doctor_home_visit.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\doctor_clinic.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\doctor_call.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\car.jpg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\butterfly.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\elephant.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\lion.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\json\surahs.json',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\car_red.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\car_black.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\face_beauty_rosy.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\face_beauty_rosy.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\face_beauty_whiten.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\face_beauty_sharpen.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\face_beauty_smooth.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\face_beauty_sharpen.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\seat_lock.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\rocket.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_ethereal_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_female.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_deep_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_deep.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_harmonicMinor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_ethereal_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_female_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\super_gifts.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_ethereal.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_ethereal.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_crystalClear_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_deep_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_crystalClear.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_deep.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_female.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_crystalClear_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_cMajor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_harmonicMinor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_cMajor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_crystalClear.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_littleBoy.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_female_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_aMajor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_cMajor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_aMajor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_cMajor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_littleBoy_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_harmonicMinor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_aMajor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_aMajor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_none.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_male_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\facebookMessenger.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_robot_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_male.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_robot.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\face_beauty_rosy.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_littleGirl_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_optimusPrime_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_littleGirl.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_none_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_optimusPrime.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\face_beauty_sharpen.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_optimusPrime.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\face_beauty_whiten.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\face_beauty_smooth.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_littleBoy_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_none_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_robot.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_optimusPrime_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\filter.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\tupe1.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_none.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_littleBoypng.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_male_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_harmonicMinor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\voice_changer_robot_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\zoom_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_male.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_littleGirl_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\voice_changer_littleGirl.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\snake.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\seat_lock.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\seat_empty.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\seat_empty.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_valley.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_valley.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_smallRoom.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_rock.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_recordingStudio.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_smallRoom.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_popular.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_rock.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_none.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_recordingStudio.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_largeRoom.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\musicBox.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_popular.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_ktv.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_none.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_hall.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_largeRoom.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_gramophone.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_concert.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_ktv.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\comment_dots.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\reverb_preset_basement.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\mealImage.jpg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_hall.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_gramophone.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\marriage.jpg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\face_beauty_whiten.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_concert.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\map_image.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\2.0x\face_beauty_smooth.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\3.0x\reverb_preset_basement.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\IdeaIcon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\instagram_share_post_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\instagram_favourite_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\instagram_comment_icon_dark.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\instagram_comment_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\google_pin.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\health_nursing.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\multi_group.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\pickMeIcon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\platform-tools-latest-windows.zip',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\ride_from.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\ride_to.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\seat_lock.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\seat_empty.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\send2.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_cMajor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_aMajor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_cMajor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_aMajor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\visa_icon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_crystalClear_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_crystalClear.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_deep.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_harmonicMinor_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_littleBoy.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_optimusPrime_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_robot.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_robot_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_optimusPrime.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_none_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_none.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_male_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_male.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_littleGirl_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_littleGirl.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_littleBoy_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_harmonicMinor.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_female_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_female.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_ethereal_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_ethereal.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\voice_changer_deep_selected.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_valley.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_smallRoom.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_rock.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_recordingStudio.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_popular.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_none.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_largeRoom.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_ktv.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_hall.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_gramophone.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_concert.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\reverb_preset_basement.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\icons\like.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\health_ear.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\gift.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\flower.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\json\offers.json',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\ellipseIcon.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\audioTrack.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\images\ahmed.jpg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49 Notification 01.mp3',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Capture1.PNG',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Group 31.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Group 8.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Group 3.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\reels.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\video_outlined.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Untitled-1-01.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\seen.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\remove_friend.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\person.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\notification.svg',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Icon awesome-heart.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Icon awesome-heart-1.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Group 2.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\Group 10.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\friends.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\chat_meeting.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\chat_2.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\audio_off.png',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\assets\49-New-icons\add_friend.png',
  ];

  // قائمة ملفات Dart غير المستخدمة
  static const List<String> unreferencedDartFiles = [
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\zoom\presentation\widgets\meeting_participants.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\zoom\data\model\room_response_error_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\zoom\presentation\controller\signal_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\zoom\presentation\widgets\custom_avatar_builder.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\tiktok\tiktok.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\subscripe\presentation\widgets\wallets.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\instagram_for_you_slider_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\instagram_comment_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\instagram_ad_slider_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\twitter\domain\entities\category_report_entity.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\twitter\domain\usecases\get_comment_replies_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\instagram_posts.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\instagram_global_posts.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\instagram_video_post_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\post_ad_instagram.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\widgets\show_comment_sheet_instgram.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\twitter\data\models\twitter_comment_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\presentation\widgets\tinder_sub_category_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\presentation\widgets\tinder_person_options_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\presentation\widgets\tinder_person_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\stories\presentation\pages\new_story_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\presentation\widgets\show_user_in_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\data\repo\tinder_repo.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\data\shared\tinder_shared_utils.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\tinder\data\models\send_gift_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\social_posts\presentation\pages\my_account_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\social_posts\presentation\pages\instagram_profile.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\social_posts\presentation\pages\api_error_page.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\social_posts\presentation\widgets\facebook_widgets\facebook_life_event_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\social_posts\presentation\widgets\facebook_widgets\build_people_you_may_know.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\spot_light\presentation\pages\locked_profile.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\reels\presentation\widgets\components\rounded_button_with_image.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\reels\presentation\widgets\components\heart_double_tap.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\reels\presentation\widgets\components\advanced_chewie_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\reels\presentation\pages\tiktok_option_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\reels\presentation\pages\all_location_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\snap\presentation\widget\top_bar_snap.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\snap\presentation\widget\snap_empgy.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\snap\presentation\widget\filtered_image_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\snap\data\model\filter_data.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_uikit\src\services\internal\internal.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_prebuilt_live_streaming\src\internal\internal.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_prebuilt_live_streaming\src\core\pk_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_prebuilt_live_streaming\src\core\co_host_control_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_prebuilt_live_streaming\src\components\minimized_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_prebuilt_live_streaming\src\components\message\disable_chat_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_prebuilt_live_streaming\src\components\dynamic_progress_indicator.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\live_streaming\presentation\widgets\components\zego_uikit\src\components\internal\internal.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\create_post\presentation\widgets\build_search_places.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\create_post\presentation\widgets\build_options.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_room\presentation\widgets\widgets_contacts\view_contact_chat_lock_cart.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_room\presentation\widgets\widgets_contacts\create_group_with_contact_cart.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_room\presentation\widgets\widgets_contacts\common_group_cart.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_room\presentation\widgets\masseges_list_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_room\presentation\widgets\camera_picker\images_and_videos_slider.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_room\presentation\widgets\chat_room_widgets\delete_message_body.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\view_all_pick_me\presentation\widgets\all_pick_me_body.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\view_all_pick_me\presentation\widgets\all_pickme_floating_action_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\view_all_trip_join\presentation\views\avaiable_trips_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\view_all_trip_join\presentation\views\Modified_widgets\trip_join_map_section.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\presentation\views\widgets\trip_join_google_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\presentation\views\widgets\pick_me_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\presentation\views\widgets\on_boarding_trip.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\driver_phone_number.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\destination_text_field_and_find_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\illustration_image.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\destination_position_suggesstion.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\pick_date_time_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\upload_documents.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\trip_join_static_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\trip_join_notes.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\trip_join_google_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\start_text_field_and_find_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\starting_point_suggestion.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\seats_number.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\repeated_check_box.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_trip_join\presentation\views\widgets\card_title_and_info.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_pick_me\presentation\widgets\welcome_text_dont_own_car.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\club_house\presentation\widgets\comment.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_pick_me\presentation\widgets\user_trip_options.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_pick_me\presentation\widgets\help_tooltip.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_pick_me\presentation\widgets\country_dropDown.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\trip_join\add_new_pick_me\presentation\widgets\add_new_pick_me_body.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\club_house\presentation\widgets\roomInfo.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\club_house\presentation\widgets\report_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\search\data\model\post_search_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\search\presentation\pages\widget\carpool_search_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\search\presentation\pages\widget\build_item_reel_details.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\search\presentation\pages\widget\build_item_post_search.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\search\presentation\pages\widget\build_item_carpool_search.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\cubit\register_shipping_cubit.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\widgets\from_and_to_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\widgets\create_shipping_governorate_dropdown.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\pages\request_detials_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\pages\my_rating_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\pages\edit_driver_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\pages\driver_requests.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\presentation\pages\your_trips_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\shipping\create_shipping_request\data\models\info_documents_model\info_documents_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\filter_ads\presentation\pages\widgets\custom_text_field.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\create_company_ad\presentation\pages\widgets\show_post_company_advertise.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\create_company_ad\presentation\pages\widgets\custom_container.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\create_company_ad\data\models\company_price_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\loading_trip_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\pickup_location_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\payment_method_bottom_sheet_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\partial_payment_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\gradient_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\country_dropdown.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\dialog_widget\wrong_otp_dialog.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\dialog_widget\why_do_have_cancel_dialog.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\widgets\dialog_widget\client_cancel_trip_dialog.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\presentation\pages\receipt_trip_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\domain\usecases\get_drivers_in_subcategory_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\domain\usecases\get_all_history_trips_for_user.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\domain\usecases\delete_ride_registeration_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\domain\usecases\dashboards\listen_to_client_coming_use_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\domain\usecases\check_driver_type_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\data\models\dashboards\setting_subcategory_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\RideFeature\data\models\dashboards\driver_details_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\trip_details\presentation\widgets\cancel_reasons.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\update_driver_no_socket_form.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\tom_tom_tracking.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\shipping_banner_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\rider_google_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\rider_banner_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\open_route_tracking.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\mapbox_tracking.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\id_front_image_register_card_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\governorates_ride_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\google_map_view_addres.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\google_map_tracking.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\customer\offers\offers.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\customer\createOrder\options_bottom_sheet.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\customer\createOrder\categoryInfo.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\presentation\widgets\car_info_rider.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\domain\usecases\request\get_ride_sub_categories_use_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\data\models\request_socket_response\request_socket_response.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\RideRequest\data\models\offer_data_model\offer_data_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\offers_ride\presentation\pages\offers_ride_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\driver_dashboard\presentation\widgets\driver_statistics_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\create_ad\presentation\widgets\select_sub_category.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\create_ad\presentation\widgets\select_main_category.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\vehicle_info_part_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\vehicle_info_parts_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\referral_code_part_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\VehcleParts\registeration_plate_part_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\VehcleParts\picture_part_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\VehcleParts\id_part_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\VehcleParts\certificate_of_vehicle_registeration.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\presentation\screens\VehcleParts\brand_part_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\data\models\vehicle_info_part_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ride\Authentication\data\models\referral_code_part_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\ad_requests\data\models\ad_request_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\pages\create_post_details_instagram_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\requests_history\domain\usecases\get_history_ride_use_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\instagram\presentation\pages\tag_people_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\requests_history\domain\entities\shipping_request_entity.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\ad_details\presentation\pages\widgets\lable_and_text_marriage_details.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\requests_history\data\models\shipping_request_model\is_user_rate.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\requests_history\data\models\shipping_request_model\driver_ratings_virtual.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\ads\presentation\widgets\user_filter_ads.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\ads\presentation\widgets\filter_button_item.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\ads\data\models\detail_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\ads_feature\ads\data\models\ad_selection_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\quraan\domain\entity\surah.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\quraan\presentation\pages\quran_page.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\quraan\presentation\pages\widget\basmallah.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\register\driver_register\presentation\pages\taps\upload_national_id.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\payment\data\models\fawry_save_card_token_response_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\payment\data\models\multi_payment_response_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\payment\data\models\paymob_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\payment\data\models\mutli_payment_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\payment\domain\entities\fawry_save_card_token_entity.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\register\driver_register\presentation\pages\taps\upload_car_license_images.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\register\driver_register\presentation\pages\taps\thank_you.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\reels\presentation\screen\new_real_screen.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\edit_profile\presentation\widgets\privact_icon.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_view\domain\usecases\get_groups_use_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\notifications\data\models\notification_pagination_params_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\notifications\data\models\delete_notification_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\new_trip_join\presentation\view\widget\route_button_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\new_trip_join\presentation\view\widget\new_route_text_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\notifications\data\models\notification_model\metadata.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\register\driver_register\data\datasources\rider_register_remote_data_source.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\register\driver_register\data\repositories\rider_register_repo_impl.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\installment_feature\installments\presentation\widgets\public\vendor_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\installment_feature\installments\presentation\widgets\public\product_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\pages\Specialities_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\pages\governorate_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\pages\emergeny_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\pages\emergency_doctor_list_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\widgets\doctor_dashboard_banner.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\pages\doctor_list_home_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\widgets\dialog\show_health_dialog.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\pages\cities_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\widgets\cards\favourite_ads_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\presentation\widgets\cards\custom_search_health.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\health\domain\usecases\get_category_favorite_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\doctor_details\domain\entities\premium_doctor_rate.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\doctor_details\domain\entities\doctor_specialization_entity.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\doctor_details\presentation\widgets\waiting.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\doctor_details\presentation\widgets\time_watch.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\doctor_details\presentation\widgets\call_launchURLHelper.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\doctor_details\data\models\doctor_detail_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\booking\presentation\pages\visita_booking.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\health_feature\create_doctor\domain\entities\doctor_locatoin.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\fourty_nine\presentation\widgets\register_options.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\fourty_nine\presentation\widgets\main_category_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\fourty_nine\presentation\widgets\custom_heart_button.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\fourty_nine\presentation\widgets\advertise_your_company.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\fourty_nine\presentation\widgets\ads_text_banner.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurant_details\presentation\widgets\cart_item_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurants_list\presentation\pages\user_order_request_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurants_list\presentation\pages\restaurant_for_meal.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurants_list\presentation\pages\widgets\resturant_dashboard_banner.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurants_list\presentation\pages\widgets\restaurant_list\resturant_dashboard_banner.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurants_list\presentation\cubit\meal_cubit\restaurants_meal_list_state.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_view\presentation\widgets\more_icon_bottom_sheet_body.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\social_media\chat\chat_view\presentation\widgets\social_chats_list_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurants_list\data\models\restaurant_2_model.g.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\edit_food\data\repositories\edit_food_repo_impl.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\food_cart\data\models\food_cart_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\custom_page\presentation\page\widget\sub_tab.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\custom_page\presentation\page\widget\navigator_subcategory_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\custom_page\presentation\page\widget\custom_page_category_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\custom_page\presentation\page\widget\custom_page_botton_nav_bar.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\avaliable_routes\domain\entities\available_routes_card_entity.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\avaliable_routes\data\data_source\get_accepted_trips_remote_data_source.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\avaliable_routes\presentation\widgets\map_box_location_test.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\test_poly_line_with_google_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\start_text_field_mapbox.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\start_here_text_field.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\open_route_service_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\map_for_mapBox.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\dest_text_field_mapbox.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\dest_text_field_here.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\presentation\widgets\carpool_google_map.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\carpool\add_new_route\data\models\map_box_search_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\chance_feature\presentation\widgets\card_details_widget_of_details_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\chance_feature\presentation\widgets\drop_down_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\call\widgets\minimized_call_app_bar_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\call\services\video_upgrade_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\call\services\temp_methods.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\call\services\remote_video_manager.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\call\presentation\pages\video_call.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\authentication\domain\use_cases\facebook_sign_in_use_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\authentication\domain\use_cases\get_wallet_use_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurant_dashboard\presentation\widgets\restaurant_order_card.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\wallet\presentation\widgets\semi_circle_indicator.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\wallet\presentation\pages\normal_wallet_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\wallet\presentation\pages\gift_wallet_view.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\wallet\data\models\wallet\main_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\transfer_money\presentation\pages\widgets\user_search_field.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\transfer_money\data\model\receiver_user_wallet_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\wallet\domain\usecases\get_competitions_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\wallet\domain\usecases\get_wallet_history_usecase.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\share_app\presentation\widgets\share_the_app_view_body.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\privacy\presentation\widgets\privacy_switch_item.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\lists\data\models\users_list_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\restaurant_details\data\models\selected_variation_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\food_feature\create_restaurant\views\widgets\mneu\name\food_name_text_form_field.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\account\presentation\pages\widgets\favourite_main_category_banner.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\account\data\models\toggle_favourite_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\account_taps\account\data\models\favourite_category_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\authentication\data\models\login_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\features\authentication\data\data_sources\remote_data_source\wallet_data_source.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\service_locator\theme_service_locator.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\helpers\social_login_helpers.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\widget\custom_expanded_input_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\widget\custom_drop_down.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\calendar_event.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\api_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\widget\expanded_input_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\states\basic_otp_state.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\date_helper.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\localization_helper.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\widget\request_buttons.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\custom_printer.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\pagination_controller.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\navigator_helper.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\connection_checker.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\widget\text_input\text_field_validation.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\widget\text_input\input_formats.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\utils\theme_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\share\uni_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\launcher_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\image_saver_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\download_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\share_img_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\background_service_record.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\app_info_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\exceptions\connection_exception.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\service\share_service.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\exceptions\meeting_exception.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\exceptions\exceed_file_size_limit_exception.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\exceptions\social_media_login_canceled_exception.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\order_reservation_status.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\file_size.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\provider_enum.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\post_type_enum.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\otp_status.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\otp_for.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\order_status.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\user_type.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\topic_type.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\theme_type.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\text_size.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\text_position.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\animations\moving_widget_hr.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\sort_type.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\request_result_enum.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\enums\address_type_enum.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\add_to_cart_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\about_you_response_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\datasources\device_type_data_source.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\about_you_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\key_value_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\intro_banner_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\id_name_model_snack_case.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\id_name_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\contact_us_message_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\datasources\remote\api\api_client_helper_imp.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\datasources\remote\api\interceptors\language_interceptor.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\datasources\remote\api\interceptors\auth_interceptor.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\times_options_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\shipping_methods_mode.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\product_service_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\product_details_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\data\models\payment_summary.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\ads\reward_ad_modle.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\abstract\base_cubit.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\stateless\images\profile_image_with_stories.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\stateful\dynamic\collabsable_info_widget.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\stateful\dynamic\webview.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\core\domain\repositories\click_counter_repository.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\stateless\appbar\widgets\unread_notifications_builder.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\statuses\form_submission_status.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\dynamic\google_ads_banner.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\other\show_snack_bar.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\form\text_fields\text_without_phone_text_field.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\models\public\state_model.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\form\text_fields\abstract\decimal_restriction.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\widgets\form\text_fields\new_text_form_filed.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\functions\global\upload_video.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\functions\global\capitalize_first_letter_of_words.dart',
    r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\lib\common\functions\helper\add_helper.dart',
  ];

  // قائمة التبعيات غير المستخدمة
  static const List<String> unreferencedDependencies = [
    'audio_video_progress_bar',
    'country_pickers',
    'cupertino_icons',
    'elegant_notification',
    'flutter_emoji',
    'flutter_osm_plugin',
    'geocoding_resolver',
    'google_fonts',
    'insta_image_viewer',
    'liquid_progress_indicator_v2',
    'multi_dropdown',
    'multi_select_flutter',
    'path_drawing',
    'transparent_image',
    'web_socket_channel',
    'webview_flutter_android',
    'widget_and_text_animator',
    'animated_notch_bottom_bar',
  ];

  // الطريقة الأولى: حذف الأصول غير المستخدمة
  static Future<void> deleteUnreferencedAssets() async {
    print('🗑️ بدء حذف الأصول غير المستخدمة...');
    int deletedCount = 0;
    int failedCount = 0;

    for (String assetPath in unreferencedAssets) {
      try {
        final file = File(assetPath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
          print('✅ تم حذف: ${file.path.split('\\').last}');
        } else {
          print('⚠️ الملف غير موجود: ${file.path.split('\\').last}');
        }
      } catch (e) {
        failedCount++;
        print('❌ فشل في حذف: ${assetPath.split('\\').last} - $e');
      }
    }

    print('\n📊 ملخص حذف الأصول:');
    print('   ✅ تم حذف: $deletedCount ملف');
    print('   ❌ فشل في الحذف: $failedCount ملف');
    print('   📁 إجمالي الأصول: ${unreferencedAssets.length} ملف');
  }

  // الطريقة الثانية: حذف ملفات Dart غير المستخدمة
  static Future<void> deleteUnreferencedDartFiles() async {
    print('🗑️ بدء حذف ملفات Dart غير المستخدمة...');
    int deletedCount = 0;
    int failedCount = 0;

    for (String dartPath in unreferencedDartFiles) {
      try {
        final file = File(dartPath);
        if (await file.exists()) {
          await file.delete();
          deletedCount++;
          print('✅ تم حذف: ${file.path.split('\\').last}');
        } else {
          print('⚠️ الملف غير موجود: ${file.path.split('\\').last}');
        }
      } catch (e) {
        failedCount++;
        print('❌ فشل في حذف: ${dartPath.split('\\').last} - $e');
      }
    }

    print('\n📊 ملخص حذف ملفات Dart:');
    print('   ✅ تم حذف: $deletedCount ملف');
    print('   ❌ فشل في الحذف: $failedCount ملف');
    print('   📁 إجمالي ملفات Dart: ${unreferencedDartFiles.length} ملف');
  }

  // الطريقة الثالثة: إزالة التبعيات غير المستخدمة من pubspec.yaml
  static Future<void> removeUnreferencedDependencies() async {
    print('🗑️ بدء إزالة التبعيات غير المستخدمة من pubspec.yaml...');

    const String pubspecPath =
        r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\pubspec.yaml';
    final file = File(pubspecPath);

    if (!await file.exists()) {
      print('❌ ملف pubspec.yaml غير موجود في المسار المحدد');
      return;
    }

    try {
      String content = await file.readAsString();
      String originalContent = content;
      int removedCount = 0;

      for (String dependency in unreferencedDependencies) {
        // البحث عن التبعية وإزالتها
        RegExp dependencyRegex =
            RegExp(r'^\s*' + dependency + r':.*$', multiLine: true);
        if (content.contains(dependencyRegex)) {
          content = content.replaceAll(dependencyRegex, '');
          removedCount++;
          print('✅ تم إزالة: $dependency');
        } else {
          print('⚠️ التبعية غير موجودة: $dependency');
        }
      }

      // إزالة الأسطر الفارغة الزائدة
      content = content.replaceAll(RegExp(r'\n\s*\n\s*\n'), '\n\n');

      if (content != originalContent) {
        await file.writeAsString(content);
        print('\n📊 ملخص إزالة التبعيات:');
        print('   ✅ تم إزالة: $removedCount تبعية');
        print(
            '   📁 إجمالي التبعيات: ${unreferencedDependencies.length} تبعية');
        print('   📝 تم تحديث pubspec.yaml بنجاح');
      } else {
        print('ℹ️ لم يتم العثور على أي تبعيات لإزالتها');
      }
    } catch (e) {
      print('❌ فشل في تعديل pubspec.yaml: $e');
    }
  }

  // طريقة شاملة لتنظيف المشروع بالكامل
  static Future<void> cleanEntireProject() async {
    print('🧹 بدء تنظيف المشروع بالكامل...\n');

    final stopwatch = Stopwatch()..start();

    await deleteUnreferencedAssets();
    print('\n' + '=' * 50 + '\n');

    await deleteUnreferencedDartFiles();
    print('\n' + '=' * 50 + '\n');

    await removeUnreferencedDependencies();

    stopwatch.stop();

    print('\n🎉 تم الانتهاء من تنظيف المشروع!');
    print('⏱️ الوقت المستغرق: ${stopwatch.elapsed.inSeconds} ثانية');
    print('\n💡 نصائح:');
    print('   1. قم بتشغيل "flutter pub get" لتحديث التبعيات');
    print('   2. قم بتشغيل "flutter clean" لتنظيف ملفات البناء');
    print('   3. اختبر المشروع للتأكد من عدم وجود أخطاء');
  }

  // طريقة إنشاء نسخة احتياطية عادية قبل الحذف
  static Future<void> createBackup() async {
    print('💾 إنشاء نسخة احتياطية...');

    const String projectPath =
        r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app';
    final backupPath =
        '${projectPath}_backup_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final sourceDir = Directory(projectPath);
      final backupDir = Directory(backupPath);

      if (await sourceDir.exists()) {
        await _copyDirectory(sourceDir, backupDir);
        print('✅ تم إنشاء نسخة احتياطية في: $backupPath');
      }
    } catch (e) {
      print('❌ فشل في إنشاء النسخة الاحتياطية: $e');
    }
  }

  // طريقة إنشاء نسخة احتياطية منظمة قبل الحذف
  static Future<void> createOrganizedBackup() async {
    print('💾 إنشاء نسخة احتياطية منظمة...');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    const String projectPath =
        r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app';
    final backupBasePath = '${projectPath}_backup_$timestamp';

    try {
      // إنشاء المجلد الرئيسي للنسخة الاحتياطية
      final backupDir = Directory(backupBasePath);
      await backupDir.create(recursive: true);

      // إنشاء المجلدات الفرعية
      final assetsBackupDir = Directory('$backupBasePath/unreferencedAssets');
      final dartFilesBackupDir =
          Directory('$backupBasePath/unreferencedDartFiles');
      final dependenciesBackupDir =
          Directory('$backupBasePath/unreferencedDependencies');

      await assetsBackupDir.create(recursive: true);
      await dartFilesBackupDir.create(recursive: true);
      await dependenciesBackupDir.create(recursive: true);

      int totalBackedUp = 0;

      // نسخ الأصول غير المستخدمة
      print('📁 نسخ الأصول غير المستخدمة...');
      for (String assetPath in unreferencedAssets) {
        try {
          final file = File(assetPath);
          if (await file.exists()) {
            final fileName = file.path.split('\\').last;
            final backupFile = File('${assetsBackupDir.path}/$fileName');
            await file.copy(backupFile.path);
            totalBackedUp++;
            print('  ✅ نُسخ: $fileName');
          }
        } catch (e) {
          print('  ❌ فشل في نسخ: ${assetPath.split('\\').last} - $e');
        }
      }

      // نسخ ملفات Dart غير المستخدمة
      print('📁 نسخ ملفات Dart غير المستخدمة...');
      for (String dartPath in unreferencedDartFiles) {
        try {
          final file = File(dartPath);
          if (await file.exists()) {
            final fileName = file.path.split('\\').last;
            final backupFile = File('${dartFilesBackupDir.path}/$fileName');
            await file.copy(backupFile.path);
            totalBackedUp++;
            print('  ✅ نُسخ: $fileName');
          }
        } catch (e) {
          print('  ❌ فشل في نسخ: ${dartPath.split('\\').last} - $e');
        }
      }

      // نسخ معلومات التبعيات غير المستخدمة
      print('📁 حفظ معلومات التبعيات غير المستخدمة...');
      try {
        final dependenciesInfoFile =
            File('${dependenciesBackupDir.path}/unreferenced_dependencies.txt');
        final dependenciesContent = StringBuffer();

        dependenciesContent.writeln('# التبعيات غير المستخدمة');
        dependenciesContent
            .writeln('# تاريخ النسخة الاحتياطية: ${DateTime.now()}');
        dependenciesContent.writeln('# المشروع: $projectPath\n');

        for (String dependency in unreferencedDependencies) {
          dependenciesContent.writeln('- $dependency');
        }

        await dependenciesInfoFile
            .writeAsString(dependenciesContent.toString());

        // نسخ ملف pubspec.yaml الأصلي أيضاً
        const String pubspecPath =
            r'c:\Users\amaz8\OneDrive\Documents\Flutter Projects\49-mobile-app\pubspec.yaml';
        final pubspecFile = File(pubspecPath);
        if (await pubspecFile.exists()) {
          final backupPubspecFile =
              File('${dependenciesBackupDir.path}/pubspec_original.yaml');
          await pubspecFile.copy(backupPubspecFile.path);
          print('  ✅ نُسخ: pubspec.yaml');
          totalBackedUp++;
        }

        print('  ✅ تم حفظ معلومات التبعيات');
        totalBackedUp++;
      } catch (e) {
        print('  ❌ فشل في حفظ معلومات التبعيات: $e');
      }

      // إنشاء ملف تقرير شامل
      await _createBackupReport(backupBasePath, totalBackedUp);

      print('\n✅ تم إنشاء نسخة احتياطية منظمة بنجاح!');
      print('📂 مسار النسخة الاحتياطية: $backupBasePath');
      print('📊 إجمالي الملفات المنسوخة: $totalBackedUp');
    } catch (e) {
      print('❌ فشل في إنشاء النسخة الاحتياطية: $e');
    }
  }

  // طريقة إنشاء تقرير النسخة الاحتياطية
  static Future<void> _createBackupReport(
      String backupPath, int totalFiles) async {
    try {
      final reportFile = File('$backupPath/backup_report.txt');
      final report = StringBuffer();

      report.writeln('# تقرير النسخة الاحتياطية');
      report.writeln('# تاريخ الإنشاء: ${DateTime.now()}');
      report.writeln(
          '# المشروع: c:\\Users\\amaz8\\OneDrive\\Documents\\Flutter Projects\\49-mobile-app');
      report.writeln();

      report.writeln(
          '## الأصول غير المستخدمة (${unreferencedAssets.length} ملف):');
      for (String asset in unreferencedAssets) {
        report.writeln('- ${asset.split('\\').last}');
      }
      report.writeln();

      report.writeln(
          '## ملفات Dart غير المستخدمة (${unreferencedDartFiles.length} ملف):');
      for (String dartFile in unreferencedDartFiles) {
        report.writeln('- ${dartFile.split('\\').last}');
      }
      report.writeln();

      report.writeln(
          '## التبعيات غير المستخدمة (${unreferencedDependencies.length} تبعية):');
      for (String dependency in unreferencedDependencies) {
        report.writeln('- $dependency');
      }
      report.writeln();

      report.writeln('## ملخص:');
      report.writeln('- إجمالي الأصول: ${unreferencedAssets.length}');
      report.writeln('- إجمالي ملفات Dart: ${unreferencedDartFiles.length}');
      report.writeln('- إجمالي التبعيات: ${unreferencedDependencies.length}');
      report.writeln('- إجمالي الملفات المنسوخة: $totalFiles');

      await reportFile.writeAsString(report.toString());
      print('📋 تم إنشاء تقرير النسخة الاحتياطية');
    } catch (e) {
      print('❌ فشل في إنشاء تقرير النسخة الاحتياطية: $e');
    }
  }

  // طريقة شاملة لتنظيف المشروع بالكامل مع النسخة الاحتياطية المنظمة
  static Future<void> cleanEntireProjectWithOrganizedBackup() async {
    print('🧹 بدء تنظيف المشروع بالكامل مع النسخة الاحتياطية المنظمة...\n');

    final stopwatch = Stopwatch()..start();

    // إنشاء النسخة الاحتياطية المنظمة أولاً
    await createOrganizedBackup();
    print('\n' + '=' * 50 + '\n');

    // تنظيف المشروع
    await deleteUnreferencedAssets();
    print('\n' + '=' * 50 + '\n');

    await deleteUnreferencedDartFiles();
    print('\n' + '=' * 50 + '\n');

    await removeUnreferencedDependencies();

    stopwatch.stop();

    print('\n🎉 تم الانتهاء من تنظيف المشروع مع النسخة الاحتياطية المنظمة!');
    print('⏱️ الوقت المستغرق: ${stopwatch.elapsed.inSeconds} ثانية');
    print('\n💡 نصائح:');
    print('   1. قم بتشغيل "flutter pub get" لتحديث التبعيات');
    print('   2. قم بتشغيل "flutter clean" لتنظيف ملفات البناء');
    print('   3. اختبر المشروع للتأكد من عدم وجود أخطاء');
    print(
        '   4. يمكنك العثور على النسخة الاحتياطية المنظمة في المجلد المحدد أعلاه');
  }

  // طريقة مساعدة لنسخ المجلدات
  static Future<void> _copyDirectory(
      Directory source, Directory destination) async {
    await destination.create(recursive: true);

    await for (final entity in source.list(recursive: false)) {
      if (entity is Directory) {
        final newDirectory =
            Directory('${destination.path}/${entity.path.split('\\').last}');
        await _copyDirectory(entity, newDirectory);
      } else if (entity is File) {
        final newFile =
            File('${destination.path}/${entity.path.split('\\').last}');
        await entity.copy(newFile.path);
      }
    }
  }
}

// الدالة الرئيسية
void main() async {
  print('🚀 مرحباً بك في أداة تنظيف مشروع Flutter!\n');

  print('اختر العملية التي تريد تنفيذها:');
  print('1. حذف الأصول غير المستخدمة فقط');
  print('2. حذف ملفات Dart غير المستخدمة فقط');
  print('3. إزالة التبعيات غير المستخدمة فقط');
  print('4. تنظيف المشروع بالكامل');
  print('5. إنشاء نسخة احتياطية عادية ثم التنظيف الكامل');
  print('6. إنشاء نسخة احتياطية منظمة ثم التنظيف الكامل');
  print('7. إنشاء نسخة احتياطية منظمة فقط');
  print('\nأدخل رقم اختيارك (1-7):');

  // محاكاة إدخال المستخدم - يمكنك تغيير هذا الرقم
  const int choice = 6; // تغيير هذا الرقم حسب الحاجة

  switch (choice) {
    case 1:
      await FlutterProjectCleaner.deleteUnreferencedAssets();
      break;
    case 2:
      await FlutterProjectCleaner.deleteUnreferencedDartFiles();
      break;
    case 3:
      await FlutterProjectCleaner.removeUnreferencedDependencies();
      break;
    case 4:
      await FlutterProjectCleaner.cleanEntireProject();
      break;
    case 5:
      await FlutterProjectCleaner.createBackup();
      await FlutterProjectCleaner.cleanEntireProject();
      break;
    case 6:
      await FlutterProjectCleaner.cleanEntireProjectWithOrganizedBackup();
      break;
    case 7:
      await FlutterProjectCleaner.createOrganizedBackup();
      break;
    default:
      print('❌ اختيار غير صحيح!');
  }
}
