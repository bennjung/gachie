<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ include file="queryExecutor.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>프로젝트 찾기</title>
    <link rel="stylesheet" href="css/navstyles.css">
    <link rel="stylesheet" href="css/projectLists.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="project-list-container">
    <div class="search-section">

        <div class="project-types">
            <%
                String selectedType = request.getParameter("type");
                if (selectedType == null) {
                    selectedType = "all";
                }
            %>
            <a href="?type=all" class="type-btn <%= selectedType.equals("all") ? "active" : "" %>">전체</a>
            <a href="?type=0" class="type-btn type-0 <%= selectedType.equals("0") ? "active" : "" %>">학교과제</a>
            <a href="?type=1" class="type-btn type-1 <%= selectedType.equals("1") ? "active" : "" %>">공모전</a>
            <a href="?type=2" class="type-btn type-2 <%= selectedType.equals("2") ? "active" : "" %>">토이프로젝트</a>
        </div>
    </div>

    <div class="projects">
        <%
            ResultSet rs = null;
            try {
                rs = selectAllProjects();

                while (rs.next()) {
                    String projectType = "";
                    switch (rs.getInt("project_type")) {
                        case 0: projectType = "학교과제"; break;
                        case 1: projectType = "공모전"; break;
                        case 2: projectType = "토이프로젝트"; break;
                    }

                    String searchTerm = request.getParameter("search");
                    if (searchTerm == null) {
                        searchTerm = "";
                    }

                    boolean shouldDisplayCard = false;
                    if (selectedType.equals("all") || selectedType.equals(String.valueOf(rs.getInt("project_type")))) {
                        if (rs.getString("title").toLowerCase().contains(searchTerm.toLowerCase()) || rs.getString("description").toLowerCase().contains(searchTerm.toLowerCase())) {
                            shouldDisplayCard = true;
                        }
                    }

                    if (shouldDisplayCard) {
        %>
        <div class="project-card"
             data-type="<%= projectType %>"
             onclick="location.href='projectDetail.jsp?id=<%= rs.getInt("project_id") %>'">
            <div class="project-header">
                <h3><%= rs.getString("title") %></h3>
                <span class="project-type type-<%= rs.getInt("project_type") %>">
                   <%= projectType %>
               </span>
            </div>
            <p class="description"><%= rs.getString("description") %></p>
            <div class="project-info">
                <span>마감일: <%= rs.getDate("deadline_date") %></span>
                <span class="status">모집중</span>
            </div>
        </div>
        <%
                    }
                }
            } catch (Exception e) {
                System.out.println("데이터베이스 연결 오류: " + e.getMessage());
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
            }
        %>
    </div>
</div>
<script src="js/projectList.js"></script>
</body>
</html>