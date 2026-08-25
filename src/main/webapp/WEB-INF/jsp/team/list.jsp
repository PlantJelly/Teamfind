<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>팀플 모집</title>
    <style>
        main { padding: 24px; max-width: 960px; margin: 0 auto; }
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .page-header h2 { font-size: 22px; }
        .btn-write { background: #e67e22; color: #fff; padding: 8px 18px; border-radius: 4px; text-decoration: none; font-size: 14px; }
        .btn-write:hover { background: #cf6d17; }
        .card-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 16px; }
        .card { background: #fff; border-radius: 8px; border: 1px solid #e0e0e0; padding: 18px; transition: box-shadow 0.2s; }
        .card:hover { box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .card a { text-decoration: none; color: inherit; display: block; }
        .card-title { font-size: 16px; font-weight: bold; margin-bottom: 8px; color: #1a1a2e; }
        .card-desc { font-size: 13px; color: #666; margin-bottom: 10px; line-height: 1.5;
                     overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }
        .card-meta { font-size: 12px; color: #999; display: flex; flex-wrap: wrap; gap: 8px; }
        .badge-status { display: inline-block; padding: 2px 8px; border-radius: 10px; font-size: 11px; font-weight: bold; }
        .badge-open   { background: #d5f5e3; color: #1e8449; }
        .badge-closed { background: #f2dede; color: #a94442; }
        .empty { text-align: center; padding: 60px 0; color: #aaa; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<main>
    <div class="page-header">
        <h2>팀플 모집</h2>
        <c:if test="${not empty loginMember}">
            <a href="${pageContext.request.contextPath}/team/write" class="btn-write">+ 모집 등록</a>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty teamList}">
            <div class="empty">등록된 팀플 모집이 없습니다.</div>
        </c:when>
        <c:otherwise>
            <div class="card-grid">
                <c:forEach var="t" items="${teamList}">
                    <div class="card">
                        <a href="${pageContext.request.contextPath}/team/${t.no}">
                            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:6px;">
                                <span class="card-title">${t.title}</span>
                                <span class="badge-status ${t.status == 'OPEN' ? 'badge-open' : 'badge-closed'}">
                                    ${t.status == 'OPEN' ? '모집중' : '마감'}
                                </span>
                            </div>
                            <div class="card-desc">${t.description}</div>
                            <div class="card-meta">
                                <span>작성자: ${t.writer}</span>
                                <span>인원: ${t.currentMember}/${t.maxMember}</span>
                                <c:if test="${not empty t.applyDeadline}">
                                    <span>신청마감: ${t.applyDeadline}</span>
                                </c:if>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
