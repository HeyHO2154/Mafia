#http 통신하면 데이터 소실되니까(요청-응답만 하니까), 데이터베이스에 저장해서 활용하는 방식으로 하자
CREATE TABLE game_state (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,         -- 유저 ID
    game_id INT NOT NULL,                  -- 게임 ID (게임마다 고유한 ID)
    job INT,                               -- 유저 직업 (-1: 마피아, 0: 시민, 1: 경찰, 2: 의사)
    job_claim INT DEFAULT 99,              -- 유저가 주장하는 직업 (99: 아직 주장하지 않음)
    personal INT,                          -- 유저의 성향 (명예로움, 순수함, 이기적인, 사악한)
    alive BOOLEAN DEFAULT TRUE,            -- 생존 여부
    find BOOLEAN DEFAULT FALSE,            -- 경찰이 조사를 통해 마피아로 판명된 경우
    find_fake BOOLEAN DEFAULT FALSE,       -- 마피아가 경찰인 척하여 유저를 조사한 경우
    pick INT DEFAULT -1,                   -- 유저가 선택한 타겟
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (game_id) REFERENCES game(id)
);
