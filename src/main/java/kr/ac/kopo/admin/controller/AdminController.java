package kr.ac.kopo.admin.controller;

import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.member.service.MemberService;
import kr.ac.kopo.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private MemberService memberService;

    @GetMapping("/members")
    public String memberList(@RequestParam(defaultValue = "1") int page,
                             HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null || !"ADMIN".equals(loginMember.getRole())) {
            return "redirect:/";
        }

        List<MemberVO> allMembers = memberService.selectAll();
        int pageSize = 10;
        int totalPage = (int) Math.ceil((double) allMembers.size() / pageSize);
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, allMembers.size());
        List<MemberVO> memberList = allMembers.subList(start, end);

        model.addAttribute("memberList", memberList);
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("currentPage", page);
        return "admin/memberList";
    }
}
