<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; }
        .container { max-width: 400px; margin: 80px auto; background: #fff; padding: 30px; border-radius: 8px; }
        h2 { text-align: center; margin-bottom: 24px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; margin-bottom: 4px; font-weight: bold; }
        input[type=text], input[type=password] { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        .btn-primary { background: #333; color: #fff; width: 100%; padding: 10px; font-size: 15px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-kakao { background: #FEE500; color: #000; width: 100%; padding: 10px; font-size: 15px; border: none; border-radius: 4px; cursor: pointer; margin-top: 10px; }
        .btn-face  { background: #1a1a2e; color: #fff; width: 100%; padding: 10px; font-size: 15px; border: none; border-radius: 4px; cursor: pointer; margin-top: 10px; }
        .error { color: red; font-size: 13px; margin-bottom: 10px; }
        a { color: #333; }
        .divider { text-align: center; margin: 16px 0; color: #aaa; }
        /* 얼굴 인식 모달 */
        .face-modal-bg { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.7); z-index: 2000; justify-content: center; align-items: center; }
        .face-modal-bg.open { display: flex; }
        .face-modal { background: #fff; border-radius: 10px; padding: 24px; width: 380px; text-align: center; }
        .face-modal h3 { margin-bottom: 14px; font-size: 17px; }
        .face-modal video { width: 100%; border-radius: 6px; background: #000; }
        .face-modal .face-btns { display: flex; gap: 8px; margin-top: 12px; justify-content: center; }
        .face-modal .face-btns button { padding: 8px 18px; border: none; border-radius: 4px; cursor: pointer; font-size: 13px; }
        .btn-close-modal { background: #eee; color: #333; }
        .face-status { margin-top: 10px; font-size: 13px; min-height: 18px; color: #555; }
        .scan-bar { height: 3px; background: linear-gradient(to right, transparent, #e67e22, transparent);
                    animation: scan 1.5s linear infinite; margin-top: 4px; border-radius: 2px; }
        @keyframes scan { 0%{opacity:0.3} 50%{opacity:1} 100%{opacity:0.3} }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/jsp/common/header.jsp"/>
<div class="container">
    <h2>로그인</h2>
    <c:if test="${not empty loginError}">
        <div class="error">${loginError}</div>
    </c:if>
    <form action="${pageContext.request.contextPath}/member/login" method="post">
        <div class="form-group">
            <label>아이디</label>
            <input type="text" name="memberId" required/>
        </div>
        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="memberPwd" required/>
        </div>
        <button type="submit" class="btn-primary">로그인</button>
    </form>
    <div class="divider">또는</div>
    <button class="btn-kakao" onclick="location.href='https://kauth.kakao.com/oauth/authorize?client_id=${kakaoClientId}&redirect_uri=${kakaoRedirectUri}&response_type=code'">
        카카오로 로그인
    </button>
    <button class="btn-face" onclick="openFaceModal()">
        📷 얼굴로 로그인
    </button>
    <p style="text-align:center; margin-top:16px;">
        <a href="${pageContext.request.contextPath}/member/registerForm">아직 계정이 없으신가요? 회원가입</a>
    </p>
</div>

<!-- 얼굴 인식 모달 -->
<div class="face-modal-bg" id="faceModalBg">
    <div class="face-modal">
        <h3>📷 얼굴 인식 로그인</h3>
        <video id="faceVideo" autoplay playsinline></video>
        <div class="scan-bar" id="scanBar"></div>
        <div class="face-status" id="faceStatus">카메라를 정면으로 봐주세요.</div>
        <div class="face-btns">
            <button class="btn-close-modal" onclick="closeFaceModal()">닫기</button>
        </div>
    </div>
</div>

<script>
(function() {
    var ctx = '${pageContext.request.contextPath}';
    var currentStream = null;
    var scanTimer = null;
    var scanning = false;
    var canvas = document.createElement('canvas');

    function sendFrame() {
        if (scanning) return;
        var video = document.getElementById('faceVideo');
        if (!video.videoWidth) return;

        scanning = true;
        canvas.width  = video.videoWidth;
        canvas.height = video.videoHeight;
        canvas.getContext('2d').drawImage(video, 0, 0);

        canvas.toBlob(function(blob) {
            var formData = new FormData();
            formData.append('image', blob, 'face.jpg');

            fetch(ctx + '/member/face/login', { method: 'POST', body: formData })
                .then(function(r) { return r.json(); })
                .then(function(data) {
                    if (data.success) {
                        clearInterval(scanTimer);
                        document.getElementById('scanBar').style.display = 'none';
                        document.getElementById('faceStatus').textContent = '✅ 인식 성공! 로그인 중...';
                        setTimeout(function() { location.href = ctx + '/'; }, 800);
                    } else {
                        document.getElementById('faceStatus').textContent = '인식 중... (카메라를 정면으로 봐주세요)';
                        scanning = false;
                    }
                })
                .catch(function() {
                    scanning = false;
                });
        }, 'image/jpeg', 0.9);
    }

    window.openFaceModal = function() {
        document.getElementById('faceModalBg').classList.add('open');
        scanning = false;
        document.getElementById('scanBar').style.display = 'block';
        document.getElementById('faceStatus').textContent = '카메라를 정면으로 봐주세요.';

        navigator.mediaDevices.getUserMedia({ video: true })
            .then(function(stream) {
                currentStream = stream;
                document.getElementById('faceVideo').srcObject = stream;
                scanTimer = setInterval(sendFrame, 1500);
            })
            .catch(function(err) {
                document.getElementById('faceStatus').textContent = '카메라 오류: ' + err.message;
            });
    };

    window.closeFaceModal = function() {
        clearInterval(scanTimer);
        scanTimer = null;
        scanning = false;
        if (currentStream) {
            currentStream.getTracks().forEach(function(t) { t.stop(); });
            currentStream = null;
        }
        document.getElementById('faceModalBg').classList.remove('open');
    };
})();
</script>
</body>
</html>
