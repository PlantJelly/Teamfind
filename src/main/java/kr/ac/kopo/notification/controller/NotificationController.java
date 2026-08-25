package kr.ac.kopo.notification.controller;

import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.notification.service.NotificationService;
import kr.ac.kopo.notification.vo.NotificationVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notification")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/count")
    public Map<String, Integer> countUnread(HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return Map.of("count", 0);
        }
        return Map.of("count", notificationService.countUnread(loginMember.getMemberNo()));
    }

    @GetMapping("/list")
    public List<NotificationVO> getUnreadList(HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return Collections.emptyList();
        }
        return notificationService.selectUnreadList(loginMember.getMemberNo());
    }

    @PutMapping("/{no}/read")
    public void readOne(@PathVariable int no) {
        notificationService.deleteOne(no);
    }

    @PutMapping("/readAll")
    public void readAll(HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return;
        notificationService.deleteAllByMemberNo(loginMember.getMemberNo());
    }
}
