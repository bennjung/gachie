<%@ page import="java.sql.*" %>
<%!
  // 데이터베이스 연결 정보
  private static final String URL = "jdbc:mysql://localhost:3306/gachi_db";
  private static final String USER = "root";
  private static final String PASSWORD = "0000";

  // 데이터베이스 연결을 반환하는 메소드
  public static Connection getConnection() throws SQLException {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      return DriverManager.getConnection(URL, USER, PASSWORD);
    } catch (ClassNotFoundException e) {
      throw new SQLException("MySQL Driver not found.", e);
    }
  }
%>