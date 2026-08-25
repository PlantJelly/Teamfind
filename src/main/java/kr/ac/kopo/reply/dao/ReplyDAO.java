package kr.ac.kopo.reply.dao;

import kr.ac.kopo.reply.vo.ReplyVO;
import java.util.List;

public interface ReplyDAO {

    List<ReplyVO> selectReplyAll(int boardNo);

    void insertReply(ReplyVO reply);

    void insertChildReply(ReplyVO reply);

    void updateReply(ReplyVO reply);

    void deleteReply(int replyNo);
}
