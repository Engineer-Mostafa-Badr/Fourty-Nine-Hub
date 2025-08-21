// ignore_for_file: constant_identifier_names

abstract class Routes {
  Routes._();

  // static const splash = '/';
  static const HOME = '/';
  static const RIDE_HOME = '/RideHome';
  static const onBoardingScreen = '/OnBoardingScreen';
  static const ChooseLangScreen = '/ChooseLangScreen';
  static const FirstLoginScreen = '/FirstLoginScreen';
  static const CompleteRegisterWelcomeScreen = '/CompleteRegisterWelcomeScreen';
  static const MY_TALENT = '/MyTalent';
  static const CUSTOMPAGE = '/CustomPage';
  static const editPage = '/editPage';
  static const RIDEACTIVITY = '/RIDEACTIVITY';
  static const RIDEOPENSTREETMAPSEARCHANDPICK =
      '/RIDEOPENSTREETMAPSEARCHANDPICK';
  static const GoogleMapsSearchAndPick =
      '/GoogleMapsSearchAndPick';
  static const RIDERUNNINGTRIPS = '/RIDERUNNINGTRIPS';
  static const RIDEEXPIREDTRIPE = '/RIDEEXPIREDTRIPS';
  static const RIDEHISTORYTRIPS = '/RIDEHISTORYTRIPS';
  static const RIDEDETAILSTRIPS = '/RIDEDETAILSTRIPS';
  static const TripReceiptScreen = '/TripReceiptScreen';
  static const PAGEPREVIEW = '/CustomPage/PagePreview';
  static const MAINCATEGORIESCARDS = '/MainCategoriesCards';
  static const SEARCH = '/Search';
  static const UploadRiderImages = '/UploadRiderImages';
  static const RESTAURANTORDERS = '/RestaurantOrders';
  static const EditFoodView = '/EditFoodView';
  static const MAINCATEGORIESTREE = '/MainCategoriesTree';
  static const SUBCATEGORIES = '/Subcategories';
  static const CustomPageSubCategoriesView = '/CustomPageSubCategoriesView';
  static const NavigatorSubCategoriesView = '/NavigatorSubCategoriesView';
  static const MARRIAGESUBCATEGORIES = '/MarriageSubcategories';
  static const ADS = '/Subcategories/ADS';
  static const FILTERADS = '/Subcategories/ADS/FilterAds';
  static const GOVERNORATEFILTERADS = '/Subcategories/ADS/GovernorateFilterAds';
  static const ADdetails = '/Subcategories/ADS/AD-Details';
  static const ADRequests = '/Subcategories/ADS/AD-Details/AD-Requests';
  static const CREATEAD = '/Subcategories/ADS/CreateAd';
  static const CREATECOMPANYAD = '/Subcategories/ADS/CreateCompanyAd';
  static const CREATECOMPANYPOSTAD = '/Subcategories/ADS/CreatePostCompany';
  static const CREATECOMPANYPOSTREALAD = '/Subcategories/ADS/CreatePostRealCompany';

  // static const CAMERA

  static const LUCKYWHEEL = '/LuckyWheel';
  static const COMPETITIONS = '/Competitions';
  static const WINNERS = '/Winners';
  static const WINNERSCASHBACK = '/WinnersCashback';
  static const WINNERSGift = '/WinnersGift';
  static const WALLET = '/Wallet';
  static const BALANCE = '/Balance';
  static const GIFT = '/Gift';
  static const WALLETHISTORY = '/Wallet/WalletHistory';
  static const TRANSFERMONEY = '/Wallet/TransferMoney';
  static const SOCIAL = '/Social';
  static const FacebookSuggestPeople = '/Social/FacebookSuggestPeople';
  static const OTHERSACCOUNT = '/Social/OthersAccount';
  static const EDITPROFILE = '/Social/OthersAccount/EditProfile';
  static const REELS = '/Social/REELS';
  static const MUSICREELS = '/Social/REELS/MUSICREELS';
  static const AllLocationScreen = '/AllLocationScreen';
  static const TiktokOptionScreen = '/TiktokOptionScreen';

  static const TWITTER = '/Social/Twitter';
  static const TWITTERPOSTDETAILS = '/Social/TwitterPostDetails';
  static const CREATEPOST = '/Social/CreatePost';
  static const POSTDETAILS = '/PostDetails';
  static const SEARCHFRIENDS = '/Social/CreatePost/SearchFriend';
  static const SEARCHPLACES = '/Social/CreatePost/SearchPlaces';

  static const Tinder = '/Social/Tinder';
  static const UserProfilePage = '/Social/UserProfilePage';
  static const FindMyProfileScreen = '/Social/FindMyProfileScreen';
  static const EditProfileTinder = '/Social/EditProfileTinder';
  static const LIVE = '/Social/Live';
  static const LIVEView = '/Social/Live/LiveView';
  static const CLUBHOUSE = '/Social/ClubHouse';
  static const CLUBHOUSECHAT = '/Social/ClubHouse/ClubHouseChat';
  static const AUDIOSTREAMSCREEN = '/Social/ClubHouse/ClubHouseRoom';
  static const CHAT = '/Chat';
  static const CHATROOM = '/ChatRoom';
  static const ARCHIVEDCHATS = '/ArchivedChatsView';
  static const CHATROOMCAMERAPICKER = '/ChatRoom/CameraPicker';
  static const MEDIASLIDER = '/ChatRoom/MediaSlider';
  static const ONETIMEVOICEMESSAGE = '/OneTimeVoiceMessageView';
  static const ONETIMEDOCUMENTMESSAGE = '/OneTimeDocumentMessageView';
  static const FORWARDMESSAGES = '/ForwardMessagesView';
  static const VIEWCONTACT = '/ChatRoom/ViewContact';
  static const IMAGESPAGEVIEW = '/ImagesPageView';
  static const SHOWIMAGEVIEW = '/ShowImagesView';
  static const CHATPROFILEVIEW = '/ChatProfileView';
  static const ATTACHMENTSVIEW = '/ChatRoom/AttachmentsView';
  static const SELECTCONTACTSTOSHARE = '/ChatRoom/SelectContactsToShareView';
  static const CONTACTSVIEW = '/ContactsView';
  static const MAZADAT = '/Mazadat';
  static const VISITA = '/Visita';
  static const EMERGENCYREQUESTS = '/Visita/EmergencyRequests';
  static const ALLAPPOINTMENTS = '/Visita/AllAppointments';
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
  static const SUCCESSFULLBOOKING = 'SucessfullBooking';
  static const DOCTORDASHBOARD = '/Visita/DoctorDashboard';
  static const EDITDOCTORPERSONALINFO = '/Visita/EditDoctorPersonalInfo';
  static const EDITDOCTORTIMETABLE = '/Visita/EditDoctorTimeTable';
  static const DOCTORSTATISTICS = '/Visita/DoctorStatistics';
  static const DOCTORREVIEWS = '/Visita/DoctorReviews';
  static const AllDOCTORREVIEWS = '/Visita/AllDoctorReviews';
  static const DOCTORTODAYAPPOINTMENTS = '/Visita/DoctorTodayAppointments';
  static const DOCTORUNHANDLEDAPPOINTMENTS =
      '/Visita/DoctorUnhandledAppointments';
  static const ALLDOCTORRESERVATIONS = '/Visita/AllDoctorReservations';
  static const FOOD = '/Food';
  static const LIFEEVENT = '/Social/LIFEEVENT';
  static const CREATELIFEEVENT = '/Social/CREATELIFEEVENT';
  static const LIFEEVENTSub = '/Social/LIFEEVENTSub';

  static const RESTAURANTDETAILS = '/Food/RetaurantDetails';
  static const CusineRestaurants = '/Food/Cusine-Restaurants';
  static const SEARCHMEALS = '/Food/SearchMeals';
  static const RestaurantDashboard = '/RestaurantDashboard';
  static const RestaurantOrders = '/RestaurantDashboard/RestaurantOrders';
  static const CREATERESTURANT = '/Food/CreateResturant';

  static const FOODCART = '/Food/RetaurantDetails/FoodCart';
  static const SHIPPING = '/Shipping';
  static const SHIPPING_REGISTER = '/shippingRegister';
  static const RIDE = '/Ride';
  static const CONTACTUS = '/ContactUs';

  static const RIDERDASHBOARD = '/Ride/RiderDashboard';
  static const RIDERREGISTER = '/Ride/RiderRegister';

  static const TRIPDETAILS = '/Ride/TripDetails';
  static const REQUESTSHISTORY = '/Ride/RequestsHistory';
  static const YOUTUBE = '/Youtube';
  static const QURAAN = '/Quraan';
  static const AZKAAR = '/Azkaar';
  static const AZKAARDETAILS = '/Azkaar/AZKAARDETAILS';
  static const PLAYVIDEO = '/Youtube/PlayVideo';

  static const MAZADDETAILS = '/Mazadat/MazadDetails';
  static const CREATEAUCTION = '/Mazadat/CreateAuction';

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
  static const EDITAD = '/Account/Myadds/EditAd';
  static const SHAREAPP = '/Account/ShareApp';
  static const NOTIFICATIONS = '/Account/Norifications';
  static const SETTINGS = '/Account/Settings';
  static const PAYMENT = '/Payment';
  static const SUBSCRIPTIONPLANS = '/SubscriptionPlans';
  static const DASHBOARDDRIVERSCREEN = '/DASHBOARDDRIVERSCREEN';
  static const ALLTRIPRIDER = '/Ride/ALLTRIPRIDER';
  static const DRIVERREQUESTSDETIALS = '/DRIVERREQUESTSDETIALS';
  static const MyRating = '/MyRating';
  static const TripRating = '/TripRating';
  static const EDITDRIVERSCREEN = '/EditDriver';

  static const TRIP_JOIN = '/TripJoin';
  static const BE_STAR = '/BeAStar';
  static const TenPercent = '/TenPercent';
  static const WinnersTenPercent = '/WinnersTenPercent';
  static const Married = '/Married';
  static const BE_STAR_DETAILS = '/BeAStar/BeAStarDetails';
  static const AVAILABLE_TRIPS = '/AvailableTrips';
  static const All_PickMe_View = '/AllPickMeView';
  static const TRIP_JOIN_REQUEST_NOTIFICATIONS = '/TripJoinRequestNotification';
  static const TRIP_JOIN_REQUEST_HISTORY = '/TripJoinRequestHistory';
  static const TRIP_JOIN_REQUEST_HISTORY_Pick_Me =
      '/TripJoinRequestHistoryPickMe';

  static const CAR_POOL = '/CarPool';
  static const ADD_NEW_ROUTE = '/AddNewRoute';

  static const SPOTLIGHT = '/Spotlight';
  static const SNAP = '/Snap';
  static const SEEALLBROADCASTS = '/SeeAllBroadcasts';
  static const BROADCAST = '/Broadcast';
  static const AddNewPickMe = "/AddNeWPickMe";
  static const TRIPINFOBYRIDERSCREEN = '/Ride/TripInfoByRiderScreen';
  static const TRIPINFOBYDRIVERSCREEN = '/Ride/TripInfoByDriverScreen';
  static const ALLTRIPNOSOCKETSCREEN = '/Ride/AllTripNoSocketScreen';
  static const TripRideRating = '/Ride/TripRideRating';

  static const updateDriverShipping = '/Ride/updateDriverShipping';
  static const updateDriverRide = '/Ride/updateDriverRide';
  static const registerRidePart = '/Ride/RegisterRidePart';
  static const welcomeRideRegister = '/WelcomeRideRegister';
  static const personalInformationScreen = '/PersonalInformationScreen';
  static const driversLicenseScreen = '/DriversLicenseScreen';
  static const drugAnalysisScreen = '/DrugAnalysisScreen';
  static const criminalRecordScreen = '/CriminalRecordScreen';
  static const technicalExaminationScreen = '/TechnicalExaminationScreen';
  static const personalDocumentsScreen = '/PersonalDocumentsScreen';
  static const vehicleInformationScreen = '/VehicleInformationScreen';
  static const moreInfoScreen = '/MoreInfoScreen';
  static const truckWelcomeRideRegister = '/TruckWelcomeRideRegister';

  static const truckPersonalInformationScreen =
      '/TruckPersonalInformationScreen';

  static const truckDriversLicenseScreen = '/TruckDriversLicenseScreen';
  static const truckPersonalDocumentsScreen = '/TruckPersonalDocumentsScreen';
  static const truckVehicleInformationScreen = '/TruckVehicleInformationScreen';
  static const truckMoreInfoScreen = '/TruckMoreInfoScreen';
  static const completeRegisterScreen = '/CompleteRegisterScreen';

  static const newTripJoinScreen = '/NewTripJoinScreen';
  static const captainShareScreen = '/CaptainShareScreen';
  static const captainShareInfoScreen = '/CaptainShareInfoScreen';
  static const tripJoinInfoScreen = '/TripJoinInfoScreen';
  static const pickMeInfoScreen = '/PickMeInfoScreen';
  static const newRouteScreen = '/NewRouteScreen';
  static const rideModeScreen = '/RideModeScreen';
  static const runningAndPastTripsScreen = '/RunningAndPastTripsScreen';
  static const captainRideDetails = '/CaptainRideDetails';
  static const createLoadingTripScreen = '/CreateLoadingTripScreen';
  static const CURRENTRIDEHOME = '/CurrentRideHome';
  static const RideRequestHOME = '/RideRequestScreen';
  static const RideStatusScreen = '/Ridestatusscreen';
  static const ratingClientScreen = '/RatingClientScreen';
  static const connectionCallScreen = '/ConnectionCallScreen';
  static const safetyRideScreen = '/SafetyRideScreen';
  static const rideFindingScreen = '/RideFindingScreen';
  static const rideDashboardDetailsScreen = '/RideDashboardDetailsScreen';
  static const routeDetailsScreen = '/RouteDetailsScreen';
  static const rideLoadingRequestScreen = '/rideLoadingRequestScreen';
  static const supportRideScreen = '/SupportRideScreen';
  static const supportClientDetailsScreen = '/SupportClientDetailsScreen';
  static const emergencyContactsScreen = '/EmergencyContactsScreen';
  static const rideArrivedScreen = '/RideArrivedScreen';
  static const ratingDriverScreen = '/RatingDriverScreen';
  static const completeRideScreen = '/CompleteRideScreen';

  // Change Password
  static const CHANGEPASSWORD = '/ChangePassword';
  static const CHANCE = '/CHANCE';
  static const CHANGEPASSWORDSECOND = '/ChangePasswordSecond';
  static const VERIFICATION = '/Verification';
  static const registerVerifyPhoneOTP = '/RegisterVerifyPhoneOTP';

  // Cashback
  static const CASHBACK = '/Cashback';
  static const newRideModeScreen = '/NewRideModeScreen';

  // Instagram
  static const INSTAGRAM = '/Instagram';
  static const INSTAGRAMPROFILE = '/InstagramProfile';
  static const INSTAGRAMCOMMENT = '/InstagramComment';
  static const InstagramSuggestPeople = '/InstagramSuggestPeople';
  static const ADDSTORYINSTAGRAM = '/AddStoryInstagram';
  static const CREATEPOSTINSTAGRAM = '/Instagram/CreatePostInstagram';
  static const CREATEPOSTSECONDPAGEINSTAGRAM =
      '/Instagram/CreatePostInstagram/CreatePostSecondPageInstagram';
  static const FOLLOWREQUESTSINSTAGRAM = '/FollowRequestsInstagram';
  // reels
  static const UseSoundScreen = '/UseSoundScreen';
  static const AddStoryScreen = '/AddStoryScreen';
  static const TAGUSER = '/TagUser';
  static const INSTAGRAMADDLOCATION = '/InstagramAddLocation';
  static const INSTAGRAMADDMUSIC = '/InstagramAddMusic';
  static const SINGLEPOSTINSTAGRAM = '/SinglePostInstagram';
  static const followersScreen = '/FollowersScreen';
  static const rideOffer = '/RiderOffer';
  static const allDriverRatingScreen = '/allDriverRatingScreen';
  static const allClientRatingScreen = '/allClientRatingScreen';
  static const loadingDashboardDetailsScreen = '/LoadingDashboardDetailsScreen';

}

abstract class Paths {
  Paths._();
  // static const splash = '/';
  static const HOME = '/';
  static const RIDEHOME = 'RideHome';
  static const onBoardingScreen = 'OnBoardingScreen';
  static const ChooseLangScreen = 'ChooseLangScreen';
  static const FirstLoginScreen = 'FirstLoginScreen';
  static const CompleteRegisterWelcomeScreen = 'CompleteRegisterWelcomeScreen';
  static const MY_TALENT = 'MyTalent';
  static const WINNERS = 'Winners';
  static const CUSTOMPAGE = 'CustomPage';
  static const PAGEPREVIEW = 'PagePreview';
  static const RIDEACTIVITY = 'RIDEACTIVITY';
  static const RIDEOPENSTREETMAPSEARCHANDPICK =
      'RIDEOPENSTREETMAPSEARCHANDPICK';
  static const GoogleMapsSearchAndPick =
      'GoogleMapsSearchAndPick';
  static const RIDERUNNINGTRIPS = 'RIDERUNNINGTRIPS';
  static const RIDEEXPIREDTRIPE = 'RIDEEXPIREDTRIPS';
  static const RIDEHISTORYTRIPS = 'RIDEHISTORYTRIPS';
  static const RIDEDETAILSTRIPS = 'RIDEDETAILSTRIPS';
  static const TripReceiptScreen = 'TripReceiptScreen';
  static const UploadRiderImages = 'UploadRiderImages';
  static const MAINCATEGORIESCARDS = 'MainCategoriesCards';
  static const SEARCH = 'Search';
  static const RESTAURANTORDERS = 'RestaurantOrders';
  static const EditFoodView = 'EditFoodView';
  static const MAINCATEGORIESTREE = 'MainCategoriesTree';
  static const SUBCATEGORIES = 'Subcategories';
  static const CustomPageSubCategoriesView = 'CustomPageSubCategoriesView';
  static const NavigatorSubCategoriesView = 'NavigatorSubCategoriesView';
  static const MARRIAGESUBCATEGORIES = 'MarriageSubcategories';
  static const FILTERADS = 'FilterAds';
  static const GOVERNORATEFILTERADS = 'GovernorateFilterAds';
  static const ADS = 'ADS';
  static const ADdetails = 'AD-Details';
  static const ADRequests = 'AD-Requests';
  static const ARCHIVEDCHATS = 'ArchivedChatsView';
  static const CREATEAD = 'CreateAd';
  static const CREATECOMPANYAD = 'CreateCompanyAd';
  static const CREATECOMPANYPOSTAD = 'CreatePostCompany';
  static const CREATECOMPANYPOSTREALAD = 'CreatePostRealCompany';
  static const LUCKYWHEEL = 'LuckyWheel';
  static const COMPETITIONS = 'Competitions';
  static const WINNERSCASHBACK = 'WinnersCashback';
  static const WINNERSGift = 'WinnersGift';
  static const WALLET = 'Wallet';
  static const BALANCE = 'Balance';
  static const GIFT = 'Gift';
  static const WALLETHISTORY = 'WalletHistory';
  static const TRANSFERMONEY = 'TransferMoney';
  static const SOCIAL = 'Social';
  static const FacebookSuggestPeople = 'FacebookSuggestPeople';
  static const OTHERSACCOUNT = 'OthersAccount';
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
  static const ONETIMEVOICEMESSAGEVIEW = 'OneTimeVoiceMessageView';
  static const ONETIMEDOCUMENTMESSAGEVIEW = 'OneTimeDocumentMessageView';
  static const FORWARDMESSAGESVIEW = 'ForwardMessagesView';
  static const CHATROOMCAMERAPICKER = 'CameraPicker';
  static const truckPersonalInformationScreen =
      'TruckPersonalInformationScreen';
  static const MEDIASLIDER = 'MediaSlider';
  static const REELS = 'Reels';
  static const MUSICREELS = 'MUSICREELS';
  static const TiktokOptionScreen = 'TiktokOptionScreen';
  static const AllLocationScreen = 'AllLocationScreen';
  static const TWITTER = 'Twitter';
  static const TWITTERPOSTDETAILS = 'TwitterPostDetails';
  static const CREATEPOST = 'CreatePost';
  static const POSTDETAILS = 'PostDetails';
  static const EDITPROFILE = 'EditProfile';
  static const SEARCHFRIENDS = 'SearchFriend';
  static const SEARCHPLACES = 'SearchPlaces';
  static const TINDER = 'Tinder';
  static const UserProfilePage = 'UserProfilePage';
  static const EditProfileTinder = 'EditProfileTinder';
  static const FindMyProfileScreen = 'FindMyProfileScreen';
  static const LIVE = 'Live';
  static const LIVEVIEW = 'LiveView';
  static const CLUBHOUSE = 'ClubHouse';
  static const CLUBHOUSECHAT = 'ClubHouseChat';
  static const CLUBHOUSEROOM = 'ClubHouseRoom';
  static const VISITA = 'Visita';
  static const EMERGENCYREQUESTS = 'EmergencyRequests';
  static const ALLAPPOINTMENTS = 'AllAppointments';
  static const VISITADOCTORLIST = 'VisitaDoctorsList';
  static const VISITAEMERGENCY = 'VisitaEmergency';
  static const VISITADOCTORDETAILS = 'DoctorDetails';
  static const VISITABOOKING = 'VisitaBooking';
  static const SUCCESSFULLBOOKING = 'SucessfullBooking';
  static const CREATEDOCTOR = 'CreateDoctor';
  static const EDITDOCTORPROFILE = 'EditDoctorProfile';
  static const FILTERDOCTORSUBCATEGORY = 'FilterDoctorSubcategory';
  static const FILTERDOCTORGOVERNORATE = 'FilterDoctorGovernorate';
  static const FILTERDOCTORCITY = 'FilterDoctorCity';
  static const FILTERDOCTORAREA = 'FilterDoctorArea';
  static const DOCTORDASHBOARD = 'DoctorDashboard';
  static const DOCTORREVIEWS = 'DoctorReviews';
  static const AllDOCTORREVIEWS = 'AllDoctorReviews';
  static const EDITDOCTORPERSONALINFO = 'EditDoctorPersonalInfo';
  static const EDITDOCTORTIMETABLE = 'EditDoctorTimeTable';
  static const DOCTORSTATISTICS = 'DoctorStatistics';
  static const DOCTORTODAYAPPOINTMENTS = 'DoctorTodayAppointments';
  static const DOCTORUNHANDLEDAPPOINTMENTS = 'DoctorUnhandledAppointments';
  static const ALLDOCTORRESERVATIONS = 'AllDoctorReservations';
  static const FOOD = 'Food';
  static const LIFEEVENT = 'LIFEEVENT';
  static const CREATELIFEEVENT = 'CREATELIFEEVENT';
  static const LIFEEVENTSub = 'LIFEEVENTSub';
  static const CREATERESTURANT = 'CreateResturant';
  static const CusineRestaurants = 'Cusine-Restaurants';
  static const RestaurantDashboard = 'RestaurantDashboard';
  static const RestaurantOrders = 'RestaurantOrders';
  static const SearchMeals = 'SearchMeals';
  static const SHIPPING = 'Shipping';
  static const SHIPPING_REGISTER = 'shippingRegister';
  static const CONTACTS_VIEW = 'ContactsView';

  static const RIDE = 'Ride';
  static const CONTACTUS = 'ContactUs';
  static const RIDERDASHBOARD = 'RiderDashboard';
  static const RIDERREGISTER = 'RiderRegister';
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
  static const EDITAD = 'EditAd';
  static const SHAREAPP = 'ShareApp';
  static const NOTIFICATIONS = 'Norifications';
  static const SETTINGS = 'Settings';
  static const QURAAN = 'Quraan';
  static const AZKAAR = 'Azkaar';
  static const AZKAARDETAILS = 'AZKAARDETAILS';
  static const PAYMENT = 'Payment';
  static const SUBSCRIPTIONPLANS = 'SubscriptionPlans';

  static const TRIP_JOIN = 'TripJoin';
  static const BE_STAR = 'BeAStar';
  static const TenPercent = 'TenPercent';
  static const WinnersTenPercent = 'WinnersTenPercent';
  static const Married = 'Married';
  static const BE_STAR_DETAILS = 'BeAStarDetails';
  static const AVAILABLE_TRIPS = 'AvailableTrips';
  static const All_PickMe_View = 'AllPickMeView';
  static const TRIP_JOIN_REQUEST_NOTIFICATIONS = 'TripJoinRequestNotification';
  static const TRIP_JOIN_REQUEST_HISTORY = 'TripJoinRequestHistory';
  static const TRIP_JOIN_REQUEST_HISTORY_Pick_Me =
      'TripJoinRequestHistoryPickMe';

  static const CAR_POOL = 'CarPool';
  static const ADD_NEW_ROUTE = 'AddNewRoute';

  static const SPOTLIGHT = 'Spotlight';
  static const SNAP = 'Snap';

  static const SELECTCONTACTSTOSHARE = 'SelectContactsToShareView';

  static const SEEALLBROADCASTS = 'SeeAllBroadcasts';

  static const BROADCAST = 'Broadcast';
  static const DASHBOARDDRIVERSCREEN = 'DASHBOARDDRIVERSCREEN';
  static const ALLTRIPRIDER = 'ALLTRIPRIDER';
  static const DRIVERREQUESTSDETIALS = 'DRIVERREQUESTSDETIALS';
  static const MyRating = 'MyRating';
  static const TripRating = 'TripRating';
  static const TripRideRating = 'TripRideRating';
  static const EDITDRIVERSCREEN = 'EditDriver';
  static const AddNewPickMe = "AddNeWPickMe";
  static const TRIPINFOBYRIDERSCREEN = 'TRIPINFOBYRIDERSCREEN';
  static const TRIPINFOBYDRIVERSCREEN = 'TRIPINFOBYDRIVERSCREEN';
  static const ALLTRIPNOSOCKETSCREEN = 'ALLTRIPNOSOCKETSCREEN';

  static const updateDriverShipping = 'updateDriverShipping';
  static const updateDriverRide = 'updateDriverRide';
  static const registerRidePart = 'RegisterRidePart';

  static const welcomeRideRegister = 'WelcomeRideRegister';
  static const personalInformationScreen = 'PersonalInformationScreen';
  static const driversLicenseScreen = 'DriversLicenseScreen';
  static const technicalExaminationScreen = 'TechnicalExaminationScreen';
  static const drugAnalysisScreen = 'DrugAnalysisScreen';
  static const criminalRecordScreen = 'CriminalRecordScreen';
  static const personalDocumentsScreen = 'PersonalDocumentsScreen';
  static const vehicleInformationScreen = 'VehicleInformationScreen';
  static const moreInfoScreen = 'MoreInfoScreen';
  static const truckWelcomeRideRegister = 'TruckWelcomeRideRegister';
  static const truckDriversLicenseScreen = 'TruckDriversLicenseScreen';
  static const truckPersonalDocumentsScreen = 'TruckPersonalDocumentsScreen';
  static const truckVehicleInformationScreen = 'TruckVehicleInformationScreen';
  static const truckMoreInfoScreen = 'TruckMoreInfoScreen';
  static const completeRegisterScreen = 'CompleteRegisterScreen';

  static const newTripJoinScreen = 'NewTripJoinScreen';
  static const captainShareScreen = 'CaptainShareScreen';
  static const captainShareInfoScreen = 'CaptainShareInfoScreen';
  static const tripJoinInfoScreen = 'TripJoinInfoScreen';
  static const pickMeInfoScreen = 'PickMeInfoScreen';
  static const newRouteScreen = 'NewRouteScreen';
  static const rideModeScreen = 'RideModeScreen';
  static const runningAndPastTripsScreen = 'RunningAndPastTripsScreen';
  static const captainRideDetails = 'CaptainRideDetails';
  static const createLoadingTripScreen = 'CreateLoadingTripScreen';
  static const CURRENTRIDEHOME = 'CurrentRideHome';
  static const RideREGUESTHOME = 'RideRequestScreen';
  static const ratingClientScreen = 'RatingClientScreen';
  static const connectionCallScreen = 'ConnectionCallScreen';
  static const safetyRideScreen = 'SafetyRideScreen';
  static const rideFindingScreen = 'RideFindingScreen';
  static const RideStatusScreen = 'RideStatusScreen';
  static const loadingDashboardDetailsScreen = 'LoadingDashboardDetailsScreen';
  static const rideDashboardDetailsScreen = 'RideDashboardDetailsScreen';
  static const routeDetailsScreen = 'RouteDetailsScreen';
  static const rideLoadingRequestScreen = 'rideLoadingRequestScreen';
  static const supportRideScreen = 'SupportRideScreen';
  static const supportClientDetailsScreen = 'SupportClientDetailsScreen';
  static const emergencyContactsScreen = 'EmergencyContactsScreen';
  static const rideArrivedScreen = 'RideArrivedScreen';
  static const ratingDriverScreen = 'RatingDriverScreen';
  static const completeRideScreen = 'CompleteRideScreen';
  static const newRideModeScreen = 'NewRideModeScreen';
  static const registerVerifyPhoneOTP = 'RegisterVerifyPhoneOTP';
  static const rideOffer = 'RiderOffer';
  static const allDriverRatingScreen = 'allDriverRatingScreen';

  // Change Password
  static const CHANGEPASSWORD = 'ChangePassword';
  static const CHANCE = 'CHANCE';
  static const CHANGEPASSWORDSECOND = 'ChangePasswordSecond';
  static const VERIFICATION = 'Verification';

  // Cashback
  static const CASHBACK = 'CashBack';

  //reels
  static const useSoundScreen = 'UseSoundScreen';
  static const addStoryScreen = 'AddStoryScreen';
  // Instagram
  static const INSTAGRAM = 'Instagram';
  static const INSTAGRAMPROFILE = 'InstagramProfile';
  static const INSTAGRAMCOMMENT = 'InstagramComment';
  static const InstagramSuggestPeople = 'InstagramSuggestPeople';
  static const ADDSTORYINSTAGRAM = 'AddStoryInstagram';
  static const CREATEPOSTINSTAGRAM = 'CreatePostInstagram';
  static const CREATEPOSTSECONDPAGEINSTAGRAM = 'CreatePostSecondPageInstagram';
  static const TAGUSER = 'TagUser';
  static const INSTAGRAMADDLOCATION = 'InstagramAddLocation';
  static const INSTAGRAMADDMUSIC = 'InstagramAddMusic';
  static const SINGLEPOSTINSTAGRAM = 'SinglePostInstagram';
  static const FOLLOWREQUESTSINSTAGRAM = 'FollowRequestsInstagram';
  static const followersScreen = 'FollowersScreen';
  static const allClientRatingScreen = 'allClientRatingScreen';

}
