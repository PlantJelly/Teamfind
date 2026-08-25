package kr.ac.kopo.team.controller;

import jakarta.servlet.http.HttpSession;
import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.team.service.TeamService;
import kr.ac.kopo.team.vo.TeamApplyVO;
import kr.ac.kopo.team.vo.TeamVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/team")
public class TeamController {

    @Autowired
    private TeamService teamService;

    @GetMapping
    public String list(Model model) {
        List<TeamVO> teamList = teamService.selectList();
        model.addAttribute("teamList", teamList);
        return "team/list";
    }

    @GetMapping("/write")
    public String writeForm(HttpSession session) {
        if (session.getAttribute("loginMember") == null) {
            return "redirect:/member/login";
        }
        return "team/write";
    }

    @PostMapping("/write")
    public String write(@RequestParam String title,
                        @RequestParam String description,
                        @RequestParam(required = false) String requirements,
                        @RequestParam int maxMember,
                        @RequestParam(required = false) String applyDeadline,
                        @RequestParam(required = false) String teamDeadline,
                        HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = new TeamVO();
        team.setWriterNo(loginMember.getMemberNo());
        team.setWriter(loginMember.getNickname());
        team.setTitle(title);
        team.setDescription(description);
        team.setRequirements(requirements);
        team.setMaxMember(maxMember);
        team.setStatus("OPEN");
        team.setApplyDeadline(applyDeadline);
        team.setTeamDeadline(teamDeadline);
        teamService.insertTeam(team);
        return "redirect:/team";
    }

    @GetMapping("/{no}")
    public String detail(@PathVariable int no, HttpSession session, Model model) {
        TeamVO team = teamService.selectTeamByNo(no);
        if (team == null) return "redirect:/team";

        model.addAttribute("team", team);

        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember != null && team.getWriterNo() != loginMember.getMemberNo()) {
            TeamApplyVO myApply = teamService.selectMyApply(no, loginMember.getMemberNo());
            model.addAttribute("myApply", myApply);
        }
        return "team/detail";
    }

    @PostMapping("/{no}/apply")
    public String apply(@PathVariable int no,
                        @RequestParam String applyContent,
                        HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(no);
        if (team == null || team.getWriterNo() == loginMember.getMemberNo()) {
            return "redirect:/team/" + no;
        }
        if (teamService.selectMyApply(no, loginMember.getMemberNo()) != null) {
            return "redirect:/team/" + no;
        }

        TeamApplyVO apply = new TeamApplyVO();
        apply.setTeamNo(no);
        apply.setApplicantNo(loginMember.getMemberNo());
        apply.setApplicantId(loginMember.getMemberId());
        apply.setApplyContent(applyContent);
        apply.setApplyStatus("PENDING");

        teamService.applyTeam(apply, team.getWriterNo(), loginMember.getNickname());
        return "redirect:/team/" + no;
    }

    @GetMapping("/{no}/applies")
    public String applyList(@PathVariable int no, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(no);
        if (team == null || team.getWriterNo() != loginMember.getMemberNo()) {
            return "redirect:/team/" + no;
        }

        model.addAttribute("team", team);
        model.addAttribute("applyList", teamService.selectApplyListByTeam(no));
        return "team/applyList";
    }

    @PostMapping("/apply/{applyNo}/approve")
    public String approve(@PathVariable int applyNo,
                          @RequestParam int teamNo,
                          HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(teamNo);
        if (team == null || team.getWriterNo() != loginMember.getMemberNo()) {
            return "redirect:/team";
        }
        teamService.approveApply(applyNo, teamNo);
        return "redirect:/team/" + teamNo + "/applies";
    }

    @GetMapping("/{no}/edit")
    public String editForm(@PathVariable int no, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(no);
        if (team == null || team.getWriterNo() != loginMember.getMemberNo()) {
            return "redirect:/team/" + no;
        }
        model.addAttribute("team", team);
        return "team/edit";
    }

    @PostMapping("/{no}/edit")
    public String edit(@PathVariable int no,
                       @RequestParam String title,
                       @RequestParam String description,
                       @RequestParam(required = false) String requirements,
                       @RequestParam int maxMember,
                       @RequestParam(required = false) String applyDeadline,
                       @RequestParam(required = false) String teamDeadline,
                       HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(no);
        if (team == null || team.getWriterNo() != loginMember.getMemberNo()) {
            return "redirect:/team/" + no;
        }

        team.setTitle(title);
        team.setDescription(description);
        team.setRequirements(requirements);
        team.setMaxMember(maxMember);
        team.setApplyDeadline(applyDeadline);
        team.setTeamDeadline(teamDeadline);
        teamService.updateTeam(team);
        return "redirect:/team/" + no;
    }

    @PostMapping("/{no}/delete")
    public String delete(@PathVariable int no, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(no);
        if (team == null || team.getWriterNo() != loginMember.getMemberNo()) {
            return "redirect:/team/" + no;
        }
        teamService.deleteTeam(no);
        return "redirect:/team";
    }

    @PostMapping("/apply/{applyNo}/reject")
    public String reject(@PathVariable int applyNo,
                         @RequestParam int teamNo,
                         HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";

        TeamVO team = teamService.selectTeamByNo(teamNo);
        if (team == null || team.getWriterNo() != loginMember.getMemberNo()) {
            return "redirect:/team";
        }
        teamService.rejectApply(applyNo, teamNo);
        return "redirect:/team/" + teamNo + "/applies";
    }
}
