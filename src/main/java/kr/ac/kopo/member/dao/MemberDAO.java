package kr.ac.kopo.member.dao;

import kr.ac.kopo.member.vo.MemberVO;
import java.util.List;

public interface MemberDAO {

    void insert(MemberVO member);

    MemberVO selectById(String memberId);

    MemberVO selectByNo(int memberNo);

    void update(MemberVO member);

    void delete(int memberNo);

    void deleteNotifications(int memberNo);

    void deleteTeamApplies(int memberNo);

    void deleteTeamAppliesByWriter(int memberNo);

    void deleteTeams(int memberNo);

    void deleteBoards(String memberId);

    List<MemberVO> selectAll();

    int countById(String memberId);
}
