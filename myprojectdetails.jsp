<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>프로젝트 상세 정보</title>
    <link rel="stylesheet" href="css/myprojectdetails.css">
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

        String projectId = request.getParameter("projectId");
        if (projectId == null) {
    %>
        <script>
            alert("유효하지 않은 접근입니다.");
            window.location.href = "myproject.jsp";
        </script>
    <%
            return;
        }

        Connection conn = null;
        PreparedStatement projectStmt = null, membersStmt = null, roleCheckStmt = null, updateStmt = null;
        ResultSet projectRs = null, membersRs = null, roleCheckRs = null;
        boolean isOwner = false;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");

            // 프로젝트 상세 정보 가져오기
            String projectSql = "SELECT title, description, project_type, deadline_date, status " +
                                "FROM projects " +
                                "WHERE project_id = ?;";
            projectStmt = conn.prepareStatement(projectSql);
            projectStmt.setInt(1, Integer.parseInt(projectId));
            projectRs = projectStmt.executeQuery();

            // 프로젝트 지원자 목록 가져오기
            String membersSql = "SELECT up.user_email, m.name, m.github, up.role, up.join_date " +
                                "FROM user_projects up " +
                                "JOIN MypageTable m ON up.user_email = m.email " +
                                "WHERE up.project_id = ?;";
            membersStmt = conn.prepareStatement(membersSql);
            membersStmt.setInt(1, Integer.parseInt(projectId));
            membersRs = membersStmt.executeQuery();

            // 현재 사용자가 오너인지 확인
            String roleCheckSql = "SELECT role FROM user_projects WHERE project_id = ? AND user_email = ?;";
            roleCheckStmt = conn.prepareStatement(roleCheckSql);
            roleCheckStmt.setInt(1, Integer.parseInt(projectId));
            roleCheckStmt.setString(2, userEmail);
            roleCheckRs = roleCheckStmt.executeQuery();
            if (roleCheckRs.next() && "Owner".equalsIgnoreCase(roleCheckRs.getString("role"))) {
                isOwner = true;
            }

            // 진행 상태 업데이트 처리
            if (isOwner && "POST".equalsIgnoreCase(request.getMethod())) {
                String updateSql = "UPDATE projects SET status = FALSE WHERE project_id = ?;";
                updateStmt = conn.prepareStatement(updateSql);
                updateStmt.setInt(1, Integer.parseInt(projectId));
                updateStmt.executeUpdate();

    %>
        <script>
            alert("프로젝트 상태가 '진행 중'으로 변경되었습니다.");
            window.location.href = "myprojectdetails.jsp?projectId=<%= projectId %>";
        </script>
    <%
                return;
            }
    %>

    <div class="container">
        <%
            if (projectRs.next()) {
        %>
            <h1>프로젝트 상세 정보</h1>
            <div class="project-details">
                <p><strong>제목:</strong> <%= projectRs.getString("title") %></p>
                <p><strong>설명:</strong> <%= projectRs.getString("description") %></p>
                <p><strong>프로젝트 유형:</strong> 
                    <%
                        int type = projectRs.getInt("project_type");
                        if (type == 0) out.print("학교 프로젝트");
                        else if (type == 1) out.print("공모전");
                        else out.print("토이프로젝트");
                    %>
                </p>
                <p><strong>마감일:</strong> <%= projectRs.getDate("deadline_date") %></p>
                <p><strong>상태:</strong> <%= projectRs.getBoolean("status") ? "모집 중" : "진행 중" %></p>
            </div>
            <%
                // "모집 완료" 버튼은 오너인 경우에만 표시
                if (isOwner && projectRs.getBoolean("status")) {
            %>
                <form method="post" style="margin-top: 20px;">
                    <button type="submit" class="complete-btn">모집 완료</button>
                </form>
            <%
                }
            %>
        <%
            } else {
        %>
            <p>프로젝트 정보를 불러올 수 없습니다.</p>
        <%
            }
        %>

        <h2>지원자 목록</h2>
        <table>
            <thead>
                <tr>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>GitHub</th>
                    <th>역할</th>
                    <th>참여 날짜</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (!membersRs.isBeforeFirst()) {
                %>
                    <tr>
                        <td colspan="5">지원자가 없습니다.</td>
                    </tr>
                <%
                    } else {
                        while (membersRs.next()) {
                %>
                    <tr>
                        <td><%= membersRs.getString("name") %></td>
                        <td><%= membersRs.getString("user_email") %></td>
                        <td><a href="<%= membersRs.getString("github") %>" target="_blank"><%= membersRs.getString("github") %></a></td>
                        <td><%= membersRs.getString("role") %></td>
                        <td><%= membersRs.getTimestamp("join_date") %></td>
                    </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>

    <%
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>데이터베이스 오류가 발생했습니다.</p>");
        } finally {
            if (projectRs != null) try { projectRs.close(); } catch (SQLException e) {}
            if (membersRs != null) try { membersRs.close(); } catch (SQLException e) {}
            if (roleCheckRs != null) try { roleCheckRs.close(); } catch (SQLException e) {}
            if (projectStmt != null) try { projectStmt.close(); } catch (SQLException e) {}
            if (membersStmt != null) try { membersStmt.close(); } catch (SQLException e) {}
            if (roleCheckStmt != null) try { roleCheckStmt.close(); } catch (SQLException e) {}
            if (updateStmt != null) try { updateStmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
</body>
</html>
