<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: Arial, sans-serif; background: #f4f4f4; }
    header { background: #1a1a2e; color: #fff; padding: 0 24px; display: flex; justify-content: space-between; align-items: center; height: 54px; }
    header .logo { font-size: 18px; font-weight: bold; }
    header .logo a { color: #fff; text-decoration: none; }
    header nav { display: flex; align-items: center; gap: 4px; }
    header nav a { color: #ccc; text-decoration: none; padding: 6px 12px; border-radius: 4px; font-size: 14px; transition: background 0.15s; }
    header nav a:hover { background: rgba(255,255,255,0.12); color: #fff; }
    header nav a.active { background: rgba(243,156,18,0.2); color: #f39c12; font-weight: bold; }
    .nav-divider { width: 1px; height: 20px; background: rgba(255,255,255,0.2); margin: 0 4px; }
    .notification-wrap { position: relative; display: inline-flex; align-items: center; margin: 0 4px; }
    .notification-bell { cursor: pointer; font-size: 18px; padding: 4px 8px; border-radius: 4px; transition: background 0.15s; user-select: none; }
    .notification-bell:hover { background: rgba(255,255,255,0.12); }
    .badge { background: #e74c3c; color: white; border-radius: 50%; padding: 1px 5px; font-size: 10px; position: absolute; top: -2px; right: -2px; display: none; min-width: 16px; text-align: center; }
    .notification-dropdown { display: none; position: absolute; right: 0; top: 38px; background: #fff; border: 1px solid #ddd; width: 320px; z-index: 1000; box-shadow: 0 4px 12px rgba(0,0,0,0.15); border-radius: 6px; overflow: hidden; }
    .notification-dropdown .noti-header { padding: 10px 14px; background: #f7f7f7; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #eee; }
    .notification-dropdown .noti-header span { font-size: 13px; font-weight: bold; color: #333; }
    .notification-dropdown .noti-read-all { font-size: 12px; color: #3498db; cursor: pointer; background: none; border: none; padding: 0; }
    .notification-dropdown .noti-read-all:hover { text-decoration: underline; }
    .notification-dropdown .noti-item { padding: 11px 14px; border-bottom: 1px solid #f0f0f0; cursor: pointer; color: #333; font-size: 13px; line-height: 1.4; }
    .notification-dropdown .noti-item:hover { background: #f5f5f5; }
    .notification-dropdown .noti-empty { padding: 20px 14px; text-align: center; color: #aaa; font-size: 13px; }
    .nav-nickname { color: #7ecfff; font-weight: bold; }
</style>

<header>
    <div class="logo"><a href="${pageContext.request.contextPath}/">팀플구인사이트</a></div>
    <nav>
        <a href="${pageContext.request.contextPath}/board">게시판</a>
        <a href="${pageContext.request.contextPath}/team">팀플 모집</a>
        <div class="nav-divider"></div>
        <c:choose>
            <c:when test="${not empty loginMember}">
                <a href="${pageContext.request.contextPath}/member/myPage" class="nav-nickname">${loginMember.nickname}</a>
                <c:if test="${loginMember.role == 'ADMIN'}">
                    <a href="${pageContext.request.contextPath}/admin/members">관리자 메뉴</a>
                </c:if>
                <div class="notification-wrap">
                    <span class="notification-bell" onclick="toggleNotification(event)">🔔</span>
                    <span class="badge" id="notiBadge"></span>
                    <div class="notification-dropdown" id="notiDropdown">
                        <div class="noti-header">
                            <span>알림</span>
                            <button class="noti-read-all" onclick="readAll()">모두 읽음</button>
                        </div>
                        <div id="notiList"></div>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/member/logout">로그아웃</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/member/login">로그인</a>
                <a href="${pageContext.request.contextPath}/member/registerForm">회원가입</a>
            </c:otherwise>
        </c:choose>
    </nav>
</header>

<c:if test="${not empty loginMember}">
<script>
(function() {
    var _ctx = '${pageContext.request.contextPath}';

    function loadCount() {
        fetch(_ctx + '/notification/count')
            .then(function(r) { return r.json(); })
            .then(function(data) {
                var badge = document.getElementById('notiBadge');
                if (data.count > 0) {
                    badge.textContent = data.count;
                    badge.style.display = 'inline';
                } else {
                    badge.style.display = 'none';
                }
            });
    }

    window.toggleNotification = function(e) {
        e.stopPropagation();
        var dropdown = document.getElementById('notiDropdown');
        if (dropdown.style.display === 'block') {
            dropdown.style.display = 'none';
        } else {
            dropdown.style.display = 'block';
            loadList();
        }
    };

    function loadList() {
        fetch(_ctx + '/notification/list')
            .then(function(r) { return r.json(); })
            .then(function(list) {
                var container = document.getElementById('notiList');
                if (list.length === 0) {
                    container.innerHTML = '<div class="noti-empty">읽지 않은 알림이 없습니다.</div>';
                    return;
                }
                container.innerHTML = list.map(function(n) {
                    return '<div class="noti-item" onclick="readOne(' + n.no + ',' + (n.relatedBoardNo || 0) + ',' + (n.relatedTeamNo || 0) + ')">'
                        + escHtml(n.message) + '</div>';
                }).join('');
            });
    }

    window.readOne = function(no, boardNo, teamNo) {
        fetch(_ctx + '/notification/' + no + '/read', { method: 'PUT' })
            .then(function() {
                document.getElementById('notiDropdown').style.display = 'none';
                if (teamNo) {
                    location.href = _ctx + '/team/' + teamNo;
                } else if (boardNo) {
                    location.href = _ctx + '/board/' + boardNo;
                }
                loadCount();
            });
    };

    window.readAll = function() {
        fetch(_ctx + '/notification/readAll', { method: 'PUT' })
            .then(function() {
                document.getElementById('notiList').innerHTML = '<div class="noti-empty">읽지 않은 알림이 없습니다.</div>';
                document.getElementById('notiBadge').style.display = 'none';
            });
    };

    function escHtml(str) {
        return String(str).replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
    }

    document.addEventListener('click', function(e) {
        var wrap = document.querySelector('.notification-wrap');
        var dropdown = document.getElementById('notiDropdown');
        if (wrap && dropdown && !wrap.contains(e.target)) {
            dropdown.style.display = 'none';
        }
    });

    loadCount();
})();
</script>
</c:if>
