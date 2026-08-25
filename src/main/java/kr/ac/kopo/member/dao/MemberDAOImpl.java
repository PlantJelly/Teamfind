package kr.ac.kopo.member.dao;

import kr.ac.kopo.member.vo.MemberVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class MemberDAOImpl implements MemberDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public void insert(MemberVO member) {
        sqlSessionTemplate.insert("member.dao.MemberDAO.insert", member);
    }

    @Override
    public MemberVO selectById(String memberId) {
        return sqlSessionTemplate.selectOne("member.dao.MemberDAO.selectById", memberId);
    }

    @Override
    public MemberVO selectByNo(int memberNo) {
        return sqlSessionTemplate.selectOne("member.dao.MemberDAO.selectByNo", memberNo);
    }

    @Override
    public void update(MemberVO member) {
        sqlSessionTemplate.update("member.dao.MemberDAO.update", member);
    }

    @Override
    public void delete(int memberNo) {
        sqlSessionTemplate.delete("member.dao.MemberDAO.delete", memberNo);
    }

    @Override
    public void deleteNotifications(int memberNo) {
        sqlSessionTemplate.delete("member.dao.MemberDAO.deleteNotifications", memberNo);
    }

    @Override
    public void deleteTeamApplies(int memberNo) {
        sqlSessionTemplate.delete("member.dao.MemberDAO.deleteTeamApplies", memberNo);
    }

    @Override
    public void deleteTeamAppliesByWriter(int memberNo) {
        sqlSessionTemplate.delete("member.dao.MemberDAO.deleteTeamAppliesByWriter", memberNo);
    }

    @Override
    public void deleteTeams(int memberNo) {
        sqlSessionTemplate.delete("member.dao.MemberDAO.deleteTeams", memberNo);
    }

    @Override
    public void deleteBoards(String memberId) {
        sqlSessionTemplate.delete("member.dao.MemberDAO.deleteBoards", memberId);
    }

    @Override
    public List<MemberVO> selectAll() {
        return sqlSessionTemplate.selectList("member.dao.MemberDAO.selectAll");
    }

    @Override
    public int countById(String memberId) {
        return sqlSessionTemplate.selectOne("member.dao.MemberDAO.countById", memberId);
    }
}
