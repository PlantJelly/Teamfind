package kr.ac.kopo.member.service;

import java.util.List;

import kr.ac.kopo.member.vo.MemberVO;

public interface MemberService {
	
    void insert(MemberVO member);
    
    MemberVO selectById(String memberId);
    
    MemberVO selectByNo(int memberNo);
    
    void update(MemberVO member);
    
    void delete(int memberNo);
    
    void withdrawAll(MemberVO member);
    
    List<MemberVO> selectAll();
    
    int countById(String memberId);
}
