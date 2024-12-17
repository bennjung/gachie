<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 프로젝트 관리</title>
    <link rel="stylesheet" href="css/project-management.css">
    <link rel="stylesheet" href="css/navstyles.css">
</head>

<body>
    <jsp:include page="navbar.jsp" />

    <%
        String userEmail = (session != null) ? (String) session.getAttribute("email") : null;

        if (userEmail == null) {
    %>
        <script>
            alert("로그인을 먼저 해주세요.");
            window.location.href = "login.jsp";
        </script>
    <%
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtRecruiting = null, pstmtOngoing = null, pstmtApplied = null;
        ResultSet rsRecruiting = null, rsOngoing = null, rsApplied = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");

            // 모집 중 프로젝트 (Owner 역할 + 모집 중 상태)
            String recruitingSql = "SELECT p.project_id, p.title, p.description, p.deadline_date " +
                                   "FROM user_projects up " +
                                   "JOIN projects p ON up.project_id = p.project_id " +
                                   "WHERE up.user_email = ? AND up.role = 'Owner' AND p.status = TRUE;";
            pstmtRecruiting = conn.prepareStatement(recruitingSql);
            pstmtRecruiting.setString(1, userEmail);
            rsRecruiting = pstmtRecruiting.executeQuery();

            // 진행 중 프로젝트 (Owner 역할 + 진행 중 상태)
            String ongoingSql = "SELECT p.project_id, p.title, p.description, p.deadline_date " +
                                "FROM user_projects up " +
                                "JOIN projects p ON up.project_id = p.project_id " +
                                "WHERE up.user_email = ? AND up.role = 'Owner' AND p.status = FALSE;";
            pstmtOngoing = conn.prepareStatement(ongoingSql);
            pstmtOngoing.setString(1, userEmail);
            rsOngoing = pstmtOngoing.executeQuery();

            // 지원 중 프로젝트 (Member 역할)
            String appliedSql = "SELECT p.project_id, p.title, p.description, p.deadline_date " +
                                "FROM user_projects up " +
                                "JOIN projects p ON up.project_id = p.project_id " +
                                "WHERE up.user_email = ? AND up.role = 'Member';";
            pstmtApplied = conn.prepareStatement(appliedSql);
            pstmtApplied.setString(1, userEmail);
            rsApplied = pstmtApplied.executeQuery();
    %>

    <div class="container">
        <h1>내 프로젝트 관리</h1>

        <!-- 모집 중 -->
        <div class="section">
            <h2>모집 중</h2>
            <% if (!rsRecruiting.isBeforeFirst()) { %>
                <p>현재 모집 중인 프로젝트가 없습니다.</p>
            <% } else { %>
                <% while (rsRecruiting.next()) { %>
                    <div class="project-card" onclick="location.href='myprojectdetails.jsp?projectId=<%= rsRecruiting.getInt("project_id") %>'">
                        <strong><%= rsRecruiting.getString("title") %></strong>
                        <p>설명: <%= rsRecruiting.getString("description") %></p>
                        <p>마감일: <%= rsRecruiting.getDate("deadline_date") %></p>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- 진행 중 -->
        <div class="section">
            <h2>진행 중</h2>
            <% if (!rsOngoing.isBeforeFirst()) { %>
                <p>현재 진행 중인 프로젝트가 없습니다.</p>
            <% } else { %>
                <% while (rsOngoing.next()) { %>
                    <div class="project-card" onclick="location.href='myprojectdetails.jsp?projectId=<%= rsOngoing.getInt("project_id") %>'">
                        <strong><%= rsOngoing.getString("title") %></strong>
                        <p>설명: <%= rsOngoing.getString("description") %></p>
                        <p>마감일: <%= rsOngoing.getDate("deadline_date") %></p>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- 지원 중 -->
        <div class="section">
            <h2>지원 중</h2>
            <% if (!rsApplied.isBeforeFirst()) { %>
                <p>현재 지원 중인 프로젝트가 없습니다.</p>
            <% } else { %>
                <% while (rsApplied.next()) { %>
                    <div class="project-card" onclick="location.href='myprojectdetails.jsp?projectId=<%= rsApplied.getInt("project_id") %>'">
                        <strong><%= rsApplied.getString("title") %></strong>
                        <p>설명: <%= rsApplied.getString("description") %></p>
                        <p>마감일: <%= rsApplied.getDate("deadline_date") %></p>
                    </div>
                <% } %>
            <% } %>
        </div>
    </div>

    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>데이터베이스 오류가 발생했습니다.</p>");
        } finally {
            if (rsRecruiting != null) try { rsRecruiting.close(); } catch (SQLException e) {}
            if (rsOngoing != null) try { rsOngoing.close(); } catch (SQLException e) {}
            if (rsApplied != null) try { rsApplied.close(); } catch (SQLException e) {}
            if (pstmtRecruiting != null) try { pstmtRecruiting.close(); } catch (SQLException e) {}
            if (pstmtOngoing != null) try { pstmtOngoing.close(); } catch (SQLException e) {}
            if (pstmtApplied != null) try { pstmtApplied.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>
</html>
