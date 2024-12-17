<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로젝트 세부 정보</title>
    <link rel="stylesheet" href="css/project-details.css">
    <link rel="stylesheet" href="css/navstyles.css">
</head>

<body>
    <jsp:include page="navbar.jsp" />

    <%
        String projectId = request.getParameter("projectId");

        if (projectId == null) {
    %>
        <script>
            alert("유효하지 않은 프로젝트입니다.");
            window.location.href = "myproject.jsp";
        </script>
    <%
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");

            // 프로젝트 세부 정보 가져오기
            String sql = "SELECT * FROM projects WHERE project_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, Integer.parseInt(projectId));
            rs = pstmt.executeQuery();

            if (rs.next()) {
    %>
                <div class="container">
                    <h1><%= rs.getString("title") %></h1>
                    <p><strong>설명:</strong> <%= rs.getString("description") %></p>
                    <p><strong>프로젝트 유형:</strong> <%= rs.getInt("project_type") %></p>
                    <p><strong>마감일:</strong> <%= rs.getDate("deadline_date") %></p>
                    <p><strong>상태:</strong> <%= rs.getBoolean("status") ? "모집 중" : "모집 완료" %></p>
                </div>
    <%
            } else {
                out.println("<p>프로젝트 정보를 찾을 수 없습니다.</p>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>데이터베이스 오류가 발생했습니다.</p>");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>

</html>
