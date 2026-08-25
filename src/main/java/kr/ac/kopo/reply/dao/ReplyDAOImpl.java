package kr.ac.kopo.reply.dao;

import kr.ac.kopo.reply.vo.ReplyVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ReplyDAOImpl implements ReplyDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<ReplyVO> selectReplyAll(int boardNo) {
        return sqlSessionTemplate.selectList("reply.dao.ReplyDAO.selectReplyAll", boardNo);
    }

    @Override
    public void insertReply(ReplyVO reply) {
        sqlSessionTemplate.insert("reply.dao.ReplyDAO.insertReply", reply);
    }

    @Override
    public void insertChildReply(ReplyVO reply) {
        sqlSessionTemplate.insert("reply.dao.ReplyDAO.insertChildReply", reply);
    }

    @Override
    public void updateReply(ReplyVO reply) {
        sqlSessionTemplate.update("reply.dao.ReplyDAO.updateReply", reply);
    }

    @Override
    public void deleteReply(int replyNo) {
        sqlSessionTemplate.delete("reply.dao.ReplyDAO.deleteReply", replyNo);
    }
}
