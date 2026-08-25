package kr.ac.kopo.board.service;

import kr.ac.kopo.board.vo.BoardVO;
import java.util.List;

public interface BoardService {

    List<BoardVO> selectList();

    List<BoardVO> selectListBySearch(String type, String keyword);

    List<BoardVO> selectListByWriter(String writer);

    BoardVO selectOne(int no);

    void insert(BoardVO board);

    void update(BoardVO board);

    void delete(int no);

    void updateViewCnt(int no);
}
