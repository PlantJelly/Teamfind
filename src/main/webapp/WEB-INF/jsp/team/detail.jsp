<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${team.title}</title>
    <style>
        main { padding: 24px; max-width: 800px; margin: 0 auto; }
        .team-header { border-bottom: 2px solid #1a1a2e; padding-bottom: 12px; margin-bottom: 20px; }
        .team-header h2 { font-size: 22px; margin-bottom: 6px; }
        .team-meta { font-size: 13px; color: #777; display: flex; flex-wrap: wrap; gap: 12px; }
        .badge-status { display: inline-block; padding: 3px 10px; border-radius: 10px; font-size: 12px; font-weight: bold; }
        .badge-open   { background: #d5f5e3; color: #1e8449; }
        .badge-closed { background: #f2dede; color: #a94442; }
        .section { margin-bottom: 24px; }
        .section h3 { font-size: 15px; font-weight: bold; border-left: 3px solid #e67e22; padding-left: 8px; margin-bottom: 10px; }
        .section p  { font-size: 14px; color: #444; line-height: 1.7; white-space: pre-wrap; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 12px; margin-bottom: 24px; }
        .info-card { background: #f7f7f7; border-radius: 6px; padding: 12px 14px; }
        .info-card .label { font-size: 11px; color: #999; margin-bottom: 4px; }
        .info-card .value { font-size: 15px; font-weight: bold; color: #333; }
        .btn-area { display: flex; gap: 10px; margin-top: 16px; }
        .btn { padding: 9px 20px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; text-decoration: none; }
        .btn-apply    { background: #e67e22; color: #fff; }
        .btn-applies  { background: #2980b9; color: #fff; }
        .btn-edit     { background: #27ae60; color: #fff; }
        .btn-delete   { background: #e74c3c; color: #fff; }
        .btn-back     { background: #aaa; color: #fff; }
        .apply-box { background: #fff8f0; border: 1px solid #e67e22; border-radius: 8px; padding: 20px; margin-top: 20px; }
        .apply-box h3 { margin-bottom: 12px; font-size: 15px; color: #e67e22; }
        .apply-box textarea { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;
                               resize: vertical; font-size: 14px; box-sizing: border-box; }
        .apply-box .apply-btns { display: flex; gap: 8px; margin-top: 10px; justify-content: flex-end; }
        .status-msg { padding: 12px 16px; border-radius: 6px; font-size: 14px; margin-top: 16px; }
        .status-pending  { background: #fef9e7; border: 1px solid #f39c12; color: #856404; }
        .status-approved { background: #d5f5e3; border: 1px solid #27ae60; color: #1e8449; }
        .status-rejected { background: #f2dede; border: 1px solid #e74c3c; color: #a94442; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<main>
    <div class="team-header">
        <h2>
            ${team.title}
            <span class="badge-status ${team.status == 'OPEN' ? 'badge-open' : 'badge-closed'}" style="font-size:13px; vertical-align:middle;">
                ${team.status == 'OPEN' ? '모집중' : '마감'}
            </span>
        </h2>
        <div class="team-meta">
            <span>작성자: <strong>${team.writer}</strong></span>
            <span>등록일: ${team.regDate}</span>
        </div>
    </div>

    <div class="info-grid">
        <div class="info-card">
            <div class="label">현재 인원</div>
            <div class="value">${team.currentMember} / ${team.maxMember}명</div>
        </div>
        <c:if test="${not empty team.applyDeadline}">
            <div class="info-card">
                <div class="label">신청 마감일</div>
                <div class="value">${team.applyDeadline}</div>
            </div>
        </c:if>
        <c:if test="${not empty team.teamDeadline}">
            <div class="info-card">
                <div class="label">팀플 마감일</div>
                <div class="value">${team.teamDeadline}</div>
            </div>
        </c:if>
    </div>

    <div class="section">
        <h3>팀 설명</h3>
        <p>${team.description}</p>
    </div>

    <c:if test="${not empty team.requirements}">
        <div class="section">
            <h3>요구사항</h3>
            <p>${team.requirements}</p>
        </div>
    </c:if>

    <div class="btn-area">
        <a href="${pageContext.request.contextPath}/team" class="btn btn-back">← 목록</a>
        <c:if test="${not empty loginMember and loginMember.memberNo == team.writerNo}">
            <a href="${pageContext.request.contextPath}/team/${team.no}/applies" class="btn btn-applies">신청 목록 보기</a>
            <a href="${pageContext.request.contextPath}/team/${team.no}/edit" class="btn btn-edit">수정</a>
            <form action="${pageContext.request.contextPath}/team/${team.no}/delete" method="post" style="display:inline;"
                  onsubmit="return confirm('팀 모집글을 삭제하면 모든 신청 내역도 함께 삭제됩니다. 삭제하시겠습니까?');">
                <button type="submit" class="btn btn-delete">삭제</button>
            </form>
        </c:if>
    </div>

    <!-- 신청 영역 -->
    <c:choose>
        <c:when test="${empty loginMember}">
            <div class="apply-box">
                <p style="color:#777; font-size:14px;"><a href="${pageContext.request.contextPath}/member/login">로그인</a> 후 신청할 수 있습니다.</p>
            </div>
        </c:when>
        <c:when test="${loginMember.memberNo == team.writerNo}">
            <%-- 작성자는 신청 영역 미노출 --%>
        </c:when>
        <c:when test="${team.status == 'CLOSED'}">
            <div class="status-msg status-rejected">이미 모집이 마감된 팀입니다.</div>
        </c:when>
        <c:when test="${not empty myApply}">
            <c:choose>
                <c:when test="${myApply.applyStatus == 'PENDING'}">
                    <div class="status-msg status-pending">신청 완료 — 팀장의 승인을 기다리고 있습니다.</div>
                </c:when>
                <c:when test="${myApply.applyStatus == 'APPROVED'}">
                    <div class="status-msg status-approved">신청이 승인되었습니다. 팀에 합류하셨습니다!</div>
                </c:when>
                <c:when test="${myApply.applyStatus == 'REJECTED'}">
                    <div class="status-msg status-rejected">신청이 반려되었습니다.</div>
                </c:when>
            </c:choose>
        </c:when>
        <c:otherwise>
            <div class="apply-box">
                <h3>팀플 신청</h3>
                <form action="${pageContext.request.contextPath}/team/${team.no}/apply" method="post">
                    <textarea name="applyContent" rows="4"
                              placeholder="신청 사유, 자기소개, 보유 기술 등을 자유롭게 작성해주세요." required></textarea>
                    <div class="apply-btns">
                        <button type="submit" class="btn btn-apply">신청하기</button>
                    </div>
                </form>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
