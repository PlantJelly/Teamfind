package kr.ac.kopo.board.controller;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import kr.ac.kopo.board.service.BoardService;
import kr.ac.kopo.board.vo.BoardVO;
import kr.ac.kopo.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    @GetMapping
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(required = false) String searchType,
                       @RequestParam(required = false) String keyword,
                       Model model) {
        List<BoardVO> allList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            allList = boardService.selectListBySearch(searchType, keyword);
        } else {
            allList = boardService.selectList();
        }

        int pageSize = 10;
        int totalPage = Math.max(1, (int) Math.ceil((double) allList.size() / pageSize));
        if (page > totalPage) page = totalPage;
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, allList.size());

        model.addAttribute("boardList", allList.subList(start, end));
        model.addAttribute("totalPage", totalPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
        return "board/list";
    }

    @GetMapping("/{no}")
    public String detail(@PathVariable int no, Model model) {
        boardService.updateViewCnt(no);
        model.addAttribute("board", boardService.selectOne(no));
        return "board/detail";
    }

    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        if (session.getAttribute("loginMember") == null) return "redirect:/member/login";
        model.addAttribute("boardVO", new BoardVO());
        return "board/write";
    }

    @PostMapping("/write")
    public String write(@Valid @ModelAttribute BoardVO board,
                        BindingResult result,
                        HttpSession session) {
        if (result.hasErrors()) return "board/write";
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        board.setWriter(loginMember.getNickname());
        boardService.insert(board);
        return "redirect:/board";
    }

    @GetMapping("/{no}/edit")
    public String editForm(@PathVariable int no, HttpSession session, Model model) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        BoardVO board = boardService.selectOne(no);
        if (!board.getWriter().equals(loginMember.getNickname())) return "redirect:/board/" + no;
        model.addAttribute("board", board);
        return "board/edit";
    }

    @PutMapping("/{no}")
    public String update(@PathVariable int no,
                         @RequestParam String title,
                         @RequestParam String content,
                         HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        BoardVO board = new BoardVO();
        board.setNo(no);
        board.setTitle(title);
        board.setContent(content);
        boardService.update(board);
        return "redirect:/board/" + no;
    }

    @DeleteMapping("/{no}")
    public String delete(@PathVariable int no, HttpSession session) {
        MemberVO loginMember = (MemberVO) session.getAttribute("loginMember");
        if (loginMember == null) return "redirect:/member/login";
        BoardVO board = boardService.selectOne(no);
        if (!board.getWriter().equals(loginMember.getNickname())) return "redirect:/board/" + no;
        boardService.delete(no);
        return "redirect:/board";
    }
}
