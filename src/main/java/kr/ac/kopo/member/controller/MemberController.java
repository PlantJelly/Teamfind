package kr.ac.kopo.member.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.ac.kopo.board.service.BoardService;
import kr.ac.kopo.member.service.MemberService;
import kr.ac.kopo.member.util.KakaoOAuthUtil;
import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.team.service.TeamService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;


@Controller
@RequestMapping("/member")
public class MemberController {

    private static final String PYTHON_SERVER = "http://localhost:5000";

    @Autowired
    private MemberService memberService;

    @Autowired
    private BoardService boardService;

    @Autowired
    private TeamService teamService;

    @Autowired
    private RestTemplate restTemplate;

    @Autowired
    private KakaoOAuthUtil kakaoOAuthUtil;

    @GetMapping("/registerForm")
    public String registerForm(Model model) {
        model.addAttribute("memberVO", new MemberVO());
        return "member/registerForm";
    }

    @PostMapping("/register")
    public String register(@Valid @ModelAttribute MemberVO member,
                           BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "member/registerForm";
        }
        if (memberService.countById(member.getMemberId()) > 0) {
            model.addAttribute("idError", "이미 사용 중인 아이디입니다.");
            return "member/registerForm";
        }
        member.setRole("USER");
        memberService.insert(member);
        return "redirect:/member/login";
    }

    @GetMapping("/login")
    public String loginForm(Model model) {
        model.addAttribute("kakaoClientId", kakaoOAuthUtil.getClientId());
        model.addAttribute("kakaoRedirectUri", kakaoOAuthUtil.getRedirectUri());
        return "member/loginForm";
    }

    @PostMapping("/login")
    public String login(@RequestParam String memberId,
                        @RequestParam String memberPwd,
                        HttpSession session, Model model) {
        MemberVO member = memberService.selectById(memberId);
        if (member == null || !member.getMemberPwd().equals(memberPwd)) {
            model.addAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
            model.addAttribute("kakaoClientId", kakaoOAuthUtil.getClientId());
            model.addAttribute("kakaoRedirectUri", kakaoOAuthUtil.getRedirectUri());
            return "member/loginForm";
        }
        session.setAttribute("loginMember", member);
        return "redirect:/";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/myPage")
    public String myPage(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        MemberVO member = memberService.selectByNo(loginMember.getMemberNo());
        model.addAttribute("member", member);

        boolean faceRegistered = false;
        try {
            ResponseEntity<Map> resp = restTemplate.getForEntity(
                    PYTHON_SERVER + "/face/status/" + member.getMemberId(), Map.class);
            faceRegistered = Boolean.TRUE.equals(resp.getBody().get("registered"));
        } catch (Exception ignored) {}
        model.addAttribute("faceRegistered", faceRegistered);
        model.addAttribute("myBoardList", boardService.selectListByWriter(member.getNickname()));
        model.addAttribute("myTeamList", teamService.selectListByWriterNo(member.getMemberNo()));
        model.addAttribute("myApplyList", teamService.selectApplyListByApplicant(member.getMemberNo()));

        return "member/myPage";
    }

    @GetMapping("/editForm")
    public String editForm(HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        MemberVO member = memberService.selectByNo(loginMember.getMemberNo());
        model.addAttribute("member", member);
        return "member/editForm";
    }

    @PostMapping("/edit")
    public String edit(@RequestParam String nickname,
                       @RequestParam(required = false) String phone,
                       @RequestParam(required = false) String email,
                       HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        MemberVO member = new MemberVO();
        member.setMemberNo(loginMember.getMemberNo());
        member.setNickname(nickname);
        member.setPhone(phone);
        member.setEmail(email);
        memberService.update(member);

        loginMember.setNickname(nickname);
        session.setAttribute("loginMember", loginMember);
        return "redirect:/member/myPage";
    }

    @PostMapping("/withdraw")
    public String withdraw(@RequestParam String memberPwd,
                           HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/member/login";
        }
        MemberVO member = memberService.selectByNo(loginMember.getMemberNo());
        if (!"KAKAO".equals(member.getSnsType())) {
            if (member.getMemberPwd() == null || !member.getMemberPwd().equals(memberPwd)) {
                model.addAttribute("pwdError", "비밀번호가 올바르지 않습니다.");
                model.addAttribute("member", member);
                return "member/myPage";
            }
        }
        try {
            restTemplate.delete(PYTHON_SERVER + "/face/" + member.getMemberId());
        } catch (Exception ignored) {}
        memberService.withdrawAll(member);
        session.invalidate();
        return "redirect:/";
    }

    @GetMapping("/checkId")
    @ResponseBody
    public Map<String, Boolean> checkId(@RequestParam String memberId) {
        Map<String, Boolean> result = new HashMap<>();
        result.put("available", memberService.countById(memberId) == 0);
        return result;
    }

    @PostMapping(value = "/face/login", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseBody
    public Map<String, Object> faceLogin(@RequestParam MultipartFile image,
                                          HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        try {
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            byte[] bytes = image.getBytes();
            body.add("image", new ByteArrayResource(bytes) {
                @Override public String getFilename() { return "face.jpg"; }
            });

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            ResponseEntity<Map> response = restTemplate.postForEntity(
                    PYTHON_SERVER + "/face/recognize",
                    new HttpEntity<>(body, headers),
                    Map.class);

            String memberId = (String) response.getBody().get("memberId");
            MemberVO member = memberService.selectById(memberId);
            if (member != null) {
                session.setAttribute("loginMember", member);
                result.put("success", true);
            } else {
                result.put("success", false);
                result.put("message", "회원 정보를 찾을 수 없습니다.");
            }
        } catch (org.springframework.web.client.HttpClientErrorException e) {
            result.put("success", false);
            result.put("message", e.getStatusCode().value() == 404
                    ? "일치하는 회원을 찾을 수 없습니다." : "얼굴 인식에 실패했습니다.");
        } catch (org.springframework.web.client.ResourceAccessException e) {
            result.put("success", false);
            result.put("message", "Python 서버에 연결할 수 없습니다.");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "서버 오류: " + e.getMessage());
        }
        return result;
    }

    @PostMapping(value = "/face/register", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @ResponseBody
    public Map<String, Object> faceRegister(@RequestParam MultipartFile image,
                                             HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return result;
        }
        try {
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("member_id", loginMember.getMemberId());
            byte[] bytes = image.getBytes();
            body.add("image", new ByteArrayResource(bytes) {
                @Override public String getFilename() { return "face.jpg"; }
            });

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            restTemplate.postForEntity(
                    PYTHON_SERVER + "/face/register",
                    new HttpEntity<>(body, headers),
                    Map.class);

            result.put("success", true);
            result.put("message", "얼굴이 등록되었습니다.");
        } catch (org.springframework.web.client.ResourceAccessException e) {
            result.put("success", false);
            result.put("message", "Python 서버에 연결할 수 없습니다.");
        } catch (org.springframework.web.client.HttpClientErrorException e) {
            String body = e.getResponseBodyAsString();
            String msg = "얼굴 등록 실패";
            try {
                com.fasterxml.jackson.databind.JsonNode node =
                    new com.fasterxml.jackson.databind.ObjectMapper().readTree(body);
                if (node.has("detail")) msg = node.get("detail").asText();
            } catch (Exception ignored) {}
            result.put("success", false);
            result.put("message", msg);
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "얼굴 등록 실패: " + e.getMessage());
        }
        return result;
    }

    @GetMapping("/kakao/callback")
    public String kakaoCallback(@RequestParam String code,
                                HttpSession session) {
        try {
            String accessToken = kakaoOAuthUtil.getAccessToken(code);
            MemberVO kakaoMember = kakaoOAuthUtil.getUserInfo(accessToken);

            MemberVO existing = memberService.selectById(kakaoMember.getMemberId());
            if (existing == null) {
                kakaoMember.setMemberPwd("");
                memberService.insert(kakaoMember);
                existing = memberService.selectById(kakaoMember.getMemberId());
            }
            session.setAttribute("loginMember", existing);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:/";
    }
}
