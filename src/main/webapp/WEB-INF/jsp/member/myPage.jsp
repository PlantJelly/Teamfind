<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 700px; margin: 60px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; }
        td { padding: 10px; border-bottom: 1px solid #eee; }
        td:first-child { font-weight: bold; width: 120px; }
        .btn-area { margin-top: 20px; display: flex; gap: 10px; }
        .btn { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; font-size: 14px; }
        .btn-edit { background: #555; color: #fff; }
        .btn-withdraw { background: #c00; color: #fff; }
        .btn-back { background: #aaa; color: #fff; }
        .error { color: red; margin-bottom: 12px; }
        input[type=password] { padding: 6px; border: 1px solid #ccc; border-radius: 4px; }
        .btn-face { background: #1a1a2e; color: #fff; }
        .face-badge { display: inline-block; font-size: 12px; padding: 2px 8px; border-radius: 10px; margin-left: 8px; font-weight: bold; }
        .face-badge.on  { background: #d4f5e2; color: #1a8a45; }
        .face-badge.off { background: #f5e0e0; color: #c0392b; }
        /* 얼굴 등록 모달 */
        .face-modal-bg { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 2000; justify-content: center; align-items: center; }
        .face-modal-bg.open { display: flex; }
        .face-modal { background: #fff; border-radius: 10px; padding: 24px; width: 380px; text-align: center; }
        .face-modal h3 { margin-bottom: 14px; font-size: 17px; }
        .face-modal video, .face-modal canvas { width: 100%; border-radius: 6px; background: #000; }
        .face-modal canvas { display: none; margin-top: 6px; }
        .face-modal .face-btns { display: flex; gap: 8px; margin-top: 12px; justify-content: center; }
        .face-modal .face-btns button { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .btn-capture  { background: #e67e22; color: #fff; }
        .btn-retake   { background: #aaa; color: #fff; display: none; }
        .btn-save     { background: #27ae60; color: #fff; display: none; }
        .btn-close-modal { background: #eee; color: #333; }
        .face-status { margin-top: 10px; font-size: 13px; min-height: 18px; color: #555; }
        /* 탭 */
        .tabs { display: flex; border-bottom: 2px solid #ddd; margin: 28px 0 0; }
        .tab-btn { padding: 10px 20px; border: none; background: none; cursor: pointer; font-size: 14px;
                   color: #777; border-bottom: 3px solid transparent; margin-bottom: -2px; }
        .tab-btn.active { color: #1a1a2e; font-weight: bold; border-bottom-color: #e67e22; }
        .tab-panel { display: none; padding: 16px 0; }
        .tab-panel.active { display: block; }
        .my-table { width: 100%; border-collapse: collapse; font-size: 13px; }
        .my-table th { background: #f7f7f7; padding: 8px 10px; border-bottom: 1px solid #ddd; text-align: left; }
        .my-table td { padding: 8px 10px; border-bottom: 1px solid #eee; }
        .my-table tr:hover td { background: #fafafa; }
        .my-table a { color: #1a1a2e; text-decoration: none; }
        .my-table a:hover { text-decoration: underline; }
        .empty-msg { color: #999; font-size: 13px; padding: 16px 0; text-align: center; }
        .badge-status { display: inline-block; padding: 2px 8px; border-radius: 8px; font-size: 11px; font-weight: bold; }
        .badge-open     { background: #d5f5e3; color: #1e8449; }
        .badge-closed   { background: #f2dede; color: #a94442; }
        .badge-pending  { background: #fef9e7; color: #856404; }
        .badge-approved { background: #d5f5e3; color: #1e8449; }
        .badge-rejected { background: #f2dede; color: #a94442; }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>마이페이지</h2>
    <c:if test="${not empty pwdError}">
        <div class="error">${pwdError}</div>
    </c:if>
    <table>
        <tr><td>아이디</td><td>${member.memberId}</td></tr>
        <tr><td>닉네임</td><td>${member.nickname}</td></tr>
        <tr><td>전화번호</td><td>${member.phone}</td></tr>
        <tr><td>이메일</td><td>${member.email}</td></tr>
        <tr><td>가입유형</td><td>${empty member.snsType ? '일반' : member.snsType}</td></tr>
        <tr><td>가입일</td><td>${member.regDate}</td></tr>
        <tr>
            <td>얼굴 인식</td>
            <td>
                <c:choose>
                    <c:when test="${faceRegistered}">
                        <span class="face-badge on" id="faceBadge">✔ 등록됨</span>
                    </c:when>
                    <c:otherwise>
                        <span class="face-badge off" id="faceBadge">✘ 미등록</span>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
    <div class="btn-area">
        <a href="${pageContext.request.contextPath}/member/editForm" class="btn btn-edit">정보 수정</a>
        <button type="button" class="btn btn-face" onclick="openFaceModal()">📷 얼굴 등록</button>
        <a href="${pageContext.request.contextPath}/" class="btn btn-back">메인으로</a>
    </div>
    <!-- 활동 탭 -->
    <div class="tabs">
        <button class="tab-btn active" onclick="showTab('board', this)">내 글 목록</button>
        <button class="tab-btn"        onclick="showTab('team',  this)">팀플 목록</button>
        <button class="tab-btn"        onclick="showTab('apply', this)">신청한 팀플</button>
    </div>

    <!-- 내 글 목록 -->
    <div class="tab-panel active" id="tab-board">
        <c:choose>
            <c:when test="${empty myBoardList}">
                <div class="empty-msg">작성한 게시글이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="my-table">
                    <thead><tr><th>제목</th><th>조회</th><th>댓글</th><th>날짜</th></tr></thead>
                    <tbody>
                        <c:forEach var="b" items="${myBoardList}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/board/${b.no}">${b.title}</a></td>
                                <td>${b.viewCnt}</td>
                                <td>${b.replyCnt}</td>
                                <td>${b.regDate}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 팀플 목록 -->
    <div class="tab-panel" id="tab-team">
        <c:choose>
            <c:when test="${empty myTeamList}">
                <div class="empty-msg">등록한 팀플 모집글이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="my-table">
                    <thead><tr><th>팀 이름</th><th>인원</th><th>상태</th><th>신청 마감</th><th>날짜</th></tr></thead>
                    <tbody>
                        <c:forEach var="t" items="${myTeamList}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/team/${t.no}">${t.title}</a></td>
                                <td>${t.currentMember} / ${t.maxMember}</td>
                                <td>
                                    <span class="badge-status ${t.status == 'OPEN' ? 'badge-open' : 'badge-closed'}">
                                        ${t.status == 'OPEN' ? '모집중' : '마감'}
                                    </span>
                                </td>
                                <td>${empty t.applyDeadline ? '-' : t.applyDeadline}</td>
                                <td>${t.regDate}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 신청한 팀플 -->
    <div class="tab-panel" id="tab-apply">
        <c:choose>
            <c:when test="${empty myApplyList}">
                <div class="empty-msg">신청한 팀플이 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="my-table">
                    <thead><tr><th>팀 이름</th><th>신청 상태</th><th>신청일</th></tr></thead>
                    <tbody>
                        <c:forEach var="a" items="${myApplyList}">
                            <tr>
                                <td><a href="${pageContext.request.contextPath}/team/${a.teamNo}">${a.teamTitle}</a></td>
                                <td>
                                    <span class="badge-status
                                        <c:choose>
                                            <c:when test="${a.applyStatus == 'PENDING'}">badge-pending</c:when>
                                            <c:when test="${a.applyStatus == 'APPROVED'}">badge-approved</c:when>
                                            <c:otherwise>badge-rejected</c:otherwise>
                                        </c:choose>">
                                        <c:choose>
                                            <c:when test="${a.applyStatus == 'PENDING'}">대기중</c:when>
                                            <c:when test="${a.applyStatus == 'APPROVED'}">승인</c:when>
                                            <c:otherwise>반려</c:otherwise>
                                        </c:choose>
                                    </span>
                                </td>
                                <td>${a.regDate}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <hr style="margin:28px 0;"/>
    <form action="${pageContext.request.contextPath}/member/withdraw" method="post"
          onsubmit="return confirm('정말 탈퇴하시겠습니까? 모든 데이터가 삭제됩니다.');">
        <p style="color:#c00; font-weight:bold;">회원탈퇴</p>
        <c:choose>
            <c:when test="${member.snsType == 'KAKAO'}">
                <p style="font-size:14px; color:#777; margin-bottom:10px;">카카오 로그인 회원은 별도 비밀번호 확인 없이 탈퇴됩니다.</p>
                <input type="hidden" name="memberPwd" value=""/>
            </c:when>
            <c:otherwise>
                <p style="font-size:14px; margin-bottom:8px;">비밀번호를 입력하면 탈퇴됩니다.</p>
                <input type="password" name="memberPwd" placeholder="비밀번호 입력"/>
            </c:otherwise>
        </c:choose>
        <button type="submit" class="btn btn-withdraw" style="margin-left:8px;">탈퇴하기</button>
    </form>
</div>
</div>

<!-- 얼굴 등록 모달 -->
<div class="face-modal-bg" id="faceModalBg">
    <div class="face-modal">
        <h3>📷 얼굴 등록</h3>
        <video id="faceVideo" autoplay playsinline></video>
        <canvas id="faceCanvas"></canvas>
        <div class="face-status" id="faceStatus">카메라를 정면으로 봐주세요.</div>
        <div class="face-btns">
            <button class="btn-capture" id="captureBtn"  onclick="captureFrame()">촬영</button>
            <button class="btn-retake"  id="retakeBtn"   onclick="retake()">다시 촬영</button>
            <button class="btn-save"    id="saveBtn"     onclick="registerFace()">등록 완료</button>
            <button class="btn-close-modal" onclick="closeFaceModal()">닫기</button>
        </div>
    </div>
</div>

<script>
function showTab(name, btn) {
    document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
    document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
    document.getElementById('tab-' + name).classList.add('active');
    btn.classList.add('active');
}
</script>

<script>
(function() {
    var ctx = '${pageContext.request.contextPath}';
    var currentStream = null;

    window.openFaceModal = function() {
        document.getElementById('faceModalBg').classList.add('open');
        resetModal();
        navigator.mediaDevices.getUserMedia({ video: true })
            .then(function(stream) {
                currentStream = stream;
                document.getElementById('faceVideo').srcObject = stream;
                document.getElementById('faceStatus').textContent = '카메라를 정면으로 봐주세요.';
            })
            .catch(function(err) {
                document.getElementById('faceStatus').textContent = '카메라 오류: ' + err.message;
            });
    };

    window.closeFaceModal = function() {
        document.getElementById('faceModalBg').classList.remove('open');
        if (currentStream) {
            currentStream.getTracks().forEach(function(t) { t.stop(); });
            currentStream = null;
        }
    };

    window.captureFrame = function() {
        var video = document.getElementById('faceVideo');
        var canvas = document.getElementById('faceCanvas');
        canvas.width  = video.videoWidth  || 320;
        canvas.height = video.videoHeight || 240;
        canvas.getContext('2d').drawImage(video, 0, 0);
        video.style.display = 'none';
        canvas.style.display = 'block';
        document.getElementById('captureBtn').style.display = 'none';
        document.getElementById('retakeBtn').style.display  = 'inline';
        document.getElementById('saveBtn').style.display    = 'inline';
        document.getElementById('faceStatus').textContent = '촬영됐습니다. 얼굴을 확인 후 등록 완료를 눌러주세요.';
    };

    window.retake = function() {
        document.getElementById('faceVideo').style.display  = 'block';
        document.getElementById('faceCanvas').style.display = 'none';
        document.getElementById('captureBtn').style.display = 'inline';
        document.getElementById('retakeBtn').style.display  = 'none';
        document.getElementById('saveBtn').style.display    = 'none';
        document.getElementById('faceStatus').textContent = '카메라를 정면으로 봐주세요.';
    };

    window.registerFace = function() {
        var canvas = document.getElementById('faceCanvas');
        document.getElementById('faceStatus').textContent = '등록 중...';
        document.getElementById('saveBtn').disabled = true;

        canvas.toBlob(function(blob) {
            var formData = new FormData();
            formData.append('image', blob, 'face.jpg');

            fetch(ctx + '/member/face/register', { method: 'POST', body: formData })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.success) {
                        document.getElementById('faceStatus').textContent = '✅ 얼굴이 등록되었습니다!';
                        var badge = document.getElementById('faceBadge');
                        badge.textContent = '✔ 등록됨';
                        badge.className = 'face-badge on';
                        setTimeout(closeFaceModal, 1500);
                    } else {
                        document.getElementById('faceStatus').textContent = '❌ ' + (data.message || '등록 실패');
                        document.getElementById('saveBtn').disabled = false;
                    }
                })
                .catch(function() {
                    document.getElementById('faceStatus').textContent = '❌ 서버 오류가 발생했습니다.';
                    document.getElementById('saveBtn').disabled = false;
                });
        }, 'image/jpeg', 0.9);
    };

    function resetModal() {
        document.getElementById('faceVideo').style.display  = 'block';
        document.getElementById('faceCanvas').style.display = 'none';
        document.getElementById('captureBtn').style.display = 'inline';
        document.getElementById('retakeBtn').style.display  = 'none';
        document.getElementById('saveBtn').style.display    = 'none';
        document.getElementById('saveBtn').disabled = false;
        document.getElementById('faceStatus').textContent = '';
    }
})();
</script>
</body>
</html>
