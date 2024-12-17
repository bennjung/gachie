<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="queryExecutor.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>프로젝트 상세보기</title>
    <link rel="stylesheet" href="css/navstyles.css">
    <link rel="stylesheet" href="css/projectDetails.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="project-detail-container">
    <%
        String projectId = request.getParameter("id");
        if (projectId != null) {
            ResultSet projectRs = null;
            ResultSet tagRs = null;
            ResultSet recruitRs = null;

            try {
                projectRs = selectProject(Integer.parseInt(projectId));

                if (projectRs.next()) {
                    boolean isRecruiting = projectRs.getBoolean("status");
                    String status = isRecruiting ? "모집중" : "모집완료";
                    String statusClass = isRecruiting ? "recruiting" : "closed";
                    String projectType = "";
                    switch (projectRs.getInt("project_type")) {
                        case 0: projectType = "학교 프로젝트"; break;
                        case 1: projectType = "공모전"; break;
                        case 2: projectType = "토이프로젝트"; break;
                    }
    %>
    <!-- 프로젝트 상태와 유형 -->
    <div class="project-info">
        <div class="project-status <%= statusClass %>">
            <span>상태: <%= status %></span>
        </div>

        <div class="project-type <%= "type-" + projectRs.getInt("project_type") %>">
            <span>유형: <%= projectType %></span>
        </div>
    </div>

    <!-- 프로젝트 제목 -->
    <h1><%= projectRs.getString("title") %></h1>

    <!-- 지원 버튼 -->
    <div class="button-group">
        <% if (isRecruiting) { %>
        <a href="projectApply.jsp?id=<%= projectId %>" class="apply-button">
            <div class="apply-button-box">지원하기</div>
        </a>
        <% } %>
    </div>

    <!-- 기술 스택 -->
    <div class="tech-stack">
        <h2>필요 기술 스택</h2>
        <div class="tag-list">
            <%
                tagRs = selectProjectTags(Integer.parseInt(projectId));
                while (tagRs != null && tagRs.next()) {
            %>
            <span class="tech-tag"><%= tagRs.getString("tag_name") %></span>
            <%
                }
            %>
        </div>
    </div>

    <!-- 모집 분야 -->
    <div class="recruit-section">
        <h2>모집 분야</h2>
        <%
            recruitRs = selectProjectRecruits(Integer.parseInt(projectId));
            while (recruitRs != null && recruitRs.next()) {
        %>
        <div class="recruit-item">
            <div class="recruit-header">
                <strong class="recruit-field"><%= recruitRs.getString("recruit_field") %></strong>
                <span class="recruit-count"><%= recruitRs.getInt("recruit_count") %>명</span>
            </div>
            <p class="requirements"><%= recruitRs.getString("requirements") %></p>
        </div>
        <%
            }
        %>
    </div>

    <!-- 프로젝트 소개 -->
    <div class="project-description">
        <h2>프로젝트 소개</h2>
        <p><%= projectRs.getString("description") %></p>
    </div>
    <%
                }
            } catch (Exception e) {
                System.out.println("데이터베이스 오류: " + e.getMessage());
                e.printStackTrace();
            } finally {
                if (projectRs != null) try { projectRs.close(); } catch (Exception e) {}
                if (tagRs != null) try { tagRs.close(); } catch (Exception e) {}
                if (recruitRs != null) try { recruitRs.close(); } catch (Exception e) {}
            }
        }
    %>
</div>
</body>
</html>
