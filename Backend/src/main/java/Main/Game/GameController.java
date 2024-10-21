package Main.Game;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class GameController {

    private Map<String, Game> gameSessions = new HashMap<>();

    @PostMapping("/start_game")
    public void startGame(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        Game gameData = new Game();	// 플레이어별로 고유한 게임 데이터를 생성
        gameSessions.put(userId, gameData); //중복 요청시 초기화
    }
    
    @PostMapping("/info")
    public ResponseEntity<Map<String, Object>> info(@RequestBody Map<String, String> request) {
        String userId = request.get("userId");
        Game gameData = gameSessions.get(userId);

        Map<String, Object> response = new HashMap<>();
        response.put("player", gameData.getPlayer());  // player 정보를 반환
        response.put("Job", gameData.getJob());        // Job[] 배열 반환
        //전체 생존자 alive[]로 합침
        List<Integer> alive = new ArrayList<>();
        alive.addAll(gameData.getAlive().get(-1));
        alive.addAll(gameData.getAlive().get(1));
        alive.sort(null);
        response.put("alive", alive);        // alive[] 반환

        return ResponseEntity.ok(response);
    }

    @PostMapping("/night")
    public void night(@RequestBody Map<String, Object> request) {
        String userId = (String) request.get("userId");
        Game gameData = gameSessions.get(userId);
        
        gameData.getPick()[gameData.getPlayer()] = (Integer) request.get("target");
        GameLogic.Night(gameData); //밤 로직 처리
    }
    
    @PostMapping("/day")
    public ResponseEntity<Map<String, Object>> day(@RequestBody Map<String, Object> request) {
        String userId = (String) request.get("userId");
        Game gameData = gameSessions.get(userId); // 사용자에 맞는 게임 데이터를 가져옴

        Map<String, Object> response = new HashMap<>();
        if(GameLogic.Day(gameData)) {
        	response.put("deadPlayer", gameData.getKill());
        }else {
        	response.put("deadPlayer", 99);
        }
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/discussion")
    public void discussion(@RequestBody Map<String, Object> request) {
        String userId = (String) request.get("userId");
        int Act = (Integer) request.get("Act");
        Game gameData = gameSessions.get(userId);
        /*
         * 플레이어 선택(의견내기, 직업공개, 가만있기)에 따른 변화
         */
    }
}

