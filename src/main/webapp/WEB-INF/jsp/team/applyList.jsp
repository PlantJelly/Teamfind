<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>신청 목록 — ${team.title}</title>
    <style>
        main { padding: 24px; max-width: 900px; margin: 0 auto; }
        h2 { margin-bottom: 6px; font-size: 20px; }
        .sub { color: #777; font-size: 13px; margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; background: #fff; border-radius: 8px; overflow: hidden; }
        th, td { padding: 11px 12px; border-bottom: 1px solid #eee; text-align: left; font-size: 13px; }
        th { background: #1a1a2e; color: #fff; font-weight: normal; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }
        .apply-content { max-width: 320px; word-break: break-all; }
        .status-pending  { color: #e67e22; font-weight: bold; }
        .status-approved { color: #27ae60; font-weight: bold; }
        .status-rejected { color: #c00; font-weight: bold; }
        .btn { padding: 5px 12px; border: none; border-radius: 4px; cursor: pointer; font-size: 12px; }
        .btn-approve { background: #27ae60; color: #fff; }
        .btn-reject  { background: #c00; color: #fff; }
        .btn-back { background: #aaa; color: #fff; padding: 8px 16px; border: none; border-radius: 4px;
                    cursor: pointer; font-size: 13px; text-decoration: none; display: inline-block; margin-top: 16px; }
        .empty { text-align: center; padding: 40px; color: #aaa; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<main>
    <h2>신청 목록</h2>
    <div class="sub">
        팀: <strong>${team.title}</strong> &nbsp;|&nbsp;
        인원: ${team.currentMember}/${team.maxMember} &nbsp;|&nbsp;
        상태: ${team.status == 'OPEN' ? '모집중' : '마감'}
    </div>

    <table>
        <thead>
        <tr>
            <th style="width:50px;">번호</th>
            <th style="width:110px;">신청자</th>
            <th>신청 내용</th>
            <th style="width:70px;">상태</th>
            <th style="width:100px;">신청일</th>
            <th style="width:130px;">처리</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="a" items="${applyList}" varStatus="vs">
            <tr>
                <td>${vs.count}</td>
                <td>${a.applicantId}</td>
                <td class="apply-content">${a.applyContent}</td>
                <td>
                    <c:choose>
                        <c:when test="${a.applyStatus == 'PENDING'}">
                            <span class="status-pending">대기중</span>
                        </c:when>
                        <c:when test="${a.applyStatus == 'APPROVED'}">
                            <span class="status-approved">승인됨</span>
                        </c:when>
                        <c:when test="${a.applyStatus == 'REJECTED'}">
                            <span class="status-rejected">반려됨</span>
                        </c:when>
                    </c:choose>
                </td>
                <td>${a.regDate}</td>
                <td>
                    <c:if test="${a.applyStatus == 'PENDING'}">
                        <form action="${pageContext.request.contextPath}/team/apply/${a.no}/approve" method="post" style="display:inline;">
                            <input type="hidden" name="teamNo" value="${team.no}"/>
                            <button type="submit" class="btn btn-approve"
                                    onclick="return confirm('승인하시겠습니까?')">승인</button>
                        </form>
                        <form action="${pageContext.request.contextPath}/team/apply/${a.no}/reject" method="post" style="display:inline; margin-left:4px;">
                            <input type="hidden" name="teamNo" value="${team.no}"/>
                            <button type="submit" class="btn btn-reject"
                                    onclick="return confirm('반려하시겠습니까?')">반려</button>
                        </form>
                    </c:if>
                    <c:if test="${a.applyStatus != 'PENDING'}">
                        <span style="color:#aaa; font-size:12px;">처리완료</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty applyList}">
            <tr><td colspan="6" class="empty">신청 내역이 없습니다.</td></tr>
        </c:if>
        </tbody>
    </table>

    <a href="${pageContext.request.contextPath}/team/${team.no}" class="btn-back">← 팀 상세로 돌아가기</a>
</main>
</body>
</html>
