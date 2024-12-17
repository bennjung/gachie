<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8" %>
<%
    // 세션에서 사용자 이메일 가져오기
    request.setCharacterEncoding("UTF-8");
    String userEmail = (session != null) ? (String) session.getAttribute("email") : null;

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String projectTitle = request.getParameter("project_title");
    String projectType = request.getParameter("project_type");
    String description = request.getParameter("description");
    String details = request.getParameter("details");
    String deadlineDate = request.getParameter("deadline_date");
    String techStack = request.getParameter("techStack"); // 기술 스택 (콤마로 구분된 문자열)

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // MySQL JDBC 드라이버 로드
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/MakeWebDB", "me", "1234");

        // 1. 프로젝트 삽입
        String insertProjectSQL = "INSERT INTO projects (title, project_type, description, details, deadline_date) VALUES (?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertProjectSQL, Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, projectTitle);
        pstmt.setInt(2, Integer.parseInt(projectType));
        pstmt.setString(3, description);
        pstmt.setString(4, details);
        pstmt.setString(5, deadlineDate);
        pstmt.executeUpdate();

        // 생성된 프로젝트 ID 가져오기
        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        int projectId = 0;
        if (generatedKeys.next()) {
            projectId = generatedKeys.getInt(1);
        } else {
            throw new SQLException("프로젝트 ID 생성에 실패했습니다.");
        }
        pstmt.close();

        // 2. 기술 스택 삽입
        if (techStack != null && !techStack.isEmpty()) {
            out.println("전달된 기술 스택: " + techStack + "<br>"); // 디버깅용 출력
            String[] tags = techStack.split(",");
            String insertTagSQL = "INSERT INTO project_tags (project_id, tag_name) VALUES (?, ?)";
            pstmt = conn.prepareStatement(insertTagSQL);

            for (String tag : tags) {
                tag = tag.trim();
                out.println("삽입할 태그: " + tag + "<br>"); // 디버깅용 출력
                pstmt.setInt(1, projectId);
                pstmt.setString(2, tag);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            pstmt.close();
        } else {
            out.println("기술 스택 데이터가 비어 있습니다.<br>"); // 디버깅용 출력
        }

        // 3. 모집 정보 삽입
        String[] recruitFields = request.getParameterValues("recruit_field[]");
        String[] recruitCounts = request.getParameterValues("recruit_count[]");
        String[] recruitRequirements = request.getParameterValues("recruit_requirements[]");

        if (recruitFields != null) {
            String insertRecruitSQL = "INSERT INTO project_recruits (project_id, recruit_field, recruit_count, requirements) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertRecruitSQL);

            for (int i = 0; i < recruitFields.length; i++) {
                pstmt.setInt(1, projectId);
                pstmt.setString(2, recruitFields[i]);
                pstmt.setInt(3, Integer.parseInt(recruitCounts[i]));
                pstmt.setString(4, recruitRequirements[i]);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
            pstmt.close();
        }

        // 4. user_projects 등록
        String insertUserProjectSQL = "INSERT INTO user_projects (user_email, project_id, role, status) VALUES (?, ?, ?, ?)";
        pstmt = conn.prepareStatement(insertUserProjectSQL);
        pstmt.setString(1, userEmail);
        pstmt.setInt(2, projectId);
        pstmt.setString(3, "Owner");
        pstmt.setString(4, "진행중");
        pstmt.executeUpdate();

        response.sendRedirect("projectLists.jsp");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("오류 발생: " + e.getMessage());
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
