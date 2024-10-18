package com.example.demo;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "users") // MySQL에서 users 테이블과 매핑
public class User {

    @Id
    private String userId;  // 아이디 필드
	private String password;  // 비밀번호 필드
    private int point;  // 포인트 필드 추가

    // Getters and Setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}
}
