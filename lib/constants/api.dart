class Api {
  static String get baseUrl {
    return "https://empowermentfoodnetwork.com/office/appdata";
  }

  static const login = "/signin.php";
  static const register = "/register.php";
  static const partnerType = "/dashboardscreena.php";
  static const totalBalance = "/dashboardscreenb.php";
  static const totalReferers = "/dashboardscreenc.php";
  static const tableData = "/dashboardscreend.php";
  static const editProfile = "/editprofile.php";
  static const changePassword = "/changepassword.php";
  static const referers = "/regrefererer.php";
  static const fixedUsername = "/fixedusername.php";
  static const regAnyMember = "/registeranymember.php";
  static const regFixedMember = "/registerfixedmember.php";
  static const getEmail = "/nav.php";
  static const loadData = "/loaddata.php";
  static const regFee = "/regfee.php";
  static const withdrawalHistory = "/withdrawalhistory.php";
  static const fundingHistory = "/fundinghistory.php";
  static const incentivesHistory = "/incentiveshistory.php";
  static const bankDetails = "/bankdetails.php";
  static const incentives = "/incentives.php";
  static const applyIncentives = "/incentiveapply.php";
  static const supportRequests = "/supportmessages.php";
  static const withdrawFunds = "/withdrawfunds.php";
  static const testify = "/testify.php";
  static const contactSupport = "/contactsupport.php";
  static const addFund = "/fundnow.php";
  static const activate = "/activatenow.php";
  static const orders = "/orders.php";
  static const changeProfilePics = "/changeprofilepics.php";
  static const getProfilePics = "/getprofilepics.php";
  static const forgotPassword = "/forgotpassword.php";
  static const refLink = "/reflink.php";
  static const news = "/news.php";
  static const latestNews = "/lastnews.php";
  static const sucessful = "/successful.php";

  // Other pages

  static String get inappSupport {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/support/chat";
  }
}
