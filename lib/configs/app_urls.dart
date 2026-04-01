class AppUrls {
  static String baseUrl = "https://library.17000ft.org/apis/";
  static String loginapi = '${AppUrls.baseUrl}library_login.php';
  static String dashapi = '${AppUrls.baseUrl}getDashboardData.php';
  static String registerapi = '${AppUrls.baseUrl}registerStudent.php';
  static String allStudentapi = '${AppUrls.baseUrl}allStudents.php';
  static String bookIssueapi = '${AppUrls.baseUrl}bookIssueToStudent.php';
  static String testBookIssueapi = '${AppUrls.baseUrl}test_bookIssuedToStudent.php';
  static String getReturnedBookapi = '${AppUrls.baseUrl}getReturnedBook.php';
  static String getIssuedBookapi = '${AppUrls.baseUrl}getIssuedBook.php';
  static String getBlockapi = '${AppUrls.baseUrl}filters.php?getBlock';
  static String getStateapi = '${AppUrls.baseUrl}filters.php?getState';
  static String getDistrictapi = '${AppUrls.baseUrl}filters.php?getDistrict';
  static String getSchoolapi = '${AppUrls.baseUrl}filters.php?getSchool';
  static String getLevelApi = '${AppUrls.baseUrl}/getLevels.php?request=level';
  static String getLanguageApi = '${AppUrls.baseUrl}/getLevels.php?request=language';
  static String promoteStudent = '${AppUrls.baseUrl}/promoteStudent.php';
  static String getStudentId= '${AppUrls.baseUrl}/getUniqueId.php?getUniqueId';
  static String fcmTokenApi = '${AppUrls.baseUrl}/setFCMToken.php';
  static String getGradeApi = '${AppUrls.baseUrl}/getGrade.php';
  static String getBooksApi = '${AppUrls.baseUrl}/getBook.php';
  static String studentDetailApi = '${AppUrls.baseUrl}/studentDetail.php';
  static String getAppVersionApi = '${AppUrls.baseUrl}/getAppVersion.php';
  static String testGetBooksApi = '${AppUrls.baseUrl}/test_getBook.php';
  static String insertFormApi = 'https://library.17000ft.org/library_activity_log/insert.php';
}
