package Main.Game;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class GameLogic {

	//사용자가 밤에 행동한 직후
	static void Night(Game gameData) {
        
        int N = gameData.getN();
        int player = gameData.getPlayer();
        int[] personal = gameData.getPersonal();
		int[] Job = gameData.getJob();
		int[] Job_claim = gameData.getJob_claim();
		int[] pick = gameData.getPick();
		Map<Integer, List<Integer>> Alive = gameData.getAlive();
		Map<Integer, List<Integer>> Enemy = gameData.getEnemy();
	    
		//밤
		gameData.setKill(-1); //죽일 타겟 초기화
		gameData.setLive(-1);; //살릴 대상 초기화
		for (int i = 0; i < N; i++) {
			if(Alive.get(1).contains(i) || Alive.get(-1).contains(i)) {
				if(i==player) {
					switch (Job[player]) {
					case -1:
						GameAct.Kill(player, pick[player], gameData);
						break;
					case 1:
						GameAct.Find(player, pick[player], gameData);
						break;
					case 2:
						GameAct.Live(player, pick[player], gameData);
						break;
					}
				}else {
					List<Integer> list = new ArrayList<>();
					if(Alive.get(1).contains(i)) {
						switch (personal[i]) {
						case 1:	
							switch(Job[i]) {
								case 1:
									//특수 직업 검증하거나 랜덤 조사
									list = new ArrayList<>();
									for (int j = 0; j < Job_claim.length; j++) {
										if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
											list.add(j);
										}
									}
									if(!list.isEmpty()) {
										GameAct.Find(i, GameAct.RandomWho(list, i), gameData);
									}else {
										GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
								case 2:
									//특수 직업 치료하거나 랜덤 치료
									list = new ArrayList<>();
									for (int j = 0; j < Job_claim.length; j++) {
										if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
											list.add(j);
										}
									}
									if(!list.isEmpty()) {
										GameAct.Live(i, GameAct.RandomWho(list, i), gameData);
									}else {
										GameAct.Live(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
							}
							break;
						case 0:
							switch(Job[i]) {
								case 1:
									GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									break;
								case 2:
									GameAct.Live(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									break;
							}
							break;
						case -1:
							switch(Job[i]) {
								case 1:
									//특수 직업 조사나, 적대인물 조사나, 랜덤 조사
									list = new ArrayList<>();
									for (int j = 0; j < Job_claim.length; j++) {
										if((Job_claim[j]==1 || Job_claim[j]==2) && (Alive.get(1).contains(j) || Alive.get(-1).contains(j)) && i!=j) {
											list.add(j);
										}
									}
									if(!list.isEmpty()) {
										GameAct.Find(i, GameAct.RandomWho(list, i), gameData);
									}else if(!Enemy.get(i).isEmpty()){
										GameAct.Find(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
									}else {
										GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
								case 2:
									GameAct.Live(i, i, gameData);
									break;
							}
							break;
						case -2:
							switch(Job[i]) {
								case 1:
									//적대인물 조사나, 랜덤 조사
									if(!Enemy.get(i).isEmpty()){
										GameAct.Find(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
									}else {
										GameAct.Find(i, GameAct.RandomWho(GameAct.AliveAll(gameData), i), gameData);
									}
									break;
								case 2:
									GameAct.Live(i, i, gameData);
									break;
							}
							break;
						}
					}else if(Alive.get(-1).contains(i)) {
						switch (personal[i]) {
						case 1:
							//경찰 살인이나 랜덤 살인
							list = new ArrayList<>();
							for (int j = 0; j < Job_claim.length; j++) {
								if(Job_claim[j]==1 && Alive.get(1).contains(j) && i!=j) {
									list.add(j);
								}
							}
							if(!list.isEmpty()) {
								GameAct.Kill(i, GameAct.RandomWho(list, i), gameData);
							}else {
								GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							}
							break;
						case 0:
							GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							break;
						case -1:
							//경찰 살인이나, 적대인물 살인이나, 랜덤 살인
							list = new ArrayList<>();
							for (int j = 0; j < Job_claim.length; j++) {
								if(Job_claim[j]==1 && Alive.get(1).contains(j) && i!=j) {
									list.add(j);
								}
							}
							if(!list.isEmpty()) {
								GameAct.Kill(i, GameAct.RandomWho(list, i), gameData);
							}else if(!Enemy.get(i).isEmpty()){
								GameAct.Kill(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
							}else {
								GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							}
							break;
						case -2:
							//적대인물 살인이나, 랜덤 살인
							if(!Enemy.get(i).isEmpty()){
								GameAct.Kill(i, GameAct.RandomWho(Enemy.get(i), i), gameData);
							}else {
								GameAct.Kill(i, GameAct.RandomWho(Alive.get(1), i), gameData);
							}
							break;
						}
					}
				}
			}
		}
			
	}
	
	//낮에 죽은사람 확인
	static boolean Day(Game gameData) {
		if(gameData.getKill()!=gameData.getLive()) {
			GameAct.Kick(gameData.getKill(), gameData);
			return true;
		}
		return false;
	}
	
}