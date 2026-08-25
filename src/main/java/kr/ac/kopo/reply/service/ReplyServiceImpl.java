package kr.ac.kopo.reply.service;

import kr.ac.kopo.reply.dao.ReplyDAO;
import kr.ac.kopo.reply.vo.ReplyVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ReplyServiceImpl implements ReplyService {

    @Autowired
    private ReplyDAO replyDAO;

    @Override
    public List<ReplyVO> selectReplyAll(int boardNo) {
        return replyDAO.selectReplyAll(boardNo);
    }

    @Override
    public void insertReply(ReplyVO reply) {
        replyDAO.insertReply(reply);
    }

    @Override
    public void insertChildReply(ReplyVO reply) {
        replyDAO.insertChildReply(reply);
    }

    @Override
    public void updateReply(ReplyVO reply) {
        replyDAO.updateReply(reply);
    }

    @Override
    public void deleteReply(int replyNo) {
        replyDAO.deleteReply(replyNo);
    }
}
