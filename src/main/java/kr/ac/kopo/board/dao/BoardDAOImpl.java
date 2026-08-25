package kr.ac.kopo.board.dao;

import kr.ac.kopo.board.vo.BoardVO;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class BoardDAOImpl implements BoardDAO {

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    @Override
    public List<BoardVO> selectList() {
        return sqlSessionTemplate.selectList("board.dao.BoardDAO.selectList");
    }

    @Override
    public List<BoardVO> selectListBySearch(String type, String keyword) {
        Map<String, String> params = new HashMap<>();
        params.put("type", type);
        params.put("keyword", keyword);
        return sqlSessionTemplate.selectList("board.dao.BoardDAO.selectListBySearch", params);
    }

    @Override
    public List<BoardVO> selectListByWriter(String writer) {
        return sqlSessionTemplate.selectList("board.dao.BoardDAO.selectListByWriter", writer);
    }

    @Override
    public BoardVO selectOne(int no) {
        return sqlSessionTemplate.selectOne("board.dao.BoardDAO.selectOne", no);
    }

    @Override
    public void insert(BoardVO board) {
        sqlSessionTemplate.insert("board.dao.BoardDAO.insert", board);
    }

    @Override
    public void update(BoardVO board) {
        sqlSessionTemplate.update("board.dao.BoardDAO.update", board);
    }

    @Override
    public void delete(int no) {
        sqlSessionTemplate.delete("board.dao.BoardDAO.delete", no);
    }

    @Override
    public void updateViewCnt(int no) {
        sqlSessionTemplate.update("board.dao.BoardDAO.updateViewCnt", no);
    }
}
