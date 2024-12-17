<%@ page import="java.sql.*" %>
<%!
  // 프로젝트 상세 정보 조회
  public static ResultSet selectProject(int projectId) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      String sql = "SELECT * FROM projects WHERE project_id = ?";
      pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, projectId);
      rs = pstmt.executeQuery();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return rs;
  }

  // 모든 프로젝트 조회
  public static ResultSet selectAllProjects() {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      String sql = "SELECT * FROM projects WHERE status = TRUE ORDER BY created_at DESC";
      pstmt = conn.prepareStatement(sql);
      rs = pstmt.executeQuery();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return rs;
  }

  // 프로젝트 태그 조회
  public static ResultSet selectProjectTags(int projectId) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      String sql = "SELECT tag_name FROM project_tags WHERE project_id = ?";
      pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, projectId);
      rs = pstmt.executeQuery();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return rs;
  }

  // 프로젝트 모집 정보 조회
  public static ResultSet selectProjectRecruits(int projectId) {
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
      conn = getConnection();
      String sql = "SELECT * FROM project_recruits WHERE project_id = ?";
      pstmt = conn.prepareStatement(sql);
      pstmt.setInt(1, projectId);
      rs = pstmt.executeQuery();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return rs;
  }

  // Connection 객체 얻기 (dbConnect.jsp의 메소드를 직접 포함)
  private static Connection getConnection() throws SQLException {
    try {
      Class.forName("com.mysql.cj.jdbc.Driver");
      return DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");
    } catch (ClassNotFoundException e) {
      throw new SQLException("MySQL Driver not found.", e);
    }
  }
%>
