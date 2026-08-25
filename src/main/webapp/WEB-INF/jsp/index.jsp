<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팀플구인사이트</title>
    <style>
        main { padding: 20px; }
        .hero { text-align: center; padding: 60px 0; }
        .hero h1 { font-size: 2em; }
        .menu { display: flex; gap: 10px; justify-content: center; margin-top: 20px; }
        .menu a { padding: 10px 20px; background: #555; color: #fff; border-radius: 4px; text-decoration: none; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<main>
    <div class="hero">
        <h1>팀플 구인 사이트</h1>
        <p>팀 프로젝트 팀원을 구하거나 참가 신청을 해보세요!</p>
        <div class="menu">
            <a href="${pageContext.request.contextPath}/board">게시판 보기</a>
            <a href="${pageContext.request.contextPath}/team">팀플 모집 확인하기</a>
        </div>
    </div>
</main>

</body>
</html>
