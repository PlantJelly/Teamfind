package kr.ac.kopo.reply.controller;

import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.reply.service.ReplyService;
import kr.ac.kopo.reply.vo.ReplyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reply")
public class ReplyController {

    @Autowired
    private ReplyService replyService;

    @GetMapping("/{boardNo}")
    public List<ReplyVO> getReplyAll(@PathVariable int boardNo) {
        return replyService.selectReplyAll(boardNo);
    }

    @PostMapping("/{boardNo}")
    public void insertReply(@PathVariable int boardNo,
                            @RequestBody ReplyVO reply,
                            HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return;
        reply.setBoardNo(boardNo);
        reply.setWriter(loginMember.getNickname());
        reply.setParentNo(0);
        reply.setDepth(0);
        replyService.insertReply(reply);
    }

    @PostMapping("/{boardNo}/child/{parentNo}")
    public void insertChildReply(@PathVariable int boardNo,
                                 @PathVariable int parentNo,
                                 @RequestBody ReplyVO reply,
                                 HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return;
        reply.setBoardNo(boardNo);
        reply.setParentNo(parentNo);
        reply.setWriter(loginMember.getNickname());
        replyService.insertChildReply(reply);
    }

    @PutMapping("/{replyNo}")
    public void updateReply(@PathVariable int replyNo,
                            @RequestBody ReplyVO reply) {
        reply.setNo(replyNo);
        replyService.updateReply(reply);
    }

    @DeleteMapping("/{replyNo}")
    public void deleteReply(@PathVariable int replyNo) {
        replyService.deleteReply(replyNo);
    }
}
