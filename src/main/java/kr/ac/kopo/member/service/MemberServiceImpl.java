package kr.ac.kopo.member.service;

import kr.ac.kopo.member.dao.MemberDAO;
import kr.ac.kopo.member.vo.MemberVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberDAO memberDAO;

    @Override
    public void insert(MemberVO member) {
        memberDAO.insert(member);
    }

    @Override
    public MemberVO selectById(String memberId) {
        return memberDAO.selectById(memberId);
    }

    @Override
    public MemberVO selectByNo(int memberNo) {
        return memberDAO.selectByNo(memberNo);
    }

    @Override
    public void update(MemberVO member) {
        memberDAO.update(member);
    }

    @Override
    public void delete(int memberNo) {
        memberDAO.delete(memberNo);
    }

    @Override
    public void withdrawAll(MemberVO member) {
        memberDAO.deleteNotifications(member.getMemberNo());
        memberDAO.deleteTeamApplies(member.getMemberNo());          // 본인이 신청한 applies
        memberDAO.deleteTeamAppliesByWriter(member.getMemberNo()); // 본인 팀에 남들이 신청한 applies
        memberDAO.deleteTeams(member.getMemberNo());
        memberDAO.deleteBoards(member.getMemberId());
        memberDAO.delete(member.getMemberNo());
    }

    @Override
    public List<MemberVO> selectAll() {
        return memberDAO.selectAll();
    }

    @Override
    public int countById(String memberId) {
        return memberDAO.countById(memberId);
    }
}
