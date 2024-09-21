// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();

  static const HOME = '/';
  static const MAINCATEGORIESCARDS = '/MainCategoriesCards';
  static const MAINCATEGORIESTREE = '/MainCategoriesTree';
  static const SUBCATEGORIES = '/Subcategories';
  static const ADS = '/Subcategories/ADS';
  static const ADdetails = '/Subcategories/ADS/AD-Details';
  static const CREATEAD = '/Subcategories/ADS/CreateAd';
  static const CREATECOMPANYAD = '/Subcategories/ADS/CreateCompanyAd';
  // static const CAMERA

  static const LUCKYWHEEL = '/LuckyWheel';
  static const COMPETITIONS = '/Competitions';
  static const WINNERS = '/Winners';
  static const WALLET = '/Wallet';
  static const WALLETHISTORY = '/Wallet/WalletHistory';
  static const TRANSFERMONEY = '/Wallet/TransferMoney';
  static const SOCIAL = '/Social';
  static const OTHERSACCOUNT = '/Social/OthersAccount';
  static const INSTAGRAMPROFILE = '/Instagram/InstagramProfile';
  static const EDITPROFILE = '/Social/OthersAccount/EditProfile';
  static const REELS = '/Social/REELS';
  static const MUSICREELS = '/Social/REELS/MUSICREELS';
  static const TWITTER = '/Social/Twitter';
  static const TWITTERPOSTDETAILS = '/Social/Twitter/TwitterPostDetails';
  static const CREATEPOST = '/Social/CreatePost';
  static const SEARCHFRIENDS = '/Social/CreatePost/SearchFriend';
  static const SEARCHPLACES = '/Social/CreatePost/SearchPlaces';

  static const Tinder = '/Social/Tinder';
  static const LIVE = '/Social/Live';
  static const LIVEView = '/Social/Live/LiveView';
  static const CLUBHOUSE = '/Social/ClubHouse';
  static const CLUBHOUSECHAT = '/Social/ClubHouse/ClubHouseChat';
  static const AUDIOSTREAMSCREEN = '/Social/ClubHouse/ClubHouseRoom';
  static const CHAT = '/Chat';
  static const CHATROOM = '/ChatRoom';
  static const CHATROOMCAMERAPICKER = '/ChatRoom/CameraPicker';
  static const MEDIASLIDER = '/ChatRoom/MediaSlider';
  static const VIEWCONTACT = '/ChatRoom/ViewContact';
  static const IMAGESPAGEVIEW = '/ImagesPageView';
  static const SHOWIMAGEVIEW = '/ShowImagesView';
  static const CHATPROFILEVIEW = '/ChatProfileView';
  static const ATTACHMENTSVIEW = '/ChatRoom/AttachmentsView';
  static const SELECTCONTACTSTOSHARE = '/ChatRoom/SelectContactsToShareView';
  static const CONTACTSVIEW = '/ContactsView';
  static const MAZADAT = '/Mazadat';
  static const VISITA = '/Visita';
  static const VISITAEMERGENCY = '/Visita/VisitaEmergency';
  static const CREATEDOCTOR = '/Visita/CreateDoctor';
  static const FILTERDOCTORSUBCATEGORY = '/Visita/FilterDoctorSubcategory';
  static const FILTERDOCTORAREA =
      '/Visita/FilterDoctorSubcategory/FilterDoctorCity/FilterDoctorArea';
  static const VISITADOCTORLISTBYLOCATION =
      '/Visita/FilterDoctorSubcategory/FilterDoctorGovernorate/FilterDoctorCity/VisitaDoctorsList';
  static const VISITADOCTORLISTBYCALL =
      '/Visita/FilterDoctorSubcategory/VisitaDoctorsList';
  static const FILTERDOCTORGOVERNORATE = '/Visita/FilterDoctorGovernorate';

  static const FILTERDOCTORCITY = '/Visita/FilterDoctorCity';

  static const VISITADOCTORLIST = '/Visita/VisitaDoctorsList';
  static const EDITDOCTORPROFILE = '/Visita/EditDoctorProfile';
  static const VISITADOCTORDETAILS = '/Visita/DoctorDetails';
  static const VISITABOOKING = '/Visita/VisitaBooking';
  static const DOCTORDASHBOARD = '/Visita/DoctorDashboard';
  static const EDITDOCTORPERSONALINFO = '/Visita/EditDoctorPersonalInfo';
  static const DOCTORSTATISTICS = '/Visita/DoctorStatistics';
  static const DOCTORTODAYAPPOINTMENTS = '/Visita/DoctorTodayAppointments';
  static const DOCTORUNHANDLEDAPPOINTMENTS =
      '/Visita/DoctorUnhandledAppointments';
  static const ALLDOCTORRESERVATIONS = '/Visita/AllDoctorReservations';
  static const FOOD = '/Food';

  static const RESTAURANTDETAILS = '/Food/RetaurantDetails';
  static const CusineRestaurants = '/Food/Cusine-Restaurants';
  static const SEARCHMEALS = '/Food/SearchMeals';
  static const RestaurantDashboard = '/Food/RestaurantDashboard';
  static const CREATERESTURANT = '/Food/CreateResturant';

  static const FOODCART = '/Food/RetaurantDetails/FoodCart';
  static const SHIPPING = '/Shipping';
  static const SHIPPING_REGISTER = '/shippingRegister';
  static const RIDE = '/Ride';
  static const CONTACTUS = '/ContactUs';

  static const RIDERDASHBOARD = '/Ride/RiderDashboard';

  static const TRIPDETAILS = '/Ride/TripDetails';
  static const REQUESTSHISTORY = '/Ride/RequestsHistory';
  static const YOUTUBE = '/Youtube';
  static const QURAAN = '/Quraan';
  static const AZKAAR = '/Azkaar';
  static const PLAYVIDEO = '/Youtube/PlayVideo';

  static const MAZADDETAILS = '/Mazadat/MazadDetails';
  static const CREATEAUCTION = '/Mazadat/CreateAuction';

  static const INSTAGRAM = '/Instagram';
  static const ZOOM = '/Zoom';
  static const MEETINGROOM = '/Zoom/MeetingRoom';
  static const CALLSCREEN = '/Zoom/CallScreen';
  static const JOINSCREEN = '/Zoom/JoinScreen';
  static const INSTALLMENT = '/Installment';
  static const CREATEINSTALLMENT = '/Installment/CreateInstallment';
  static const INSTALLMENTDETAILS = '/Installment/Installment-details';
  static const INSTALLMENTORDERDETAILS =
      '/Installment/Installment-order-details';
  static const INSTALLMENTORDERS = '/Installment/Installment-orders';
  static const LOGIN = '/Login';
  static const REGISTER = '/Register';
  static const FORGOTPASSWORD = '/ForgotPassword';
  static const FORGOTPASSWORDOTP = '/ForgotPassword/OTP';
  static const CREATENEWFORGOTPASSWORD = '/ForgotPassword/CreateNewPassword';
  static const VERIFYMAIL = '/Register/verify-mail-register';
  static const REGISTERDRIVER = '/Register/register-driver';
  static const ACCOUNT = '/Account';
  static const PRIVACY = '/Account/Privacy';
  static const POLICY = '/Account/POLICY';

  static const Lists = '/Account/Lists';
  static const FAVOURITE = '/Account/Favourite';
  static const FAVOURITECATEGORIES = '/Account/FavouriteCategories';
  static const FAVOURITESUBCATEGORIES = '/Account/FavouriteSubCategories';
  static const MYADDS = '/Account/Myadds';
  static const SHAREAPP = '/Account/ShareApp';
  static const NOTIFICATIONS = '/Account/Norifications';
  static const SETTINGS = '/Account/Settings';
  static const PAYMENT = '/Payment';
  static const SUBSCRIPTIONPLANS = '/SubscriptionPlans';

  static const TRIP_JOIN = '/TripJoin';
  static const AVAILABLE_TRIPS = '/AvailableTrips';
  static const TRIP_JOIN_REQUEST_NOTIFICATIONS = '/TripJoinRequestNotification';

  static const SPOTLIGHT = '/Spotlight';
  static const SNAP = '/Snap';
  static const SEEALLBROADCASTS = '/SeeAllBroadcasts';
    static const BROADCAST = '/Broadcast';

}

abstract class Paths {
  Paths._();

  static const HOME = '/';
  static const MAINCATEGORIESCARDS = 'MainCategoriesCards';
  static const MAINCATEGORIESTREE = 'MainCategoriesTree';
  static const SUBCATEGORIES = 'Subcategories';
  static const ADS = 'ADS';
  static const ADdetails = 'AD-Details';
  static const CREATEAD = 'CreateAd';
  static const CREATECOMPANYAD = 'CreateCompanyAd';
  static const LUCKYWHEEL = 'LuckyWheel';
  static const COMPETITIONS = 'Competitions';
  static const WINNERS = 'Winners';
  static const WALLET = 'Wallet';
  static const WALLETHISTORY = 'WalletHistory';
  static const TRANSFERMONEY = 'TransferMoney';
  static const INSTAGRAM = 'Instagram';
  static const SOCIAL = 'Social';
  static const OTHERSACCOUNT = 'OthersAccount';
  static const INSTAGRAMPROFILE = 'InstagramProfile';
  static const MAZADAT = 'Mazadat';
  static const IMAGESPAGEVIEW = 'ImagesPageView';
  static const SHOWIMAGESVIEW = 'ShowImagesView';
  static const MAZADDETAILS = 'MazadDetails';
  static const CREATEAUCTION = 'CreateAuction';
  static const CHAT = 'Chat';
  static const CHATROOM = 'ChatRoom';
  static const VIEWCONTACT = 'ViewContact';
  static const ATTACHMENTSVIEW = 'AttachmentsView';
  static const CHATPROFILEVIEW = 'ChatProfileView';
  static const CHATROOMCAMERAPICKER = 'CameraPicker';
  static const MEDIASLIDER = 'MediaSlider';
  static const REELS = 'Reels';
  static const MUSICREELS = 'MUSICREELS';
  static const TWITTER = 'Twitter';
  static const TWITTERPOSTDETAILS = 'TwitterPostDetails';
  static const CREATEPOST = 'CreatePost';
  static const EDITPROFILE = 'EditProfile';
  static const SEARCHFRIENDS = 'SearchFriend';
  static const SEARCHPLACES = 'SearchPlaces';
  static const TINDER = 'Tinder';
  static const LIVE = 'Live';
  static const LIVEVIEW = 'LiveView';
  static const CLUBHOUSE = 'ClubHouse';
  static const CLUBHOUSECHAT = 'ClubHouseChat';
  static const CLUBHOUSEROOM = 'ClubHouseRoom';
  static const VISITA = 'Visita';
  static const VISITADOCTORLIST = 'VisitaDoctorsList';
  static const VISITAEMERGENCY = 'VisitaEmergency';
  static const VISITADOCTORDETAILS = 'DoctorDetails';
  static const VISITABOOKING = 'VisitaBooking';
  static const CREATEDOCTOR = 'CreateDoctor';
  static const EDITDOCTORPROFILE = 'EditDoctorProfile';
  static const FILTERDOCTORSUBCATEGORY = 'FilterDoctorSubcategory';
  static const FILTERDOCTORGOVERNORATE = 'FilterDoctorGovernorate';
  static const FILTERDOCTORCITY = 'FilterDoctorCity';
  static const FILTERDOCTORAREA = 'FilterDoctorArea';
  static const DOCTORDASHBOARD = 'DoctorDashboard';
  static const EDITDOCTORPERSONALINFO = 'EditDoctorPersonalInfo';
  static const DOCTORSTATISTICS = 'DoctorStatistics';
  static const DOCTORTODAYAPPOINTMENTS = 'DoctorTodayAppointments';
  static const DOCTORUNHANDLEDAPPOINTMENTS = 'DoctorUnhandledAppointments';
  static const ALLDOCTORRESERVATIONS = 'AllDoctorReservations';
  static const FOOD = 'Food';
  static const CREATERESTURANT = 'CreateResturant';
  static const CusineRestaurants = 'Cusine-Restaurants';
  static const RestaurantDashboard = 'RestaurantDashboard';
  static const SearchMeals = 'SearchMeals';
  static const SHIPPING = 'Shipping';
  static const SHIPPING_REGISTER = 'shippingRegister';
  static const CONTACTS_VIEW = 'ContactsView';

  static const RIDE = 'Ride';
  static const CONTACTUS = 'ContactUs';
  static const RIDERDASHBOARD = 'RiderDashboard';
  static const REQUESTSHISTORY = 'RequestsHistory';
  static const TRIPDETAILS = 'TripDetails';

  static const YOUTUBE = 'Youtube';
  static const RESTAURANTDETAILS = 'RetaurantDetails';
  static const FOODCART = 'FoodCart';

  static const PLAYVIDEO = 'PlayVideo';
  static const ZOOM = 'Zoom';
  static const MEETINGROOM = 'MeetingRoom';
  static const CALLSCREEN = 'CallScreen';
  static const JOINSCREEN = 'joinScreen';
  static const INSTALLMENT = 'Installment';
  static const CREATEINSTALLMENT = 'CreateInstallment';
  static const INSTALLMENTDETAILS = 'Installment-details';
  static const INSTALLMENTORDERDETAILS = 'Installment-order-details';
  static const INSTALLMENTORDERS = 'Installment-orders';
  static const LOGIN = 'Login';
  static const REGISTER = 'Register';
  static const FORGOTPASSWORD = 'ForgotPassword';
  static const FORGOTPASSWORDOTP = 'ForgotPasswordOTP';
  static const CREATENEWFORGOTPASSWORD = 'CreateNewPassword';
  static const VERIFYMAIL = 'verify-mail-register';
  static const REGISTERDRIVER = 'register-driver';
  static const ACCOUNT = 'Account';
  static const PRIVACY = 'Privacy';
  static const POLICY = 'Policy';

  static const Lists = 'Lists';
  static const FAVOURITE = 'Favourite';
  static const FAVOURITECATEGORIES = 'FavouriteCategories';
  static const FAVOURITESUBCATEGORIES = 'FavouriteSubCategories';

  static const MYADDS = 'Myadds';
  static const SHAREAPP = 'ShareApp';
  static const NOTIFICATIONS = 'Norifications';
  static const SETTINGS = 'Settings';
  static const QURAAN = 'Quraan';
  static const AZKAAR = 'Azkaar';
  static const PAYMENT = 'Payment';
  static const SUBSCRIPTIONPLANS = 'SubscriptionPlans';

  static const TRIP_JOIN = 'TripJoin';
  static const AVAILABLE_TRIPS = 'AvailableTrips';
  static const TRIP_JOIN_REQUEST_NOTIFICATIONS = 'TripJoinRequestNotification';

  static const SPOTLIGHT = 'Spotlight';
  static const SNAP = 'Snap';

  static const SELECTCONTACTSTOSHARE = 'SelectContactsToShareView';

  static const SEEALLBROADCASTS = 'SeeAllBroadcasts';

  static const BROADCAST = 'Broadcast';
}
