class AppUrls {
  //static String baseUrl = "https://library.17000ft.org/apis/";
  // static String loginapi = '${AppUrls.baseUrl}library_login.php';
  // static String dashapi = '${AppUrls.baseUrl}getDashboardData.php';
  // static String testDashapi = '${AppUrls.baseUrl}test_getDashboardData.php';
  // static String registerapi = '${AppUrls.baseUrl}registerStudent.php';
  // static String testregisterapi = '${AppUrls.baseUrl}test_registerStudent.php';
  // static String allStudentapi = '${AppUrls.baseUrl}allStudents.php';
  // static String testallStudentapi = '${AppUrls.baseUrl}test_allStudents.php';
  // static String bookIssueapi = '${AppUrls.baseUrl}bookIssueToStudent.php';
  // static String testBookIssueapi = '${AppUrls.baseUrl}test_bookIssuedToStudent.php';
  // static String getReturnedBookapi = '${AppUrls.baseUrl}getReturnedBook.php';
  // static String getIssuedBookapi = '${AppUrls.baseUrl}getIssuedBook.php';
  // static String getBlockapi = '${AppUrls.baseUrl}filters.php?getBlock';
  // static String getStateapi = '${AppUrls.baseUrl}filters.php?getState';
  // static String getDistrictapi = '${AppUrls.baseUrl}filters.php?getDistrict';
  // static String getSchoolapi = '${AppUrls.baseUrl}filters.php?getSchool';
  //static String getLevelApi = '${AppUrls.baseUrl}/getLevels.php?request=level';
  //static String getLanguageApi = '${AppUrls.baseUrl}/getLevels.php?request=language';
  // static String promoteStudent = '${AppUrls.baseUrl}/promoteStudent.php';
  // static String testpromoteStudent = '${AppUrls.baseUrl}/test_promoteStudent.php';
  // static String getStudentId= '${AppUrls.baseUrl}/getUniqueId.php?getUniqueId';
  //static String fcmTokenApi = '${AppUrls.baseUrl}/setFCMToken.php';
  //static String getGradeApi = '${AppUrls.baseUrl}/getGrade.php';
  // static String getBooksApi = '${AppUrls.baseUrl}/getBook.php';
  //static String studentDetailApi = '${AppUrls.baseUrl}/studentDetail.php';
  // static String teststudentDetailApi = '${AppUrls.baseUrl}/test_studentDetail.php';
  // static String getAppVersionApi = '${AppUrls.baseUrl}/getAppVersion.php';
  // static String testGetBooksApi = '${AppUrls.baseUrl}/test_getBook.php';
  // static String insertFormApi = 'https://library.17000ft.org/library_activity_log/insert.php';
  // static String getFormApi = 'https://library.17000ft.org/library_activity_log/getLibForm.php';



  static String baseUrl = "https://demo.library.17000ft.org/api/library/";
  // static String baseUrl = "https://library.17000ft.org/api/library/";
  static String loginApi = "${AppUrls.baseUrl}login";
  //This is for demo only for now
  static String passResetApi = "${AppUrls.baseUrl}reset_password";
  static String dashboardApi = "${AppUrls.baseUrl}get_dashboard_data";
  static String registerApi = "${AppUrls.baseUrl}register_student";
  static String bookIssueReturnApi = "${AppUrls.baseUrl}issue_return_book";
  static String allStudentsApi = "${AppUrls.baseUrl}get_students";
  static String getReturnedBookApi = "${AppUrls.baseUrl}get_return_book";
  static String getIssuedBookApi = "${AppUrls.baseUrl}get_issued_book";
  static String bookAdd = "${AppUrls.baseUrl}insert_book";

  static String getBlockApi = "${AppUrls.baseUrl}filters?getBlock";
  static String getDistrictApi = "${AppUrls.baseUrl}filters?getDistrict";
  static String getAllSchoolApi = "${AppUrls.baseUrl}filters?getSchool";
  static String getSchoolApi = "${AppUrls.baseUrl}filters?getSchool";
  static String getStateApi = "${AppUrls.baseUrl}filters?getState";

  static String getLevelApi = "${AppUrls.baseUrl}get_levels?request=level";
  static String getTitleApi = "${AppUrls.baseUrl}get_levels?request=title";
  static String getLanguageApi = "${AppUrls.baseUrl}get_levels?request=language";
  static String getGenerApi = "${AppUrls.baseUrl}get_levels?request=gener";
  static String getPublisherApi = "${AppUrls.baseUrl}get_levels?request=publisher";


  static String getBookApi = "${AppUrls.baseUrl}get_book";
  static String getGradeApi = "${AppUrls.baseUrl}get_grades";
  static String promoteStudentApi = "${AppUrls.baseUrl}promote_student";
  static String getLibVersionApi = "${AppUrls.baseUrl}get_lib_version";
  static String getUniqueIdApi = "${AppUrls.baseUrl}get_uniqueId";
  static String insertLibFormApi = "${AppUrls.baseUrl}insert_activity_log";
  static String getLibFormApi = "${AppUrls.baseUrl}get_activity_log";
  static String studentDetailApi = "${AppUrls.baseUrl}student_detail";
  static String fcmTokenApi = "${AppUrls.baseUrl}update_fcm_token";
  static String getAppVersionApi = '${AppUrls.baseUrl}get_lib_version';

  static String syncInitial = '${AppUrls.baseUrl}initial_sync';
  static String syncPush = '${AppUrls.baseUrl}sync/push';
  static String syncPull = '${AppUrls.baseUrl}sync/pull';
  static String syncMeta = '${AppUrls.baseUrl}upload_file';


}
