package kr.ac.kopo.board.service;

import kr.ac.kopo.board.dao.BoardDAO;
import kr.ac.kopo.board.vo.BoardVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardDAO boardDAO;

    @Override
    public List<BoardVO> selectList() {
        return boardDAO.selectList();
    }

    @Override
    public List<BoardVO> selectListBySearch(String type, String keyword) {
        return boardDAO.selectListBySearch(type, keyword);
    }

    @Override
    public List<BoardVO> selectListByWriter(String writer) {
        return boardDAO.selectListByWriter(writer);
    }

    @Override
    public BoardVO selectOne(int no) {
        return boardDAO.selectOne(no);
    }

    @Override
    public void insert(BoardVO board) {
        boardDAO.insert(board);
    }

    @Override
    public void update(BoardVO board) {
        boardDAO.update(board);
    }

    @Override
    public void delete(int no) {
        boardDAO.delete(no);
    }

    @Override
    public void updateViewCnt(int no) {
        boardDAO.updateViewCnt(no);
    }
}
